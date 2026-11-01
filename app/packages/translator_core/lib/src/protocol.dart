import 'dart:convert';

/// A participant. [a] is the phone owner (bottom), [b] the colleague (top).
enum Side {
  a,
  b;

  Side get other => this == a ? b : a;

  static Side? parse(Object? v) => switch (v) {
    'a' => a,
    'b' => b,
    _ => null,
  };
}

enum Mode { auto, ptt, streaming }

/// Client to server frames.
abstract final class ClientMessage {
  static String start({
    required String deviceId,
    required String langA,
    required String langB,
    required Mode mode,
    required bool tts,
    String? voiceA,
    String? voiceB,
  }) => jsonEncode({
    'type': 'session.start',
    'deviceId': deviceId,
    'langA': langA,
    'langB': langB,
    'mode': mode.name,
    'tts': tts,
    'voiceA': ?voiceA,
    'voiceB': ?voiceB,
  });

  static String audioEnd({Side? side}) => jsonEncode({
    'type': 'audio.end',
    if (side != null) 'side': side.name,
  });

  static String audioCancel() => jsonEncode({'type': 'audio.cancel'});

  static String force(Side side) =>
      jsonEncode({'type': 'speaker.force', 'side': side.name});

  static String config({required bool tts}) =>
      jsonEncode({'type': 'session.config', 'tts': tts});

  static String end() => jsonEncode({'type': 'session.end'});
}

/// Server to client frames.
sealed class ServerEvent {
  const ServerEvent();

  /// Returns null for unknown types so old clients survive new messages.
  static ServerEvent? parse(String frame) {
    final m = jsonDecode(frame) as Map<String, dynamic>;
    final id = (m['utteranceId'] as num?)?.toInt() ?? 0;
    final side = Side.parse(m['side']);
    final text = m['text'] as String? ?? '';
    switch (m['type']) {
      case 'session.ready':
        return const SessionReady();
      case 'asr.partial':
        return AsrPartial(side, text);
      case 'asr.final':
        return AsrFinal(
          id,
          side,
          m['lang'] as String? ?? '',
          text,
          (m['confidence'] as num?)?.toDouble() ?? 0,
          uncertain: m['uncertain'] == true,
        );
      case 'mt.partial':
        return MtText(id, side ?? Side.a, text, isFinal: false);
      case 'mt.final':
        return MtText(id, side ?? Side.a, text, isFinal: true);
      case 'tts.start':
        return TtsStart(id, m['format'] as String? ?? 'mp3');
      case 'tts.end':
        return TtsEnd(id);
      case 'utterance.end':
        return UtteranceEnd(id, m['status'] as String? ?? '');
      case 'error':
        return ServerError(id, m['code'] as String? ?? 'unknown');
    }
    return null;
  }
}

final class SessionReady extends ServerEvent {
  const SessionReady();
}

final class AsrPartial extends ServerEvent {
  const AsrPartial(this.side, this.text);
  final Side? side;
  final String text;
}

final class AsrFinal extends ServerEvent {
  const AsrFinal(
    this.id,
    this.side,
    this.lang,
    this.text,
    this.confidence, {
    required this.uncertain,
  });
  final int id;
  final Side? side;
  final String lang;
  final String text;
  final double confidence;
  final bool uncertain;
}

final class MtText extends ServerEvent {
  const MtText(this.id, this.side, this.text, {required this.isFinal});
  final int id;
  final Side side;
  final String text;
  final bool isFinal;
}

final class TtsStart extends ServerEvent {
  const TtsStart(this.id, this.format);
  final int id;
  final String format;
}

final class TtsEnd extends ServerEvent {
  const TtsEnd(this.id);
  final int id;
}

final class UtteranceEnd extends ServerEvent {
  const UtteranceEnd(this.id, this.status);
  final int id;
  final String status;
}

final class ServerError extends ServerEvent {
  const ServerError(this.id, this.code);
  final int id;
  final String code;
}
