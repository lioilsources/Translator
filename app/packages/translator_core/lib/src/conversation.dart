import 'protocol.dart';
import 'transcript.dart';

enum Phase { connecting, listening, recording, translating, speaking, paused }

/// Reduces server events to what the screen shows. Pure and synchronous.
class ConversationState {
  ConversationState(this.transcript, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final Transcript transcript;
  final DateTime Function() _clock;
  final Map<int, TranscriptEntry> _byId = {};

  Phase phase = Phase.connecting;
  Side? activeSide;
  String partial = '';
  String? lastError;

  /// The utterance waiting for "that was me".
  TranscriptEntry? get uncertain {
    for (final e in transcript.entries.reversed) {
      if (e.uncertain) return e;
    }
    return null;
  }

  void apply(ServerEvent ev) {
    switch (ev) {
      case SessionReady():
        phase = Phase.listening;
      case AsrPartial(:final side, :final text):
        partial = text;
        if (side != null) activeSide = side;
      case AsrFinal():
        partial = '';
        final e = _entry(ev.id);
        e
          ..side = ev.side
          ..lang = ev.lang
          ..original = ev.text
          ..uncertain = ev.uncertain;
        activeSide = ev.side;
        phase = Phase.translating;
      case MtText(:final id, :final text):
        _entry(id).translation = text;
      case TtsStart():
        phase = Phase.speaking;
      case TtsEnd():
        break;
      case UtteranceEnd():
        partial = '';
        if (phase != Phase.paused) phase = Phase.listening;
        activeSide = null;
      case ServerError(:final code):
        lastError = code;
    }
  }

  TranscriptEntry _entry(int id) => _byId.putIfAbsent(id, () {
    final e = TranscriptEntry(id: id, at: _clock());
    transcript.entries.add(e);
    return e;
  });
}
