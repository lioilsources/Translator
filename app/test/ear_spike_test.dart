import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:translator_app/core/ear_spike.dart';

void main() {
  test('beepWav is a valid 16-bit mono WAV of about 0.7 s', () {
    final wav = beepWav();
    final b = ByteData.sublistView(wav);
    expect(String.fromCharCodes(wav.sublist(0, 4)), 'RIFF');
    expect(String.fromCharCodes(wav.sublist(8, 12)), 'WAVE');
    expect(b.getUint16(22, Endian.little), 1);
    expect(b.getUint16(34, Endian.little), 16);
    final rate = b.getUint32(24, Endian.little);
    final data = b.getUint32(40, Endian.little);
    expect(data, wav.length - 44);
    expect(data / 2 / rate, closeTo(0.72, 0.01));
  });

  test('spread gives median and max', () {
    expect(spread([]), (p50: 0, max: 0));
    expect(spread([30, 10, 20]), (p50: 20, max: 30));
  });

  test('report summarises per output and flags HFP fallback', () {
    final report = spikeReport('mode default', const [
      SpikeResult(
        output: SpikeOutput.ear,
        switchMs: 0,
        backMs: 0,
        micGapMs: 40,
        outputs: ['bluetoothA2dp'],
      ),
      SpikeResult(
        output: SpikeOutput.speaker,
        switchMs: 120,
        backMs: 300,
        micGapMs: 250,
        outputs: ['builtInSpeaker'],
      ),
      SpikeResult(
        output: SpikeOutput.speaker,
        switchMs: 200,
        backMs: 100,
        micGapMs: 90,
        outputs: ['bluetoothHfp'],
      ),
    ]);
    expect(report, contains('ear ×1: switch p50 0 max 0'));
    expect(
      report,
      contains(
        'speaker ×2: switch p50 200 max 200, '
        'back p50 300 max 300, mic gap max 250, hfp 1',
      ),
    );
  });
}
