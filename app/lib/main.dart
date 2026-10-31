import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/ui/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The phone lies flat between two people; rotation would flip the halves.
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final settings = await Settings.load();
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
