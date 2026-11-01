// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Tlumočník';

  @override
  String get me => 'Já';

  @override
  String get colleague => 'Kolega';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Režim';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Podržet a mluvit';

  @override
  String get modeStreaming => 'Průběžně';

  @override
  String get chooseLanguage => 'Vyberte jazyk';

  @override
  String get history => 'Historie';

  @override
  String get settings => 'Nastavení';

  @override
  String get serverUrl => 'Adresa serveru';

  @override
  String get serverToken => 'Přístupový token';

  @override
  String get save => 'Uložit';

  @override
  String get statusConnecting => 'Připojuji…';

  @override
  String get statusListening => 'Poslouchám';

  @override
  String get statusRecording => 'Slyším vás';

  @override
  String get statusTranslating => 'Překládám';

  @override
  String get statusSpeaking => 'Mluvím';

  @override
  String get statusPaused => 'Pozastaveno';

  @override
  String get itWasMe => 'To jsem já';

  @override
  String get promptAuto => 'Mluvte po jednom';

  @override
  String get promptPtt => 'Držte a mluvte';

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Pokračovat';

  @override
  String get soundOn => 'Zvuk zapnutý';

  @override
  String get soundOff => 'Jen text';

  @override
  String get endConversation => 'Ukončit';

  @override
  String get volumeHint => 'Dejte hlasitost na maximum';

  @override
  String get share => 'Sdílet';

  @override
  String get delete => 'Smazat';

  @override
  String get noHistory => 'Zatím žádné rozhovory';

  @override
  String get micDenied =>
      'Bez přístupu k mikrofonu to nepůjde. Povolte ho v nastavení.';

  @override
  String get errorConnection => 'Spojení se serverem se ztratilo';

  @override
  String get errorBackend => 'Překladová služba teď není dostupná';

  @override
  String get errorVoice => 'Hlas není dostupný, zůstává text';

  @override
  String get errorBusy => 'Server je plný, zkuste to za chvíli';

  @override
  String get errorTooLong => 'Promluva je moc dlouhá';

  @override
  String get errorGeneric => 'Něco se pokazilo';

  @override
  String get cancel => 'Zrušit';

  @override
  String get voiceLibrary => 'Moje hlasy';

  @override
  String get voiceAdd => 'Nahrát hlas';

  @override
  String get voiceEmpty => 'Zatím tu není žádný hlas.';

  @override
  String get voiceServerError => 'Hlasy teď nejsou dostupné';

  @override
  String get voiceDefault => 'Výchozí hlas';

  @override
  String get voiceName => 'Pojmenujte hlas';

  @override
  String get voiceConsent =>
      'Souhlasím s uložením nahrávky mého hlasu na serveru a s jejím použitím k překladu mým hlasem. Je to biometrický údaj, nahrávat smím jen sebe a souhlas zruším smazáním hlasu.';

  @override
  String get voiceReadThis => 'Stiskněte tlačítko a 30 sekund přirozeně čtěte:';

  @override
  String get voiceSampleText =>
      'Dobrý den, tohle je ukázka mého hlasu. Mluvím klidně a přirozeně, tak jako bych si s někým povídal u stolu. Včera jsem šel na procházku, cestou jsem potkal starého kamaráda a dali jsme si spolu kávu. Vyprávěl mi o své cestě k moři, o počasí, o dobrém jídle i o tom, co ho čeká v práci. Až to dočtu, klidně budu pokračovat vlastními slovy, dokud neskončí nahrávání.';

  @override
  String get voiceRecord => 'Nahrát 30 sekund';

  @override
  String voiceRecording(int seconds) {
    return 'Nahrávám, zbývá $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Smazat hlas $name?';
  }

  @override
  String get voiceDeleteBody => 'Nahrávka se trvale smaže ze serveru.';

  @override
  String get serverChecking => 'ověřuji…';

  @override
  String get serverReady => 'připraveno';

  @override
  String get serverDegraded => 'neběží vše';

  @override
  String get serverOffline => 'nedostupné';

  @override
  String get serverRecheck => 'Znovu ověřit';
}
