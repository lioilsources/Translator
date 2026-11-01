import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/ui/voices.dart';

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('cs'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  testWidgets('recording stays off until a name and consent are given', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final settings = await Settings.load();
    await tester.pumpWidget(
      _app(RecordVoiceScreen(library: VoiceLibrary(settings))),
    );
    FilledButton button() =>
        tester.widget<FilledButton>(find.byWidgetPredicate((w) => w is FilledButton));

    expect(button().onPressed, isNull);
    await tester.enterText(find.byType(TextField), 'Já');
    await tester.pump();
    expect(button().onPressed, isNull);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(button().onPressed, isNotNull);
  });

  test('deleting a voice clears it from both sides', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = await Settings.load()
      ..voiceA = 'clone:abc'
      ..voiceB = 'clone:def';
    settings.forgetVoice('abc');
    expect(settings.voiceA, isNull);
    expect(settings.voiceB, 'clone:def');
  });

  test('switching server resets chosen voices, staying keeps them', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = await Settings.load()
      ..url = servers['L40S']!
      ..voiceA = 'clone:abc';
    settings.useServer(servers['L40S']!);
    expect(settings.voiceA, 'clone:abc');
    settings.useServer(servers['SPARK']!);
    expect(settings.url, servers['SPARK']);
    expect(settings.voiceA, isNull);
  });

  test('only a fully ready server counts as ready', () {
    expect(parseHealth(200, '{"status":"ready"}'), ServerHealth.ready);
    expect(parseHealth(200, '{"status":"degraded"}'), ServerHealth.degraded);
    expect(parseHealth(502, 'bad gateway'), ServerHealth.offline);
    expect(parseHealth(200, '<html>'), ServerHealth.offline);
  });

  testWidgets('a voice that no longer exists shows as the default', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        VoicePicker(
          voices: const [Voice(id: 'a', name: 'Olda')],
          selected: 'clone:gone',
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('Výchozí hlas'), findsOneWidget);
  });
}
