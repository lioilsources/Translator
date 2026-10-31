import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/ui/conversation_view.dart';
import 'package:translator_core/translator_core.dart';

class _Transport implements Transport {
  final sent = <String>[];
  final _c = StreamController<Object>();
  @override
  Stream<Object> get frames => _c.stream;
  @override
  void sendText(String text) => sent.add(text);
  @override
  void sendBinary(Uint8List data) {}
  @override
  Future<void> close() async {}
}

class _Player implements ClipPlayer {
  @override
  Future<void> play(Uint8List clip, String format) async {}
  @override
  Future<void> stop() async {}
}

({ConversationController c, _Transport t}) _make(Mode mode) {
  final t = _Transport();
  final c = ConversationController(
    transport: t,
    player: _Player(),
    state: ConversationState(
      Transcript(
        id: 'x',
        startedAt: DateTime(2026),
        langA: 'cs',
        langB: 'en',
      ),
    ),
    mode: mode,
    onChanged: () {},
  );
  return (c: c, t: t);
}

Future<void> _pump(WidgetTester tester, ConversationController c) =>
    tester.pumpWidget(
      MaterialApp(
        locale: const Locale('cs'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ConversationView(controller: c, onEnd: () {}),
      ),
    );

void main() {
  testWidgets('top half is rotated 180 degrees', (tester) async {
    await _pump(tester, _make(Mode.auto).c);
    final box = tester.widget<RotatedBox>(find.byKey(const Key('half-b')));
    expect(box.quarterTurns, 2);
  });

  testWidgets('each half leads with its reader language', (tester) async {
    final r = _make(Mode.auto);
    r.c.state
      ..apply(const AsrFinal(1, Side.a, 'cs', 'Ahoj', .9, uncertain: false))
      ..apply(const MtText(1, Side.a, 'Hello', isFinal: true));
    await _pump(tester, r.c);

    Text big(String s) => tester.widget<Text>(find.text(s).first);
    final top = find.byKey(const Key('half-b'));
    final bottom = find.byKey(const Key('half-a'));
    double size(Finder half, String s) => tester
        .widget<Text>(find.descendant(of: half, matching: find.text(s)))
        .style!
        .fontSize!;

    expect(big('Hello'), isNotNull);
    // Bottom is the speaker: own words large. Top reads the translation large.
    expect(size(bottom, 'Ahoj'), greaterThan(size(bottom, 'Hello')));
    expect(size(top, 'Hello'), greaterThan(size(top, 'Ahoj')));
  });

  testWidgets('uncertain line offers "that was me" on both halves', (
    tester,
  ) async {
    final r = _make(Mode.auto);
    r.c.state.apply(const AsrFinal(1, null, 'cs', 'Hm', .4, uncertain: true));
    await _pump(tester, r.c);
    expect(find.text('To jsem já'), findsNWidgets(2));

    final top = find.byKey(const Key('half-b'));
    await tester.tap(
      find.descendant(of: top, matching: find.text('To jsem já')),
    );
    expect(r.t.sent.last, contains('"side":"b"'));
  });

  testWidgets('long press forces the side in auto mode', (tester) async {
    final r = _make(Mode.auto);
    await _pump(tester, r.c);
    await tester.longPress(find.byKey(const Key('half-a')));
    expect(r.t.sent.last, contains('speaker.force'));
    expect(r.t.sent.last, contains('"side":"a"'));
  });

  testWidgets('push to talk sends audio.end with the held side', (
    tester,
  ) async {
    final r = _make(Mode.ptt);
    await _pump(tester, r.c);
    final g = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('half-b'))),
    );
    await g.up();
    expect(r.t.sent.last, contains('audio.end'));
    expect(r.t.sent.last, contains('"side":"b"'));
  });

  testWidgets('backend error is shown', (tester) async {
    final r = _make(Mode.auto);
    r.c.state.apply(const ServerError(1, 'mt_unavailable'));
    await _pump(tester, r.c);
    expect(find.text('Překladová služba teď není dostupná'), findsOneWidget);
  });
}
