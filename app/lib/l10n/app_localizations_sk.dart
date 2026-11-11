// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Tlmočník';

  @override
  String get me => 'Ja';

  @override
  String get colleague => 'Kolega';

  @override
  String get start => 'Štart';

  @override
  String get modeLabel => 'Režim';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Podržte a hovorte';

  @override
  String get modeStreaming => 'Priebežne';

  @override
  String get chooseLanguage => 'Vyberte jazyk';

  @override
  String get history => 'História';

  @override
  String get settings => 'Nastavenia';

  @override
  String get serverUrl => 'Adresa servera';

  @override
  String get save => 'Uložiť';

  @override
  String get statusConnecting => 'Pripájam…';

  @override
  String get statusListening => 'Počúvam';

  @override
  String get statusRecording => 'Počujem vás';

  @override
  String get statusTranslating => 'Prekladám';

  @override
  String get statusSpeaking => 'Hovorím';

  @override
  String get statusPaused => 'Pozastavené';

  @override
  String get itWasMe => 'To som ja';

  @override
  String get promptAuto => 'Hovorte po jednom';

  @override
  String get promptPtt => 'Držte a hovorte';

  @override
  String get pause => 'Pauza';

  @override
  String get resume => 'Pokračovať';

  @override
  String get soundOn => 'Zvuk zapnutý';

  @override
  String get soundOff => 'Iba text';

  @override
  String get endConversation => 'Ukončiť';

  @override
  String get volumeHint => 'Dajte hlasitosť na maximum';

  @override
  String get share => 'Zdieľať';

  @override
  String get delete => 'Vymazať';

  @override
  String get noHistory => 'Zatiaľ žiadne rozhovory';

  @override
  String get micDenied =>
      'Bez prístupu k mikrofónu to nepôjde. Povoľte ho v nastaveniach.';

  @override
  String get errorConnection => 'Spojenie so serverom sa stratilo';

  @override
  String get errorBackend => 'Prekladová služba teraz nie je dostupná';

  @override
  String get errorVoice => 'Hlas nie je dostupný, zostáva text';

  @override
  String get errorBusy => 'Server je plný, skúste to o chvíľu';

  @override
  String get errorTooLong => 'Prehovor je príliš dlhý';

  @override
  String get errorGeneric => 'Niečo sa pokazilo';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get voiceLibrary => 'Moje hlasy';

  @override
  String get voiceAdd => 'Nahrať hlas';

  @override
  String get voiceEmpty => 'Zatiaľ tu nie je žiadny hlas.';

  @override
  String get voiceServerError => 'Hlasy teraz nie sú dostupné';

  @override
  String get voiceDefault => 'Predvolený hlas';

  @override
  String get voiceName => 'Pomenujte hlas';

  @override
  String get voiceConsent =>
      'Súhlasím s uložením nahrávky môjho hlasu na serveri a s jej použitím na preklad mojím hlasom. Je to biometrický údaj, nahrávať smiem iba seba a súhlas zruším vymazaním hlasu.';

  @override
  String get voiceReadThis =>
      'Stlačte tlačidlo a 30 sekúnd prirodzene čítajte:';

  @override
  String get voiceSampleText =>
      'Dobrý deň, toto je ukážka môjho hlasu. Hovorím pokojne a prirodzene, ako keby som sa s niekým rozprával pri stole. Včera som išiel na prechádzku, cestou som stretol starého kamaráta a dali sme si spolu kávu. Rozprával mi o svojej ceste k moru, o počasí, o dobrom jedle aj o tom, čo ho čaká v práci. Keď dočítam, pokojne budem pokračovať vlastnými slovami, kým sa nahrávanie neskončí.';

  @override
  String get voiceRecord => 'Nahrať 30 sekúnd';

  @override
  String voiceRecording(int seconds) {
    return 'Nahrávam, zostáva $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Vymazať hlas $name?';
  }

  @override
  String get voiceDeleteBody => 'Nahrávka sa natrvalo vymaže zo servera.';

  @override
  String get serverChecking => 'overujem…';

  @override
  String get serverReady => 'pripravené';

  @override
  String get serverDegraded => 'nebeží všetko';

  @override
  String get serverOffline => 'nedostupné';

  @override
  String get serverRecheck => 'Overiť znova';

  @override
  String get deviceTier => 'Toto zariadenie';

  @override
  String get deviceTierPublic => 'Základné: obmedzený čas prekladu denne';

  @override
  String get deviceTierTester => 'Tester: dlhší preklad a vlastný hlas';

  @override
  String get deviceTierUnknown => 'Server teraz neodpovedá';

  @override
  String get inviteCode => 'Pozývací kód';

  @override
  String get inviteHelp => 'Od autora aplikácie, odomkne testovanie';

  @override
  String get inviteWrong => 'Tento kód neplatí';

  @override
  String get inviteUnavailable => 'Kód teraz nejde overiť, skúste to neskôr';

  @override
  String get errorQuota => 'Dnešné minúty prekladu sa minuli, zajtra zase';

  @override
  String get voiceNeedsInvite =>
      'Vlastný hlas je zatiaľ len pre testerov s pozývacím kódom';
}
