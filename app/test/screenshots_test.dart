@Tags(['screenshots'])
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/ui/conversation_view.dart';
import 'package:translator_app/ui/screens.dart';
import 'package:translator_app/ui/voices.dart';
import 'package:translator_core/translator_core.dart';

/// Renders the main screens to PNGs for the store page (olin.now/tlumocnik):
///
///     SCREENSHOT_DIR=/tmp/shots flutter test test/screenshots_test.dart
///
/// Without SCREENSHOT_DIR every test is skipped, so the normal
/// `flutter test` never depends on pixels. The screens are the app's own
/// widgets; only the conversations are fixtures.
final _dir = Platform.environment['SCREENSHOT_DIR'];

const _phone = Size(390, 844); // iPhone 14/15, rendered @3x
const _ratio = 3.0;

final _shotKey = GlobalKey();

Future<void> _loadFonts() async {
  // The test environment otherwise draws every glyph as a box.
  final dir = '${Platform.environment['FLUTTER_ROOT']!}/bin/cache/artifacts/material_fonts';
  Future<ByteData> read(String path) async => ByteData.sublistView(File(path).readAsBytesSync());
  final roboto = FontLoader('Roboto');
  for (final w in ['Regular', 'Medium', 'Bold', 'Italic']) {
    roboto.addFont(read('$dir/Roboto-$w.ttf'));
  }
  await roboto.load();
  await (FontLoader('MaterialIcons')..addFont(read('$dir/MaterialIcons-Regular.otf'))).load();
  // Flags in the language cards, 日本語 and 中文 in the picker.
  await (FontLoader('AppleColorEmoji')..addFont(read('/System/Library/Fonts/Apple Color Emoji.ttc'))).load();
  await (FontLoader('HiraginoSansGB')..addFont(read('/System/Library/Fonts/Hiragino Sans GB.ttc'))).load();
}

ThemeData _theme() => ThemeData(
  colorSchemeSeed: const Color(0xFF2E7D6B),
  brightness: Brightness.light,
  fontFamily: 'Roboto',
  fontFamilyFallback: const ['AppleColorEmoji', 'HiraginoSansGB'],
);

class _Transport implements Transport {
  @override
  Stream<Object> get frames => const Stream.empty();
  @override
  void sendText(String text) {}
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

typedef _Line = (Side side, String lang, String original, String translation);

/// A controller that has already lived through [lines], at fixed times.
ConversationController _conversation(
  String langA,
  String langB,
  List<_Line> lines, {
  _Line? uncertain,
}) {
  var minute = 0;
  final state = ConversationState(
    Transcript(id: 'shot', startedAt: DateTime(2026, 10, 31, 14, 2), langA: langA, langB: langB),
    clock: () => DateTime(2026, 10, 31, 14, 2 + minute++),
  )..apply(const SessionReady());
  var id = 0;
  for (final (side, lang, original, translation) in lines) {
    id++;
    state
      ..apply(AsrFinal(id, side, lang, original, .95, uncertain: false))
      ..apply(MtText(id, side, translation, isFinal: true))
      ..apply(TtsStart(id, 'mp3'));
  }
  if (uncertain != null) {
    final (_, lang, original, _) = uncertain;
    state
      ..apply(UtteranceEnd(id, 'ok'))
      ..apply(AsrFinal(id + 1, null, lang, original, .41, uncertain: true));
  }
  return ConversationController(
    transport: _Transport(),
    player: _Player(),
    state: state,
    mode: Mode.auto,
    onChanged: () {},
  );
}

// Czech at the bottom, the colleague's language on the rotated top half.
const _rental = <_Line>[
  (Side.b, 'uk', 'Мені потрібно продовжити договір оренди квартири.', 'Potřebuji prodloužit nájemní smlouvu na byt.'),
  (Side.a, 'cs', 'Jasně. Máte s sebou pas a původní smlouvu?', 'Звісно. У вас є з собою паспорт і попередній договір?'),
  (Side.b, 'uk', 'Так, ось вони. Скільки часу це займе?', 'Ano, tady jsou. Jak dlouho to potrvá?'),
];

const _garage = <_Line>[
  (Side.b, 'de', 'Das Auto macht beim Bremsen ein lautes Geräusch.', 'Auto při brzdění hlasitě vrže.'),
  (Side.a, 'cs', 'Podíváme se na to. Zítra v deset by to šlo?', 'Wir schauen uns das an. Ginge es morgen um zehn?'),
];

const _hotel = <_Line>[
  (Side.a, 'cs', 'Dobrý večer, máme rezervaci na jméno Novák.', 'Good evening, we have a reservation under the name Novák.'),
  (Side.b, 'en', 'Welcome! Two nights with breakfast, is that right?', 'Vítejte! Dvě noci se snídaní, je to tak?'),
  (Side.a, 'cs', 'Ano. Šel by i pozdní odjezd?', 'Yes. Would a late check-out be possible too?'),
  (Side.b, 'en', 'Of course, until one o\'clock at no extra charge.', 'Samozřejmě, do jedné hodiny bez příplatku.'),
  (Side.a, 'cs', 'Výborně, děkujeme.', 'Great, thank you.'),
];

void main() {
  setUpAll(_loadFonts);
  setUp(
    () => SharedPreferences.setMockInitialValues({
      'langA': 'cs',
      'langB': 'uk',
      'recent': ['uk', 'cs', 'de', 'en'],
      'deviceId': 'screenshots',
    }),
  );

  Future<void> shoot(
    WidgetTester tester,
    String name,
    Widget home, {
    Future<void> Function()? then,
  }) async {
    tester.view.physicalSize = _phone * _ratio;
    tester.view.devicePixelRatio = _ratio;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      RepaintBoundary(
        key: _shotKey,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('cs'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: _theme(),
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (then != null) await then();

    final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_shotKey));
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: _ratio);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File('$_dir/$name.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!.buffer.asUint8List());
    });
  }

  final skip = _dir == null;

  testWidgets('01 conversation across the table', skip: skip, (tester) async {
    await shoot(
      tester,
      '01-rozhovor',
      ConversationView(controller: _conversation('cs', 'uk', _rental), onEnd: () {}),
    );
  });

  testWidgets('02 setup: two languages and the mode', skip: skip, (tester) async {
    final settings = await Settings.load();
    await shoot(tester, '02-start', SetupScreen(settings: settings));
  });

  testWidgets('03 language picker', skip: skip, (tester) async {
    final settings = await Settings.load();
    await shoot(
      tester,
      '03-jazyky',
      SetupScreen(settings: settings),
      then: () async {
        await tester.tap(find.text('Українська'));
        await tester.pumpAndSettle();
      },
    );
  });

  testWidgets('04 unsure who spoke: "that was me"', skip: skip, (tester) async {
    await shoot(
      tester,
      '04-to-jsem-ja',
      ConversationView(
        controller: _conversation(
          'cs',
          'de',
          _garage,
          uncertain: (Side.a, 'cs', 'A kolik to bude stát?', ''),
        ),
        onEnd: () {},
      ),
    );
  });

  testWidgets('05 a past conversation to read and share', skip: skip, (tester) async {
    final c = _conversation('cs', 'en', _hotel);
    await shoot(tester, '05-zaznam', TranscriptScreen(transcript: c.state.transcript));
  });

  testWidgets('06 recording your own voice', skip: skip, (tester) async {
    final settings = await Settings.load();
    await shoot(
      tester,
      '06-hlas',
      RecordVoiceScreen(library: VoiceLibrary(settings)),
      then: () async {
        await tester.enterText(find.byType(TextField), 'Můj hlas');
        await tester.tap(find.byType(Checkbox));
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
      },
    );
  });
}
