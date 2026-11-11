// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'Tumač';

  @override
  String get me => 'Ja';

  @override
  String get colleague => 'Kolega';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Način';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Drži i govori';

  @override
  String get modeStreaming => 'Kontinuirano';

  @override
  String get chooseLanguage => 'Odaberite jezik';

  @override
  String get history => 'Povijest';

  @override
  String get settings => 'Postavke';

  @override
  String get serverUrl => 'Adresa poslužitelja';

  @override
  String get save => 'Spremi';

  @override
  String get statusConnecting => 'Povezivanje…';

  @override
  String get statusListening => 'Slušam';

  @override
  String get statusRecording => 'Čujem vas';

  @override
  String get statusTranslating => 'Prevodim';

  @override
  String get statusSpeaking => 'Govorim';

  @override
  String get statusPaused => 'Pauzirano';

  @override
  String get itWasMe => 'To sam bio ja';

  @override
  String get promptAuto => 'Govorite jedan po jedan';

  @override
  String get promptPtt => 'Držite i govorite';

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Nastavi';

  @override
  String get soundOn => 'Zvuk uključen';

  @override
  String get soundOff => 'Samo tekst';

  @override
  String get endConversation => 'Završi';

  @override
  String get volumeHint => 'Postavite glasnoću na maksimum';

  @override
  String get share => 'Podijeli';

  @override
  String get delete => 'Izbriši';

  @override
  String get noHistory => 'Još nema razgovora';

  @override
  String get micDenied =>
      'Bez pristupa mikrofonu neće ići. Dopustite ga u postavkama.';

  @override
  String get errorConnection => 'Veza s poslužiteljem je izgubljena';

  @override
  String get errorBackend => 'Usluga prevođenja trenutno nije dostupna';

  @override
  String get errorVoice => 'Glas nije dostupan, ostaje tekst';

  @override
  String get errorBusy => 'Poslužitelj je pun, pokušajte za trenutak';

  @override
  String get errorTooLong => 'Izlaganje je predugo';

  @override
  String get errorGeneric => 'Nešto je pošlo po zlu';

  @override
  String get cancel => 'Odustani';

  @override
  String get voiceLibrary => 'Moji glasovi';

  @override
  String get voiceAdd => 'Snimi glas';

  @override
  String get voiceEmpty => 'Ovdje još nema nijednog glasa.';

  @override
  String get voiceServerError => 'Glasovi trenutno nisu dostupni';

  @override
  String get voiceDefault => 'Zadani glas';

  @override
  String get voiceName => 'Imenujte glas';

  @override
  String get voiceConsent =>
      'Pristajem da se snimka mog glasa pohrani na poslužitelju i koristi za izgovaranje prijevoda mojim glasom. To je biometrijski podatak, smijem snimati samo sebe, a privolu povlačim brisanjem glasa.';

  @override
  String get voiceReadThis => 'Pritisnite gumb i čitajte prirodno 30 sekundi:';

  @override
  String get voiceSampleText =>
      'Dobar dan, ovo je uzorak mog glasa. Govorim mirno i prirodno, kao da razgovaram s nekim za stolom. Jučer sam išao u šetnju, usput sam sreo starog prijatelja i zajedno smo popili kavu. Pričao mi je o svom putu na more, o vremenu, o dobroj hrani i o tome što ga čeka na poslu. Kad dovršim čitanje, slobodno ću nastaviti vlastitim riječima dok snimanje ne završi.';

  @override
  String get voiceRecord => 'Snimi 30 sekundi';

  @override
  String voiceRecording(int seconds) {
    return 'Snimanje, preostalo još $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Izbrisati glas $name?';
  }

  @override
  String get voiceDeleteBody => 'Snimka će se trajno izbrisati s poslužitelja.';

  @override
  String get serverChecking => 'provjeravam…';

  @override
  String get serverReady => 'spremno';

  @override
  String get serverDegraded => 'ne radi sve';

  @override
  String get serverOffline => 'nedostupno';

  @override
  String get serverRecheck => 'Provjeri ponovno';

  @override
  String get deviceTier => 'Ovaj uređaj';

  @override
  String get deviceTierPublic =>
      'Osnovno: ograničeno vrijeme prevođenja dnevno';

  @override
  String get deviceTierTester => 'Tester: dulje prevođenje i vlastiti glas';

  @override
  String get deviceTierUnknown => 'Poslužitelj trenutno ne odgovara';

  @override
  String get inviteCode => 'Pozivni kod';

  @override
  String get inviteHelp => 'Od autora aplikacije, otključava testiranje';

  @override
  String get inviteWrong => 'Ovaj kod ne vrijedi';

  @override
  String get inviteUnavailable =>
      'Kod se trenutno ne može provjeriti, pokušajte kasnije';

  @override
  String get errorQuota =>
      'Današnje minute prevođenja su potrošene, sutra opet';

  @override
  String get voiceNeedsInvite =>
      'Vlastiti glas za sada je samo za testere s pozivnim kodom';
}
