// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Tolk';

  @override
  String get me => 'Ik';

  @override
  String get colleague => 'Collega';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Modus';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Ingedrukt houden en spreken';

  @override
  String get modeStreaming => 'Doorlopend';

  @override
  String get chooseLanguage => 'Kies een taal';

  @override
  String get history => 'Geschiedenis';

  @override
  String get settings => 'Instellingen';

  @override
  String get serverUrl => 'Serveradres';

  @override
  String get save => 'Bewaren';

  @override
  String get statusConnecting => 'Verbinden…';

  @override
  String get statusListening => 'Luisteren';

  @override
  String get statusRecording => 'Ik hoor u';

  @override
  String get statusTranslating => 'Vertalen';

  @override
  String get statusSpeaking => 'Spreken';

  @override
  String get statusPaused => 'Gepauzeerd';

  @override
  String get itWasMe => 'Dat was ik';

  @override
  String get promptAuto => 'Spreek om de beurt';

  @override
  String get promptPtt => 'Houd ingedrukt en spreek';

  @override
  String get pause => 'Pauze';

  @override
  String get resume => 'Doorgaan';

  @override
  String get soundOn => 'Geluid aan';

  @override
  String get soundOff => 'Alleen tekst';

  @override
  String get endConversation => 'Beëindigen';

  @override
  String get volumeHint => 'Zet het volume op maximaal';

  @override
  String get share => 'Delen';

  @override
  String get delete => 'Verwijderen';

  @override
  String get noHistory => 'Nog geen gesprekken';

  @override
  String get micDenied =>
      'Zonder toegang tot de microfoon werkt het niet. Sta die toe in de instellingen.';

  @override
  String get errorConnection => 'De verbinding met de server is verbroken';

  @override
  String get errorBackend => 'De vertaaldienst is nu niet beschikbaar';

  @override
  String get errorVoice => 'De stem is niet beschikbaar, de tekst blijft';

  @override
  String get errorBusy => 'De server zit vol, probeer het zo opnieuw';

  @override
  String get errorTooLong => 'De uiting is te lang';

  @override
  String get errorGeneric => 'Er ging iets mis';

  @override
  String get cancel => 'Annuleren';

  @override
  String get voiceLibrary => 'Mijn stemmen';

  @override
  String get voiceAdd => 'Stem opnemen';

  @override
  String get voiceEmpty => 'Er is hier nog geen stem.';

  @override
  String get voiceServerError => 'Stemmen zijn nu niet beschikbaar';

  @override
  String get voiceDefault => 'Standaardstem';

  @override
  String get voiceName => 'Geef de stem een naam';

  @override
  String get voiceConsent =>
      'Ik ga ermee akkoord dat de opname van mijn stem op de server wordt bewaard en gebruikt om vertalingen met mijn stem uit te spreken. Het zijn biometrische gegevens, ik mag alleen mezelf opnemen en ik trek mijn toestemming in door de stem te verwijderen.';

  @override
  String get voiceReadThis =>
      'Druk op de knop en lees 30 seconden lang natuurlijk voor:';

  @override
  String get voiceSampleText =>
      'Goedendag, dit is een voorbeeld van mijn stem. Ik praat rustig en natuurlijk, alsof ik met iemand aan tafel zit te kletsen. Gisteren ging ik wandelen, onderweg kwam ik een oude vriend tegen en we dronken samen koffie. Hij vertelde over zijn reis naar zee, over het weer, over lekker eten en over wat hem op het werk te wachten staat. Als ik klaar ben met lezen, ga ik gewoon in mijn eigen woorden verder tot de opname stopt.';

  @override
  String get voiceRecord => '30 seconden opnemen';

  @override
  String voiceRecording(int seconds) {
    return 'Opnemen, nog $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Stem $name verwijderen?';
  }

  @override
  String get voiceDeleteBody =>
      'De opname wordt definitief van de server verwijderd.';

  @override
  String get serverChecking => 'controleren…';

  @override
  String get serverReady => 'klaar';

  @override
  String get serverDegraded => 'niet alles werkt';

  @override
  String get serverOffline => 'niet beschikbaar';

  @override
  String get serverRecheck => 'Opnieuw controleren';

  @override
  String get deviceTier => 'Dit apparaat';

  @override
  String get deviceTierPublic => 'Basis: beperkte vertaaltijd per dag';

  @override
  String get deviceTierTester => 'Tester: langer vertalen en eigen stem';

  @override
  String get deviceTierUnknown => 'De server antwoordt nu niet';

  @override
  String get inviteCode => 'Uitnodigingscode';

  @override
  String get inviteHelp => 'Van de maker van de app, ontgrendelt het testen';

  @override
  String get inviteWrong => 'Deze code is ongeldig';

  @override
  String get inviteUnavailable =>
      'De code kan nu niet worden gecontroleerd, probeer het later';

  @override
  String get errorQuota => 'De vertaalminuten van vandaag zijn op, morgen weer';

  @override
  String get voiceNeedsInvite =>
      'Een eigen stem is voorlopig alleen voor testers met een uitnodigingscode';
}
