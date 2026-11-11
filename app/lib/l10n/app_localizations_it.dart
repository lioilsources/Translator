// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Interprete';

  @override
  String get me => 'Io';

  @override
  String get colleague => 'Collega';

  @override
  String get start => 'Avvia';

  @override
  String get modeLabel => 'Modalità';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Tieni premuto e parla';

  @override
  String get modeStreaming => 'Continuo';

  @override
  String get chooseLanguage => 'Scegli la lingua';

  @override
  String get history => 'Cronologia';

  @override
  String get settings => 'Impostazioni';

  @override
  String get serverUrl => 'Indirizzo del server';

  @override
  String get save => 'Salva';

  @override
  String get statusConnecting => 'Connessione…';

  @override
  String get statusListening => 'Ascolto';

  @override
  String get statusRecording => 'Ti sento';

  @override
  String get statusTranslating => 'Traduco';

  @override
  String get statusSpeaking => 'Parlo';

  @override
  String get statusPaused => 'In pausa';

  @override
  String get itWasMe => 'Ero io';

  @override
  String get promptAuto => 'Parlate uno alla volta';

  @override
  String get promptPtt => 'Tieni premuto e parla';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Riprendi';

  @override
  String get soundOn => 'Audio attivo';

  @override
  String get soundOff => 'Solo testo';

  @override
  String get endConversation => 'Termina';

  @override
  String get volumeHint => 'Metti il volume al massimo';

  @override
  String get share => 'Condividi';

  @override
  String get delete => 'Elimina';

  @override
  String get noHistory => 'Ancora nessuna conversazione';

  @override
  String get micDenied =>
      'Senza accesso al microfono non funziona. Consentilo nelle impostazioni.';

  @override
  String get errorConnection => 'La connessione al server si è interrotta';

  @override
  String get errorBackend =>
      'Il servizio di traduzione non è disponibile al momento';

  @override
  String get errorVoice => 'La voce non è disponibile, resta il testo';

  @override
  String get errorBusy => 'Il server è pieno, riprova tra un momento';

  @override
  String get errorTooLong => 'L\'intervento è troppo lungo';

  @override
  String get errorGeneric => 'Qualcosa è andato storto';

  @override
  String get cancel => 'Annulla';

  @override
  String get voiceLibrary => 'Le mie voci';

  @override
  String get voiceAdd => 'Registra una voce';

  @override
  String get voiceEmpty => 'Qui non c\'è ancora nessuna voce.';

  @override
  String get voiceServerError => 'Le voci non sono disponibili al momento';

  @override
  String get voiceDefault => 'Voce predefinita';

  @override
  String get voiceName => 'Dai un nome alla voce';

  @override
  String get voiceConsent =>
      'Acconsento a che la registrazione della mia voce sia conservata sul server e usata per pronunciare le traduzioni con la mia voce. È un dato biometrico, posso registrare solo me stesso e revoco il consenso eliminando la voce.';

  @override
  String get voiceReadThis =>
      'Premi il pulsante e leggi in modo naturale per 30 secondi:';

  @override
  String get voiceSampleText =>
      'Buongiorno, questo è un campione della mia voce. Parlo con calma e naturalezza, come se chiacchierassi con qualcuno a tavola. Ieri sono andato a fare una passeggiata, per strada ho incontrato un vecchio amico e abbiamo preso un caffè insieme. Mi ha raccontato del suo viaggio al mare, del tempo, del buon cibo e di cosa lo aspetta al lavoro. Quando avrò finito di leggere, continuerò con parole mie finché la registrazione non termina.';

  @override
  String get voiceRecord => 'Registra 30 secondi';

  @override
  String voiceRecording(int seconds) {
    return 'Registrazione, mancano $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Eliminare la voce $name?';
  }

  @override
  String get voiceDeleteBody =>
      'La registrazione verrà eliminata definitivamente dal server.';

  @override
  String get serverChecking => 'verifica…';

  @override
  String get serverReady => 'pronto';

  @override
  String get serverDegraded => 'non tutto funziona';

  @override
  String get serverOffline => 'non disponibile';

  @override
  String get serverRecheck => 'Verifica di nuovo';

  @override
  String get deviceTier => 'Questo dispositivo';

  @override
  String get deviceTierPublic => 'Base: tempo di traduzione limitato al giorno';

  @override
  String get deviceTierTester => 'Tester: traduzione più lunga e voce propria';

  @override
  String get deviceTierUnknown => 'Il server non risponde al momento';

  @override
  String get inviteCode => 'Codice d\'invito';

  @override
  String get inviteHelp => 'Dall\'autore dell\'app, sblocca i test';

  @override
  String get inviteWrong => 'Questo codice non è valido';

  @override
  String get inviteUnavailable =>
      'Il codice non si può verificare ora, riprova più tardi';

  @override
  String get errorQuota =>
      'I minuti di traduzione di oggi sono finiti, domani si riparte';

  @override
  String get voiceNeedsInvite =>
      'La voce propria per ora è solo per i tester con codice d\'invito';
}
