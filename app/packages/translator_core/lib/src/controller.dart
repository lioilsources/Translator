import 'dart:async';
import 'dart:typed_data';

import 'conversation.dart';
import 'protocol.dart';
import 'transcript.dart';
import 'vad.dart';

/// Connection to the server. Text frames are String, binary are Uint8List.
abstract interface class Transport {
  Stream<Object> get frames;
  void sendText(String text);
  void sendBinary(Uint8List data);
  Future<void> close();
}

/// Plays one encoded clip and completes when it has finished.
abstract interface class ClipPlayer {
  Future<void> play(Uint8List clip, String format);
  Future<void> stop();
}

/// Delays used by the controller, injectable so tests need no real time.
typedef Delay = Future<void> Function(Duration);

/// Glue between microphone, VAD, server and speaker.
///
/// The echo rule lives here: while clips play and for [echoTail] after, the
/// microphone is discarded, so the phone never translates its own voice.
class ConversationController {
  ConversationController({
    required this.transport,
    required this.player,
    required this.state,
    required this.mode,
    required this.onChanged,
    EnergyVad? vad,
    Delay? delay,
    this.echoTail = const Duration(milliseconds: 300),
  }) : _vad = vad ?? EnergyVad(),
       _delay = delay ?? Future<void>.delayed;

  final Transport transport;
  final ClipPlayer player;
  final ConversationState state;
  final Mode mode;
  final void Function() onChanged;
  final Duration echoTail;
  final EnergyVad _vad;
  final Delay _delay;

  StreamSubscription<Object>? _sub;
  final List<Uint8List> _clips = [];
  String _clipFormat = 'mp3';
  bool _playing = false;
  bool _ttsOpen = false;
  bool _muted = false;
  bool _paused = false;
  bool ttsEnabled = true;
  Side? _held;
  double level = 0;

  bool get micOpen => !_muted && !_paused;
  bool get paused => _paused;

  void start({
    required String deviceId,
    required String langA,
    required String langB,
    String? voiceA,
    String? voiceB,
  }) {
    _sub = transport.frames.listen(_onFrame, onError: (_) => _lost(), onDone: _lost);
    transport.sendText(
      ClientMessage.start(
        deviceId: deviceId,
        langA: langA,
        langB: langB,
        mode: mode,
        tts: ttsEnabled,
        voiceA: voiceA,
        voiceB: voiceB,
      ),
    );
  }

  void _lost() {
    state.lastError ??= 'connection_lost';
    onChanged();
  }

  /// Feed from the microphone stream.
  void onMicFrame(Uint8List pcm) {
    level = rmsLevel(pcm);
    if (!micOpen) {
      onChanged();
      return;
    }
    if (mode == Mode.ptt) {
      if (_held != null) transport.sendBinary(pcm);
      onChanged();
      return;
    }
    switch (_vad.push(pcm)) {
      case VadEvent.silence:
        break;
      case VadEvent.speechStart:
        _vad.takePreRoll().forEach(transport.sendBinary);
        state.phase = Phase.recording;
      case VadEvent.speech:
        transport.sendBinary(pcm);
      case VadEvent.speechEnd:
        transport.sendText(ClientMessage.audioEnd());
        state.phase = Phase.translating;
    }
    onChanged();
  }

  /// Push-to-talk: finger down on a half.
  void holdStart(Side side) {
    if (mode != Mode.ptt || !micOpen) return;
    _held = side;
    state
      ..activeSide = side
      ..phase = Phase.recording;
    onChanged();
  }

  /// Push-to-talk: finger up.
  void holdEnd() {
    final side = _held;
    if (side == null) return;
    _held = null;
    transport.sendText(ClientMessage.audioEnd(side: side));
    state.phase = Phase.translating;
    onChanged();
  }

  /// Long press: "this is me talking", or "that was me" for an uncertain line.
  void force(Side side) {
    state.uncertain?.uncertain = false;
    transport.sendText(ClientMessage.force(side));
    onChanged();
  }

  void setTts({required bool enabled}) {
    ttsEnabled = enabled;
    transport.sendText(ClientMessage.config(tts: enabled));
    if (!enabled) {
      _clips.clear();
      unawaited(player.stop());
    }
    onChanged();
  }

  void setPaused({required bool paused}) {
    if (paused == _paused) return;
    _paused = paused;
    if (paused) {
      if (_vad.inSpeech) transport.sendText(ClientMessage.audioCancel());
      _vad.reset();
      state.phase = Phase.paused;
    } else {
      state.phase = Phase.listening;
    }
    onChanged();
  }

  void _onFrame(Object frame) {
    if (frame is Uint8List) {
      _clips.add(frame);
      unawaited(_drainClips());
      return;
    }
    final ev = ServerEvent.parse(frame as String);
    if (ev == null) return;
    switch (ev) {
      case TtsStart():
        _clipFormat = ev.format;
        _ttsOpen = true;
        _mute();
      case TtsEnd():
        _ttsOpen = false;
        unawaited(_drainClips());
      default:
        break;
    }
    state.apply(ev);
    if (ev is TtsStart && _paused) state.phase = Phase.paused;
    onChanged();
  }

  void _mute() {
    if (_muted) return;
    _muted = true;
    if (_vad.inSpeech) transport.sendText(ClientMessage.audioCancel());
    _vad.reset();
  }

  Future<void> _drainClips() async {
    if (_playing) return;
    _playing = true;
    try {
      while (_clips.isNotEmpty) {
        final clip = _clips.removeAt(0);
        try {
          await player.play(clip, _clipFormat);
        } on Object {
          state.lastError = 'playback_failed';
          onChanged();
        }
      }
    } finally {
      _playing = false;
    }
    if (_ttsOpen || !_muted) return;
    await _delay(echoTail);
    if (_ttsOpen || _clips.isNotEmpty || _playing) return;
    _muted = false;
    onChanged();
  }

  Future<void> close() async {
    transport.sendText(ClientMessage.end());
    await _sub?.cancel();
    await player.stop();
    await transport.close();
  }
}

/// Local conversation history.
abstract interface class TranscriptStore {
  Future<void> save(Transcript t);
  Future<List<Transcript>> list();
  Future<void> delete(String id);
}
