import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/ui/screens.dart';
import 'package:translator_app/ui/voices.dart';

/// The 45 interface languages: every one must load, differ from the Czech
/// template, and lay out the screens without overflow, also right to left
/// (ar, he, ur).
const _expected = [
  'ar',
  'bn',
  'ca',
  'cs',
  'da',
  'de',
  'el',
  'en',
  'es',
  'fi',
  'fr',
  'gu',
  'he',
  'hi',
  'hr',
  'hu',
  'id',
  'it',
  'ja',
  'kn',
  'ko',
  'ml',
  'mr',
  'ms',
  'nb',
  'nl',
  'or',
  'pa',
  'pl',
  'pt',
  'ro',
  'ru',
  'sk',
  'sl',
  'sv',
  'ta',
  'te',
  'th',
  'tr',
  'uk',
  'ur',
  'vi',
  'zh',
];

Widget _app(Locale l, Widget child) => MaterialApp(
  locale: l,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  test('all 45 languages are supported (pt-BR/pt-PT, zh-Hans/zh-Hant)', () {
    final codes = AppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .toSet();
    expect(codes, containsAll(_expected));
    final tags = AppLocalizations.supportedLocales.map((l) => l.toString());
    expect(tags, containsAll(['pt_PT', 'pt_BR', 'zh_Hant', 'zh_Hans']));
  });

  test('no translation is empty or still the Czech template', () async {
    final cs = await AppLocalizations.delegate.load(const Locale('cs'));
    for (final l in AppLocalizations.supportedLocales) {
      if (l.languageCode == 'cs') continue;
      final t = await AppLocalizations.delegate.load(l);
      expect(t.start, isNotEmpty, reason: '$l');
      expect(t.voiceSampleText, isNot(cs.voiceSampleText), reason: '$l');
      expect(t.voiceConsent, isNot(cs.voiceConsent), reason: '$l');
      expect(t.voiceRecording(7), contains('7'), reason: '$l');
      expect(t.voiceDeleteTitle('Eva'), contains('Eva'), reason: '$l');
    }
  });

  for (final l in AppLocalizations.supportedLocales) {
    testWidgets('settings and voice screens lay out in $l', (t) async {
      SharedPreferences.setMockInitialValues({});
      final settings = await Settings.load();
      t.view.physicalSize = const Size(800, 1600);
      t.view.devicePixelRatio = 2;
      addTearDown(t.view.reset);
      final rtl = ['ar', 'he', 'ur'].contains(l.languageCode);

      await t.pumpWidget(_app(l, SettingsScreen(settings: settings)));
      await t.pump();
      expect(
        Directionality.of(t.element(find.byType(Scaffold).first)),
        rtl ? TextDirection.rtl : TextDirection.ltr,
      );
      expect(t.takeException(), isNull, reason: '$l settings');

      await t.pumpWidget(
        _app(l, RecordVoiceScreen(library: VoiceLibrary(settings))),
      );
      await t.pump();
      expect(t.takeException(), isNull, reason: '$l record voice');
    });
  }
}
