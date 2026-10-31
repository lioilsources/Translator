import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart' as session;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_core/translator_core.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

const _defaultUrl = String.fromEnvironment(
  'TRANSLATOR_URL',
  defaultValue: 'wss://translator.ol1n.com/v1/ws',
);
const _defaultToken = String.fromEnvironment('TRANSLATOR_TOKEN');

/// WebSocket transport; binary frames arrive as Uint8List.
class WsTransport implements Transport {
  WsTransport(String url, String token)
    : _channel = IOWebSocketChannel.connect(
        url,
        headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
        pingInterval: const Duration(seconds: 15),
      );

  final IOWebSocketChannel _channel;

  @override
  Stream<Object> get frames => _channel.stream.map((f) {
    if (f is String) return f;
    return f is Uint8List ? f : Uint8List.fromList(f as List<int>);
  });

  @override
  void sendText(String text) => _channel.sink.add(text);

  @override
  void sendBinary(Uint8List data) => _channel.sink.add(data);

  @override
  Future<void> close() => _channel.sink.close();
}

/// Microphone as 16 kHz mono PCM16 with the platform echo canceller on.
class MicCapture {
  final _rec = AudioRecorder();
  StreamSubscription<Uint8List>? _sub;

  Future<bool> hasPermission() => _rec.hasPermission();

  Future<void> start(void Function(Uint8List) onFrame) async {
    final audio = await session.AudioSession.instance;
    await audio.configure(
      const session.AudioSessionConfiguration(
        avAudioSessionCategory: session.AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            session.AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: session.AVAudioSessionMode.voiceChat,
      ),
    );
    final stream = await _rec.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
        echoCancel: true,
        noiseSuppress: true,
      ),
    );
    _sub = stream.listen(onFrame);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    await _rec.stop();
    await _rec.dispose();
  }
}

/// Plays a clip from a temp file. Whole clips, so no streaming source needed.
class JustAudioClipPlayer implements ClipPlayer {
  final _player = AudioPlayer();
  int _n = 0;

  @override
  Future<void> play(Uint8List clip, String format) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/tts_${_n++ % 8}.$format');
    await file.writeAsBytes(clip, flush: true);
    await _player.setFilePath(file.path);
    await _player.seek(Duration.zero);
    await _player.play();
    await _player.stop();
  }

  @override
  Future<void> stop() => _player.stop();
}

/// Persisted user choices.
class Settings {
  Settings(this._prefs);

  static Future<Settings> load() async =>
      Settings(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  String get url => _prefs.getString('url') ?? _defaultUrl;
  set url(String v) => _prefs.setString('url', v);

  String get token => _prefs.getString('token') ?? _defaultToken;
  set token(String v) => _prefs.setString('token', v);

  String get langA => _prefs.getString('langA') ?? 'cs';
  set langA(String v) => _prefs.setString('langA', v);

  String get langB => _prefs.getString('langB') ?? 'en';
  set langB(String v) => _prefs.setString('langB', v);

  Mode get mode => Mode.values.asNameMap()[_prefs.getString('mode')] ?? Mode.auto;
  set mode(Mode v) => _prefs.setString('mode', v.name);

  List<String> get recentLangs => _prefs.getStringList('recent') ?? const [];
  void noteLang(String lang) => _prefs.setStringList('recent', [
    lang,
    ...recentLangs.where((l) => l != lang),
  ].take(4).toList());

  String get deviceId {
    final id = _prefs.getString('deviceId');
    if (id != null) return id;
    final fresh = const Uuid().v4();
    _prefs.setString('deviceId', fresh);
    return fresh;
  }
}

/// History as one JSON file per conversation, on the device only.
class FileTranscriptStore implements TranscriptStore {
  Future<Directory> _dir() async {
    final base = await getApplicationSupportDirectory();
    return Directory('${base.path}/history').create(recursive: true);
  }

  @override
  Future<void> save(Transcript t) async {
    final dir = await _dir();
    await File('${dir.path}/${t.id}.json').writeAsString(t.encode(), flush: true);
  }

  @override
  Future<List<Transcript>> list() async {
    final dir = await _dir();
    final out = <Transcript>[];
    await for (final f in dir.list()) {
      if (f is! File || !f.path.endsWith('.json')) continue;
      try {
        out.add(Transcript.decode(await f.readAsString(encoding: utf8)));
      } on FormatException {
        continue; // a damaged file must not hide the rest of the history
      }
    }
    return out..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  @override
  Future<void> delete(String id) async {
    final dir = await _dir();
    await File('${dir.path}/$id.json').delete();
  }
}
