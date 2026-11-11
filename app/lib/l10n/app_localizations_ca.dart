// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Intèrpret';

  @override
  String get me => 'Jo';

  @override
  String get colleague => 'Company';

  @override
  String get start => 'Inicia';

  @override
  String get modeLabel => 'Mode';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Mantén i parla';

  @override
  String get modeStreaming => 'Continu';

  @override
  String get chooseLanguage => 'Tria l\'idioma';

  @override
  String get history => 'Historial';

  @override
  String get settings => 'Configuració';

  @override
  String get serverUrl => 'Adreça del servidor';

  @override
  String get save => 'Desa';

  @override
  String get statusConnecting => 'Connectant…';

  @override
  String get statusListening => 'Escoltant';

  @override
  String get statusRecording => 'T\'estic sentint';

  @override
  String get statusTranslating => 'Traduint';

  @override
  String get statusSpeaking => 'Parlant';

  @override
  String get statusPaused => 'En pausa';

  @override
  String get itWasMe => 'Era jo';

  @override
  String get promptAuto => 'Parleu un a un';

  @override
  String get promptPtt => 'Mantén premut i parla';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Continua';

  @override
  String get soundOn => 'So activat';

  @override
  String get soundOff => 'Només text';

  @override
  String get endConversation => 'Acaba';

  @override
  String get volumeHint => 'Posa el volum al màxim';

  @override
  String get share => 'Comparteix';

  @override
  String get delete => 'Suprimeix';

  @override
  String get noHistory => 'Encara no hi ha cap conversa';

  @override
  String get micDenied =>
      'Sense accés al micròfon no funcionarà. Permet-lo a la configuració.';

  @override
  String get errorConnection => 'S\'ha perdut la connexió amb el servidor';

  @override
  String get errorBackend => 'El servei de traducció no està disponible ara';

  @override
  String get errorVoice => 'La veu no està disponible, es queda el text';

  @override
  String get errorBusy =>
      'El servidor està ple, torna-ho a provar d\'aquí a una estona';

  @override
  String get errorTooLong => 'L\'intervenció és massa llarga';

  @override
  String get errorGeneric => 'Alguna cosa ha anat malament';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get voiceLibrary => 'Les meves veus';

  @override
  String get voiceAdd => 'Grava una veu';

  @override
  String get voiceEmpty => 'Encara no hi ha cap veu.';

  @override
  String get voiceServerError => 'Les veus no estan disponibles ara';

  @override
  String get voiceDefault => 'Veu per defecte';

  @override
  String get voiceName => 'Posa nom a la veu';

  @override
  String get voiceConsent =>
      'Accepto que l\'enregistrament de la meva veu es desi al servidor i s\'utilitzi per pronunciar les traduccions amb la meva veu. És una dada biomètrica, només puc enregistrar-me a mi mateix i revoco el consentiment suprimint la veu.';

  @override
  String get voiceReadThis =>
      'Prem el botó i llegeix amb naturalitat durant 30 segons:';

  @override
  String get voiceSampleText =>
      'Bon dia, això és una mostra de la meva veu. Parlo amb calma i naturalitat, com si estigués xerrant amb algú a taula. Ahir vaig anar a passejar, pel camí em vaig trobar un vell amic i vam prendre un cafè junts. Em va explicar el seu viatge al mar, el temps, el bon menjar i què l\'espera a la feina. Quan acabi de llegir, continuaré amb les meves paraules fins que s\'acabi l\'enregistrament.';

  @override
  String get voiceRecord => 'Grava 30 segons';

  @override
  String voiceRecording(int seconds) {
    return 'Gravant, queden $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Vols suprimir la veu $name?';
  }

  @override
  String get voiceDeleteBody =>
      'L\'enregistrament se suprimirà del servidor de manera permanent.';

  @override
  String get serverChecking => 'verificant…';

  @override
  String get serverReady => 'a punt';

  @override
  String get serverDegraded => 'no funciona tot';

  @override
  String get serverOffline => 'no disponible';

  @override
  String get serverRecheck => 'Torna a verificar';

  @override
  String get deviceTier => 'Aquest dispositiu';

  @override
  String get deviceTierPublic => 'Bàsic: temps de traducció limitat al dia';

  @override
  String get deviceTierTester => 'Provador: traducció més llarga i veu pròpia';

  @override
  String get deviceTierUnknown => 'El servidor no respon ara';

  @override
  String get inviteCode => 'Codi d\'invitació';

  @override
  String get inviteHelp =>
      'De l\'autor de l\'aplicació, desbloqueja les proves';

  @override
  String get inviteWrong => 'Aquest codi no és vàlid';

  @override
  String get inviteUnavailable =>
      'Ara no es pot verificar el codi, prova-ho més tard';

  @override
  String get errorQuota =>
      'Els minuts de traducció d\'avui s\'han acabat, demà tornen';

  @override
  String get voiceNeedsInvite =>
      'La veu pròpia és només per a provadors amb codi d\'invitació';
}
