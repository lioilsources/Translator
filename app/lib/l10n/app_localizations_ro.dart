// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'Interpret';

  @override
  String get me => 'Eu';

  @override
  String get colleague => 'Coleg';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Mod';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Ține apăsat și vorbește';

  @override
  String get modeStreaming => 'Continuu';

  @override
  String get chooseLanguage => 'Alege limba';

  @override
  String get history => 'Istoric';

  @override
  String get settings => 'Setări';

  @override
  String get serverUrl => 'Adresa serverului';

  @override
  String get save => 'Salvează';

  @override
  String get statusConnecting => 'Se conectează…';

  @override
  String get statusListening => 'Ascult';

  @override
  String get statusRecording => 'Vă aud';

  @override
  String get statusTranslating => 'Traduc';

  @override
  String get statusSpeaking => 'Vorbesc';

  @override
  String get statusPaused => 'În pauză';

  @override
  String get itWasMe => 'Eram eu';

  @override
  String get promptAuto => 'Vorbiți pe rând';

  @override
  String get promptPtt => 'Țineți apăsat și vorbiți';

  @override
  String get pause => 'Pauză';

  @override
  String get resume => 'Continuă';

  @override
  String get soundOn => 'Sunet pornit';

  @override
  String get soundOff => 'Doar text';

  @override
  String get endConversation => 'Încheie';

  @override
  String get volumeHint => 'Puneți volumul la maxim';

  @override
  String get share => 'Distribuie';

  @override
  String get delete => 'Șterge';

  @override
  String get noHistory => 'Încă nu există conversații';

  @override
  String get micDenied =>
      'Fără acces la microfon nu merge. Permiteți-l din setări.';

  @override
  String get errorConnection => 'Conexiunea cu serverul s-a pierdut';

  @override
  String get errorBackend => 'Serviciul de traducere nu este disponibil acum';

  @override
  String get errorVoice => 'Vocea nu este disponibilă, rămâne textul';

  @override
  String get errorBusy => 'Serverul este plin, încercați peste puțin timp';

  @override
  String get errorTooLong => 'Intervenția este prea lungă';

  @override
  String get errorGeneric => 'Ceva nu a mers bine';

  @override
  String get cancel => 'Anulează';

  @override
  String get voiceLibrary => 'Vocile mele';

  @override
  String get voiceAdd => 'Înregistrează o voce';

  @override
  String get voiceEmpty => 'Aici nu există încă nicio voce.';

  @override
  String get voiceServerError => 'Vocile nu sunt disponibile acum';

  @override
  String get voiceDefault => 'Voce implicită';

  @override
  String get voiceName => 'Dați un nume vocii';

  @override
  String get voiceConsent =>
      'Sunt de acord ca înregistrarea vocii mele să fie stocată pe server și folosită pentru a rosti traducerile cu vocea mea. Este o dată biometrică, am voie să mă înregistrez doar pe mine și îmi retrag acordul ștergând vocea.';

  @override
  String get voiceReadThis =>
      'Apăsați butonul și citiți natural timp de 30 de secunde:';

  @override
  String get voiceSampleText =>
      'Bună ziua, aceasta este o mostră a vocii mele. Vorbesc calm și natural, ca și cum aș sta de vorbă cu cineva la masă. Ieri am fost la plimbare, pe drum am întâlnit un vechi prieten și am băut împreună o cafea. Mi-a povestit despre excursia lui la mare, despre vreme, despre mâncarea bună și despre ce îl așteaptă la serviciu. Când termin de citit, voi continua liniștit cu cuvintele mele până se sfârșește înregistrarea.';

  @override
  String get voiceRecord => 'Înregistrează 30 de secunde';

  @override
  String voiceRecording(int seconds) {
    return 'Se înregistrează, mai sunt $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Ștergeți vocea $name?';
  }

  @override
  String get voiceDeleteBody =>
      'Înregistrarea va fi ștearsă definitiv de pe server.';

  @override
  String get serverChecking => 'se verifică…';

  @override
  String get serverReady => 'gata';

  @override
  String get serverDegraded => 'nu funcționează tot';

  @override
  String get serverOffline => 'indisponibil';

  @override
  String get serverRecheck => 'Verifică din nou';

  @override
  String get deviceTier => 'Acest dispozitiv';

  @override
  String get deviceTierPublic => 'De bază: timp de traducere limitat pe zi';

  @override
  String get deviceTierTester => 'Tester: traducere mai lungă și voce proprie';

  @override
  String get deviceTierUnknown => 'Serverul nu răspunde acum';

  @override
  String get inviteCode => 'Cod de invitație';

  @override
  String get inviteHelp => 'De la autorul aplicației, deblochează testarea';

  @override
  String get inviteWrong => 'Acest cod nu este valid';

  @override
  String get inviteUnavailable =>
      'Codul nu poate fi verificat acum, încercați mai târziu';

  @override
  String get errorQuota =>
      'Minutele de traducere de azi s-au terminat, mâine sunt din nou';

  @override
  String get voiceNeedsInvite =>
      'Vocea proprie este deocamdată doar pentru testeri cu cod de invitație';
}
