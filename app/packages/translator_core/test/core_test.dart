import 'dart:async';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:translator_core/translator_core.dart';

Uint8List tone(double amp, {int ms = 30}) {
  final n = 16 * ms;
  final d = ByteData(n * 2);
  for (var i = 0; i < n; i++) {
    d.setInt16(i * 2, ((i.isEven ? amp : -amp) * 32767).round(), Endian.little);
  }
  return d.buffer.asUint8List();
}

class FakeTransport implements Transport {
  final ctrl = StreamController<Object>();
  final texts = <String>[];
  final bins = <Uint8List>[];
  @override
  Stream<Object> get frames => ctrl.stream;
  @override
  void sendText(String t) => texts.add(t);
  @override
  void sendBinary(Uint8List d) => bins.add(d);
  @override
  Future<void> close() async {}
}

class FakePlayer implements ClipPlayer {
  final played = <Uint8List>[];
  Completer<void>? gate;
  @override
  Future<void> play(Uint8List clip, String format) async {
    played.add(clip);
    await gate?.future;
  }

  @override
  Future<void> stop() async {}
}

Transcript transcript() => Transcript(
  id: 'x',
  startedAt: DateTime(2026),
  langA: 'cs',
  langB: 'en',
);

void main() {
  group('vad', () {
    test('silence stays silent', () {
      final v = EnergyVad();
      for (var i = 0; i < 100; i++) {
        expect(v.push(tone(0.001)), VadEvent.silence);
      }
    });

    test('click does not start speech', () {
      final v = EnergyVad();
      expect(v.push(tone(0.5)), VadEvent.silence);
      expect(v.push(tone(0.001)), VadEvent.silence);
      expect(v.inSpeech, isFalse);
    });

    test('speech starts, keeps pre-roll, ends after 700 ms', () {
      final v = EnergyVad();
      for (var i = 0; i < 20; i++) {
        v.push(tone(0.001));
      }
      final events = [for (var i = 0; i < 4; i++) v.push(tone(0.2))];
      expect(events, contains(VadEvent.speechStart));
      expect(v.takePreRoll().length, greaterThan(4));
      var frames = 0;
      while (v.push(tone(0.001)) != VadEvent.speechEnd) {
        frames++;
        expect(frames, lessThan(30));
      }
      expect(frames, 23);
    });

    test('noise floor adapts so steady noise is not speech', () {
      final v = EnergyVad();
      for (var i = 0; i < 200; i++) {
        v.push(tone(0.02));
        v.reset();
      }
      expect(v.push(tone(0.02)), VadEvent.silence);
    });
  });

  group('protocol', () {
    test('parses asr.final', () {
      final ev = ServerEvent.parse(
        '{"type":"asr.final","utteranceId":3,"side":"b","lang":"en",'
        '"text":"hi","confidence":0.9,"uncertain":false}',
      );
      expect(ev, isA<AsrFinal>());
      expect((ev! as AsrFinal).side, Side.b);
    });

    test('unknown type is ignored', () {
      expect(ServerEvent.parse('{"type":"future.thing"}'), isNull);
    });
  });

  group('state', () {
    test('utterance flows into one transcript entry', () {
      final s = ConversationState(transcript());
      s.apply(const SessionReady());
      s.apply(const AsrFinal(1, Side.a, 'cs', 'Ahoj', .9, uncertain: false));
      s.apply(const MtText(1, Side.a, 'Hi', isFinal: false));
      s.apply(const MtText(1, Side.a, 'Hi there', isFinal: true));
      s.apply(const UtteranceEnd(1, 'ok'));
      expect(s.transcript.entries.single.translation, 'Hi there');
      expect(s.phase, Phase.listening);
    });

    test('forced uncertain line resolves the same entry', () {
      final s = ConversationState(transcript());
      s.apply(const AsrFinal(1, null, 'cs', 'Hm', .4, uncertain: true));
      expect(s.uncertain, isNotNull);
      s.apply(const AsrFinal(1, Side.b, 'en', 'Hm', 1, uncertain: false));
      expect(s.uncertain, isNull);
      expect(s.transcript.entries, hasLength(1));
    });
  });

  group('transcript', () {
    test('round trip and export', () {
      final t = transcript();
      t.entries.add(
        TranscriptEntry(
          id: 1,
          at: DateTime(2026, 1, 1, 9, 5),
          side: Side.b,
          original: 'Hello',
          translation: 'Ahoj',
        ),
      );
      final r = Transcript.decode(t.encode());
      expect(r.entries.single.side, Side.b);
      expect(r.exportText(), '[09:05] EN: Hello\n  → Ahoj\n');
    });
  });

  group('controller', () {
    late FakeTransport tr;
    late FakePlayer pl;
    late ConversationController c;
    late Completer<void> tail;

    ConversationController make(Mode mode) => ConversationController(
      transport: tr,
      player: pl,
      state: ConversationState(transcript()),
      mode: mode,
      onChanged: () {},
      delay: (_) => tail.future,
    );

    setUp(() {
      tr = FakeTransport();
      pl = FakePlayer();
      tail = Completer();
    });

    void speak() {
      for (var i = 0; i < 6; i++) {
        c.onMicFrame(tone(0.2));
      }
    }

    test('auto: sends audio and audio.end after silence', () {
      c = make(Mode.auto)..start(deviceId: 'd', langA: 'cs', langB: 'en');
      speak();
      expect(tr.bins, isNotEmpty);
      for (var i = 0; i < 25; i++) {
        c.onMicFrame(tone(0.001));
      }
      expect(tr.texts.last, contains('audio.end'));
    });

    test('mic is muted during playback and 300 ms tail', () async {
      c = make(Mode.auto)..start(deviceId: 'd', langA: 'cs', langB: 'en');
      tr.ctrl.add('{"type":"tts.start","utteranceId":1,"seq":0,"format":"mp3"}');
      tr.ctrl.add(Uint8List(4));
      tr.ctrl.add('{"type":"tts.end","utteranceId":1}');
      await pumpEventQueue();
      expect(pl.played, hasLength(1));
      expect(c.micOpen, isFalse);
      final sent = tr.bins.length;
      speak();
      expect(tr.bins.length, sent);
      tail.complete();
      await pumpEventQueue();
      expect(c.micOpen, isTrue);
    });

    test('two clips play in order and mic stays muted between', () async {
      pl.gate = Completer();
      c = make(Mode.auto)..start(deviceId: 'd', langA: 'cs', langB: 'en');
      tr.ctrl.add('{"type":"tts.start","utteranceId":1,"seq":0,"format":"mp3"}');
      tr.ctrl.add(Uint8List.fromList([1]));
      tr.ctrl.add('{"type":"tts.start","utteranceId":1,"seq":1,"format":"mp3"}');
      tr.ctrl.add(Uint8List.fromList([2]));
      tr.ctrl.add('{"type":"tts.end","utteranceId":1}');
      await pumpEventQueue();
      expect(pl.played, hasLength(1));
      pl.gate!.complete();
      tail.complete();
      await pumpEventQueue();
      expect(pl.played.map((c) => c.first), [1, 2]);
      expect(c.micOpen, isTrue);
    });

    test('ptt: sends only while held and tags the side', () {
      c = make(Mode.ptt)..start(deviceId: 'd', langA: 'cs', langB: 'en');
      c.onMicFrame(tone(0.2));
      expect(tr.bins, isEmpty);
      c.holdStart(Side.b);
      c.onMicFrame(tone(0.2));
      expect(tr.bins, hasLength(1));
      c.holdEnd();
      expect(tr.texts.last, contains('"side":"b"'));
    });

    test('pause cancels speech in progress', () {
      c = make(Mode.auto)..start(deviceId: 'd', langA: 'cs', langB: 'en');
      speak();
      c.setPaused(paused: true);
      expect(tr.texts.last, contains('audio.cancel'));
      final sent = tr.bins.length;
      speak();
      expect(tr.bins.length, sent);
    });

    test('connection loss is reported', () async {
      c = make(Mode.auto)..start(deviceId: 'd', langA: 'cs', langB: 'en');
      await tr.ctrl.close();
      await pumpEventQueue();
      expect(c.state.lastError, 'connection_lost');
    });
  });
}
