// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'Tolk';

  @override
  String get me => 'Meg';

  @override
  String get colleague => 'Kollega';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Modus';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Hold og snakk';

  @override
  String get modeStreaming => 'Kontinuerlig';

  @override
  String get chooseLanguage => 'Velg språk';

  @override
  String get history => 'Historikk';

  @override
  String get settings => 'Innstillinger';

  @override
  String get serverUrl => 'Serveradresse';

  @override
  String get save => 'Lagre';

  @override
  String get statusConnecting => 'Kobler til…';

  @override
  String get statusListening => 'Lytter';

  @override
  String get statusRecording => 'Jeg hører deg';

  @override
  String get statusTranslating => 'Oversetter';

  @override
  String get statusSpeaking => 'Snakker';

  @override
  String get statusPaused => 'Satt på pause';

  @override
  String get itWasMe => 'Det var meg';

  @override
  String get promptAuto => 'Snakk én om gangen';

  @override
  String get promptPtt => 'Hold nede og snakk';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsett';

  @override
  String get soundOn => 'Lyd på';

  @override
  String get soundOff => 'Bare tekst';

  @override
  String get endConversation => 'Avslutt';

  @override
  String get volumeHint => 'Sett volumet på maks';

  @override
  String get share => 'Del';

  @override
  String get delete => 'Slett';

  @override
  String get noHistory => 'Ingen samtaler ennå';

  @override
  String get micDenied =>
      'Uten tilgang til mikrofonen går det ikke. Tillat den i innstillingene.';

  @override
  String get errorConnection => 'Forbindelsen til serveren ble brutt';

  @override
  String get errorBackend =>
      'Oversettelsestjenesten er ikke tilgjengelig akkurat nå';

  @override
  String get errorVoice => 'Stemmen er ikke tilgjengelig, teksten blir';

  @override
  String get errorBusy => 'Serveren er full, prøv igjen om litt';

  @override
  String get errorTooLong => 'Innlegget er for langt';

  @override
  String get errorGeneric => 'Noe gikk galt';

  @override
  String get cancel => 'Avbryt';

  @override
  String get voiceLibrary => 'Mine stemmer';

  @override
  String get voiceAdd => 'Ta opp en stemme';

  @override
  String get voiceEmpty => 'Det er ingen stemmer her ennå.';

  @override
  String get voiceServerError => 'Stemmer er ikke tilgjengelige akkurat nå';

  @override
  String get voiceDefault => 'Standardstemme';

  @override
  String get voiceName => 'Gi stemmen et navn';

  @override
  String get voiceConsent =>
      'Jeg samtykker til at opptaket av stemmen min lagres på serveren og brukes til å si oversettelser med stemmen min. Det er biometriske data, jeg kan bare ta opp meg selv, og jeg trekker samtykket tilbake ved å slette stemmen.';

  @override
  String get voiceReadThis => 'Trykk på knappen og les naturlig i 30 sekunder:';

  @override
  String get voiceSampleText =>
      'God dag, dette er en prøve på stemmen min. Jeg snakker rolig og naturlig, som om jeg satt og pratet med noen ved et bord. I går gikk jeg en tur, på veien møtte jeg en gammel venn, og vi drakk kaffe sammen. Han fortalte om turen sin til sjøen, om været, om god mat og om hva som venter ham på jobben. Når jeg er ferdig med å lese, fortsetter jeg med mine egne ord til opptaket slutter.';

  @override
  String get voiceRecord => 'Ta opp 30 sekunder';

  @override
  String voiceRecording(int seconds) {
    return 'Tar opp, $seconds s igjen';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Slette stemmen $name?';
  }

  @override
  String get voiceDeleteBody => 'Opptaket slettes permanent fra serveren.';

  @override
  String get serverChecking => 'sjekker…';

  @override
  String get serverReady => 'klar';

  @override
  String get serverDegraded => 'ikke alt kjører';

  @override
  String get serverOffline => 'utilgjengelig';

  @override
  String get serverRecheck => 'Sjekk på nytt';

  @override
  String get deviceTier => 'Denne enheten';

  @override
  String get deviceTierPublic => 'Basis: begrenset oversettelsestid per dag';

  @override
  String get deviceTierTester => 'Tester: lengre oversettelse og egen stemme';

  @override
  String get deviceTierUnknown => 'Serveren svarer ikke akkurat nå';

  @override
  String get inviteCode => 'Invitasjonskode';

  @override
  String get inviteHelp => 'Fra appens skaper, låser opp testing';

  @override
  String get inviteWrong => 'Denne koden er ikke gyldig';

  @override
  String get inviteUnavailable =>
      'Koden kan ikke sjekkes akkurat nå, prøv senere';

  @override
  String get errorQuota =>
      'Dagens oversettelsesminutter er brukt opp, i morgen er det mer';

  @override
  String get voiceNeedsInvite =>
      'Egen stemme er foreløpig bare for testere med invitasjonskode';
}
