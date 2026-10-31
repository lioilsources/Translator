import 'dart:convert';

import 'protocol.dart';

/// One utterance as both people see it.
class TranscriptEntry {
  TranscriptEntry({
    required this.id,
    required this.at,
    this.side,
    this.lang = '',
    this.original = '',
    this.translation = '',
    this.uncertain = false,
  });

  final int id;
  final DateTime at;
  Side? side;
  String lang;
  String original;
  String translation;
  bool uncertain;

  Map<String, Object?> toJson() => {
    'id': id,
    'at': at.toIso8601String(),
    'side': side?.name,
    'lang': lang,
    'original': original,
    'translation': translation,
    'uncertain': uncertain,
  };

  factory TranscriptEntry.fromJson(Map<String, dynamic> m) => TranscriptEntry(
    id: m['id'] as int,
    at: DateTime.parse(m['at'] as String),
    side: Side.parse(m['side']),
    lang: m['lang'] as String? ?? '',
    original: m['original'] as String? ?? '',
    translation: m['translation'] as String? ?? '',
    uncertain: m['uncertain'] == true,
  );
}

/// A finished or running conversation, stored locally.
class Transcript {
  Transcript({
    required this.id,
    required this.startedAt,
    required this.langA,
    required this.langB,
    List<TranscriptEntry>? entries,
  }) : entries = entries ?? [];

  final String id;
  final DateTime startedAt;
  final String langA;
  final String langB;
  final List<TranscriptEntry> entries;

  String encode() => jsonEncode({
    'id': id,
    'startedAt': startedAt.toIso8601String(),
    'langA': langA,
    'langB': langB,
    'entries': [for (final e in entries) e.toJson()],
  });

  factory Transcript.decode(String s) {
    final m = jsonDecode(s) as Map<String, dynamic>;
    return Transcript(
      id: m['id'] as String,
      startedAt: DateTime.parse(m['startedAt'] as String),
      langA: m['langA'] as String,
      langB: m['langB'] as String,
      entries: [
        for (final e in m['entries'] as List)
          TranscriptEntry.fromJson(e as Map<String, dynamic>),
      ],
    );
  }

  /// Plain text for sharing: both sides, in order.
  String exportText() {
    final b = StringBuffer();
    for (final e in entries) {
      if (e.original.isEmpty) continue;
      final hh = e.at.hour.toString().padLeft(2, '0');
      final mm = e.at.minute.toString().padLeft(2, '0');
      final who = e.side == null ? '?' : (e.side == Side.a ? langA : langB);
      b.writeln('[$hh:$mm] ${who.toUpperCase()}: ${e.original}');
      if (e.translation.isNotEmpty) b.writeln('  → ${e.translation}');
    }
    return b.toString();
  }
}
