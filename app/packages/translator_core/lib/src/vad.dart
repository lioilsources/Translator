import 'dart:math';
import 'dart:typed_data';

/// What the caller should do with a frame.
enum VadEvent { silence, speechStart, speech, speechEnd }

/// RMS level of PCM16LE audio in 0..1.
double rmsLevel(Uint8List pcm) {
  final n = pcm.lengthInBytes ~/ 2;
  if (n == 0) return 0;
  final view = ByteData.sublistView(pcm);
  var sum = 0.0;
  for (var i = 0; i < n; i++) {
    final s = view.getInt16(i * 2, Endian.little) / 32768.0;
    sum += s * s;
  }
  return sqrt(sum / n);
}

/// Energy VAD with an adaptive noise floor.
///
/// Speech must exceed the floor for [startMs], which rejects clicks, and ends
/// after [hangoverMs] of silence. Frames from just before the onset are kept in
/// a pre-roll, otherwise the first syllable is lost.
class EnergyVad {
  EnergyVad({
    this.sampleRate = 16000,
    this.startMs = 120,
    this.hangoverMs = 700,
    this.preRollMs = 300,
    this.ratio = 3.0,
    this.minThreshold = 0.008,
  });

  final int sampleRate;
  final int startMs;
  final int hangoverMs;
  final int preRollMs;
  final double ratio;
  final double minThreshold;

  double _floor = 0.003;
  double _voicedMs = 0;
  double _silentMs = 0;
  bool _inSpeech = false;
  final List<Uint8List> _preRoll = [];
  double _preRollFrameMs = 0;

  bool get inSpeech => _inSpeech;

  /// Frames from before the onset, valid right after [VadEvent.speechStart].
  List<Uint8List> takePreRoll() {
    final out = List<Uint8List>.of(_preRoll);
    _preRoll.clear();
    return out;
  }

  VadEvent push(Uint8List pcm) {
    final frameMs = pcm.lengthInBytes / 2 / sampleRate * 1000;
    final level = rmsLevel(pcm);
    final loud = level > max(_floor * ratio, minThreshold);

    if (_inSpeech) {
      _silentMs = loud ? 0 : _silentMs + frameMs;
      if (_silentMs >= hangoverMs) {
        reset();
        return VadEvent.speechEnd;
      }
      return VadEvent.speech;
    }

    if (loud) {
      _voicedMs += frameMs;
      if (_voicedMs >= startMs) {
        _inSpeech = true;
        _silentMs = 0;
        _preRoll.add(pcm);
        return VadEvent.speechStart;
      }
    } else {
      _voicedMs = 0;
      _floor = _floor * 0.95 + level * 0.05;
    }
    _preRoll.add(pcm);
    _preRollFrameMs = frameMs;
    final keep = _preRollFrameMs <= 0 ? 1 : (preRollMs / _preRollFrameMs).ceil();
    while (_preRoll.length > keep) {
      _preRoll.removeAt(0);
    }
    return VadEvent.silence;
  }

  /// Forgets the current segment but keeps the learned noise floor.
  void reset() {
    _inSpeech = false;
    _voicedMs = 0;
    _silentMs = 0;
    _preRoll.clear();
  }
}
