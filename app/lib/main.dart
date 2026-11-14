import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/telemetry/telemetry_dictionary.dart';
import 'package:translator_app/ui/screens.dart';

/// The app's resolved UI language, for the statistics.
var _uiLang = 'en';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The phone lies flat between two people; rotation would flip the halves.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final settings = await Settings.load();
  final prefs = await SharedPreferences.getInstance();
  // Anonymous usage statistics (docs/telemetry.md). Silent without
  // TELEMETRY_KEY and TELEMETRY_HOST; it never touches the translation
  // server, its tokens or anything said in a conversation.
  unawaited(
    Telemetry.init(
      app: kTelemetryApp,
      appVersion: kAppVersion,
      dictionary: appDictionary,
      store: PrefsTelemetryStore(prefs),
      lang: () => _uiLang,
      // Chosen languages or a device id mean the app was used before.
      hadDataBefore: () =>
          prefs.getKeys().any((k) => !k.startsWith('telemetry_')),
      common: () => {'server': telemetryServer(settings.url)},
    ),
  );
  runApp(TranslatorApp(settings: settings));
}

class TranslatorApp extends StatelessWidget {
  const TranslatorApp({required this.settings, super.key});
  final Settings settings;

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    navigatorObservers: [TelemetryNavigatorObserver(kScreenRoutes)],
    builder: (context, child) {
      _uiLang = telemetryLocaleId(Localizations.localeOf(context));
      return child!;
    },
    theme: ThemeData(
      colorSchemeSeed: const Color(0xFF2E7D6B),
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      colorSchemeSeed: const Color(0xFF2E7D6B),
      brightness: Brightness.dark,
    ),
    home: SetupScreen(settings: settings),
  );
}
