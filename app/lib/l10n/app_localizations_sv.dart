// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Tolk';

  @override
  String get me => 'Jag';

  @override
  String get colleague => 'Kollega';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Läge';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Håll in och tala';

  @override
  String get modeStreaming => 'Kontinuerligt';

  @override
  String get chooseLanguage => 'Välj språk';

  @override
  String get history => 'Historik';

  @override
  String get settings => 'Inställningar';

  @override
  String get serverUrl => 'Serveradress';

  @override
  String get save => 'Spara';

  @override
  String get statusConnecting => 'Ansluter…';

  @override
  String get statusListening => 'Lyssnar';

  @override
  String get statusRecording => 'Jag hör dig';

  @override
  String get statusTranslating => 'Översätter';

  @override
  String get statusSpeaking => 'Talar';

  @override
  String get statusPaused => 'Pausad';

  @override
  String get itWasMe => 'Det var jag';

  @override
  String get promptAuto => 'Tala en i taget';

  @override
  String get promptPtt => 'Håll in och tala';

  @override
  String get pause => 'Paus';

  @override
  String get resume => 'Fortsätt';

  @override
  String get soundOn => 'Ljud på';

  @override
  String get soundOff => 'Bara text';

  @override
  String get endConversation => 'Avsluta';

  @override
  String get volumeHint => 'Ställ in volymen på max';

  @override
  String get share => 'Dela';

  @override
  String get delete => 'Ta bort';

  @override
  String get noHistory => 'Inga samtal än';

  @override
  String get micDenied =>
      'Utan åtkomst till mikrofonen går det inte. Tillåt den i inställningarna.';

  @override
  String get errorConnection => 'Anslutningen till servern bröts';

  @override
  String get errorBackend =>
      'Översättningstjänsten är inte tillgänglig just nu';

  @override
  String get errorVoice => 'Rösten är inte tillgänglig, texten finns kvar';

  @override
  String get errorBusy => 'Servern är full, försök igen om en stund';

  @override
  String get errorTooLong => 'Yttrandet är för långt';

  @override
  String get errorGeneric => 'Något gick fel';

  @override
  String get cancel => 'Avbryt';

  @override
  String get voiceLibrary => 'Mina röster';

  @override
  String get voiceAdd => 'Spela in en röst';

  @override
  String get voiceEmpty => 'Det finns ingen röst här än.';

  @override
  String get voiceServerError => 'Röster är inte tillgängliga just nu';

  @override
  String get voiceDefault => 'Standardröst';

  @override
  String get voiceName => 'Ge rösten ett namn';

  @override
  String get voiceConsent =>
      'Jag samtycker till att inspelningen av min röst lagras på servern och används för att säga översättningar med min röst. Det är biometriska data, jag får bara spela in mig själv, och jag återkallar samtycket genom att ta bort rösten.';

  @override
  String get voiceReadThis =>
      'Tryck på knappen och läs naturligt i 30 sekunder:';

  @override
  String get voiceSampleText =>
      'God dag, det här är ett prov på min röst. Jag talar lugnt och naturligt, som om jag satt och pratade med någon vid ett bord. I går gick jag en promenad, på vägen mötte jag en gammal vän och vi drack kaffe tillsammans. Han berättade om sin resa till havet, om vädret, om god mat och om vad som väntar honom på jobbet. När jag har läst klart fortsätter jag helt enkelt med egna ord tills inspelningen slutar.';

  @override
  String get voiceRecord => 'Spela in 30 sekunder';

  @override
  String voiceRecording(int seconds) {
    return 'Spelar in, $seconds s kvar';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Ta bort rösten $name?';
  }

  @override
  String get voiceDeleteBody => 'Inspelningen tas bort permanent från servern.';

  @override
  String get serverChecking => 'kontrollerar…';

  @override
  String get serverReady => 'redo';

  @override
  String get serverDegraded => 'allt fungerar inte';

  @override
  String get serverOffline => 'inte tillgänglig';

  @override
  String get serverRecheck => 'Kontrollera igen';

  @override
  String get deviceTier => 'Den här enheten';

  @override
  String get deviceTierPublic => 'Bas: begränsad översättningstid per dag';

  @override
  String get deviceTierTester => 'Testare: längre översättning och egen röst';

  @override
  String get deviceTierUnknown => 'Servern svarar inte just nu';

  @override
  String get inviteCode => 'Inbjudningskod';

  @override
  String get inviteHelp => 'Från appens skapare, låser upp testningen';

  @override
  String get inviteWrong => 'Den här koden gäller inte';

  @override
  String get inviteUnavailable =>
      'Koden kan inte kontrolleras just nu, försök senare';

  @override
  String get errorQuota =>
      'Dagens översättningsminuter är slut, imorgon finns det fler';

  @override
  String get voiceNeedsInvite =>
      'Egen röst är tills vidare bara för testare med inbjudningskod';
}
