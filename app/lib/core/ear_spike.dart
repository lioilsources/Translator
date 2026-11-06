// Fáze 0 plánu Ucho: měření, které nezávisí na platformě.
import 'dart:math';
import 'dart:typed_data';

/// Where a test clip was played.
enum SpikeOutput { ear, speaker }

/// One played clip and what happened around it.
class SpikeResult {
  const SpikeResult({
    required this.output,
    required this.switchMs,
    required this.backMs,
    required this.micGapMs,
    required this.outputs,
  });

  final SpikeOutput output;

  /// From the override call until the route showed the speaker; 0 for ear.
  final int switchMs;

  /// From removing the override until the speaker left the route; 0 for ear.
  final int backMs;

  /// Longest pause between microphone frames while this clip was handled.
  final int micGapMs;

  /// Output port types seen while the clip played, e.g. `bluetoothA2dp`.
  final List<String> outputs;

  /// Bluetooth fell back to the call profile, so the ear would get phone quality.
  bool get hfp => outputs.contains('bluetoothHfp');

  String toLine() =>
      '${output.name}: switch ${switchMs}ms, back ${backMs}ms, '
      'mic gap ${micGapMs}ms, out ${outputs.join('+')}';
}

/// Median and maximum of a list, both 0 when empty.
({int p50, int max}) spread(List<int> values) {
  if (values.isEmpty) return (p50: 0, max: 0);
  final s = [...values]..sort();
  return (p50: s[s.length ~/ 2], max: s.last);
}

/// Text report for sharing, one line per clip and a summary per output.
String spikeReport(String config, List<SpikeResult> results) {
  final b = StringBuffer('Ucho spike: $config\n');
  for (final out in SpikeOutput.values) {
    final rows = results.where((r) => r.output == out).toList();
    if (rows.isEmpty) continue;
    final sw = spread([for (final r in rows) r.switchMs]);
    final back = spread([for (final r in rows) r.backMs]);
    final gap = spread([for (final r in rows) r.micGapMs]);
    b.writeln(
      '${out.name} ×${rows.length}: switch p50 ${sw.p50} max ${sw.max}, '
      'back p50 ${back.p50} max ${back.max}, mic gap max ${gap.max}, '
      'hfp ${rows.where((r) => r.hfp).length}',
    );
  }
  for (final r in results) {
    b.writeln(r.toLine());
  }
  return b.toString();
}

/// Two short tones as 16-bit mono WAV, so clicks and cut-offs are audible.
Uint8List beepWav({int rate = 24000}) {
  final samples = <int>[];
  void tone(double hz, int ms) {
    final n = rate * ms ~/ 1000;
    for (var i = 0; i < n; i++) {
      final fade = min(1.0, min(i, n - i) / (rate * 0.01));
      samples.add((sin(2 * pi * hz * i / rate) * 12000 * fade).round());
    }
  }

  void silence(int ms) => samples.addAll(List.filled(rate * ms ~/ 1000, 0));
  tone(660, 250);
  silence(120);
  tone(880, 350);
  final data = samples.length * 2;
  final bytes = ByteData(44 + data);
  void ascii(int at, String s) {
    for (var i = 0; i < s.length; i++) {
      bytes.setUint8(at + i, s.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  bytes.setUint32(4, 36 + data, Endian.little);
  ascii(8, 'WAVEfmt ');
  bytes
    ..setUint32(16, 16, Endian.little)
    ..setUint16(20, 1, Endian.little)
    ..setUint16(22, 1, Endian.little)
    ..setUint32(24, rate, Endian.little)
    ..setUint32(28, rate * 2, Endian.little)
    ..setUint16(32, 2, Endian.little)
    ..setUint16(34, 16, Endian.little);
  ascii(36, 'data');
  bytes.setUint32(40, data, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    bytes.setInt16(44 + i * 2, samples[i], Endian.little);
  }
  return bytes.buffer.asUint8List();
}
