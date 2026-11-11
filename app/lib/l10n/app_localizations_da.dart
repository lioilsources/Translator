// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Tolk';

  @override
  String get me => 'Mig';

  @override
  String get colleague => 'Kollega';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Tilstand';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Hold og tal';

  @override
  String get modeStreaming => 'Løbende';

  @override
  String get chooseLanguage => 'Vælg sprog';

  @override
  String get history => 'Historik';

  @override
  String get settings => 'Indstillinger';

  @override
  String get serverUrl => 'Serveradresse';

  @override
  String get save => 'Gem';

  @override
  String get statusConnecting => 'Forbinder…';

  @override
  String get statusListening => 'Lytter';

  @override
  String get statusRecording => 'Jeg hører dig';

  @override
  String get statusTranslating => 'Oversætter';

  @override
  String get statusSpeaking => 'Taler';

  @override
  String get statusPaused => 'På pause';

  @override
  String get itWasMe => 'Det var mig';

  @override
  String get promptAuto => 'Tal en ad gangen';

  @override
  String get promptPtt => 'Hold nede og tal';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsæt';

  @override
  String get soundOn => 'Lyd til';

  @override
  String get soundOff => 'Kun tekst';

  @override
  String get endConversation => 'Afslut';

  @override
  String get volumeHint => 'Sæt lydstyrken på maks';

  @override
  String get share => 'Del';

  @override
  String get delete => 'Slet';

  @override
  String get noHistory => 'Ingen samtaler endnu';

  @override
  String get micDenied =>
      'Uden adgang til mikrofonen kan det ikke lade sig gøre. Tillad den i indstillingerne.';

  @override
  String get errorConnection => 'Forbindelsen til serveren blev mistet';

  @override
  String get errorBackend =>
      'Oversættelsestjenesten er ikke tilgængelig lige nu';

  @override
  String get errorVoice => 'Stemmen er ikke tilgængelig, teksten bliver';

  @override
  String get errorBusy => 'Serveren er fuld, prøv igen om lidt';

  @override
  String get errorTooLong => 'Ytringen er for lang';

  @override
  String get errorGeneric => 'Noget gik galt';

  @override
  String get cancel => 'Annuller';

  @override
  String get voiceLibrary => 'Mine stemmer';

  @override
  String get voiceAdd => 'Optag en stemme';

  @override
  String get voiceEmpty => 'Der er ingen stemmer her endnu.';

  @override
  String get voiceServerError => 'Stemmer er ikke tilgængelige lige nu';

  @override
  String get voiceDefault => 'Standardstemme';

  @override
  String get voiceName => 'Navngiv stemmen';

  @override
  String get voiceConsent =>
      'Jeg accepterer, at min stemmeoptagelse gemmes på serveren og bruges til at tale oversættelser med min stemme. Det er biometriske data, jeg må kun optage mig selv, og jeg trækker samtykket tilbage ved at slette stemmen.';

  @override
  String get voiceReadThis => 'Tryk på knappen og læs naturligt i 30 sekunder:';

  @override
  String get voiceSampleText =>
      'Goddag, det her er en prøve på min stemme. Jeg taler roligt og naturligt, som om jeg sad og snakkede med nogen ved et bord. I går gik jeg en tur, på vejen mødte jeg en gammel ven, og vi drak kaffe sammen. Han fortalte om sin tur til havet, om vejret, om god mad og om det, der venter ham på arbejdet. Når jeg er færdig med at læse, fortsætter jeg bare med mine egne ord, indtil optagelsen slutter.';

  @override
  String get voiceRecord => 'Optag 30 sekunder';

  @override
  String voiceRecording(int seconds) {
    return 'Optager, $seconds s tilbage';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Slet stemmen $name?';
  }

  @override
  String get voiceDeleteBody => 'Optagelsen slettes permanent fra serveren.';

  @override
  String get serverChecking => 'tjekker…';

  @override
  String get serverReady => 'klar';

  @override
  String get serverDegraded => 'ikke alt kører';

  @override
  String get serverOffline => 'utilgængelig';

  @override
  String get serverRecheck => 'Tjek igen';

  @override
  String get deviceTier => 'Denne enhed';

  @override
  String get deviceTierPublic => 'Basis: begrænset oversættelsestid pr. dag';

  @override
  String get deviceTierTester => 'Tester: længere oversættelse og egen stemme';

  @override
  String get deviceTierUnknown => 'Serveren svarer ikke lige nu';

  @override
  String get inviteCode => 'Invitationskode';

  @override
  String get inviteHelp => 'Fra appens skaber, låser op for test';

  @override
  String get inviteWrong => 'Den kode er ikke gyldig';

  @override
  String get inviteUnavailable => 'Koden kan ikke tjekkes lige nu, prøv senere';

  @override
  String get errorQuota =>
      'Dagens oversættelsesminutter er brugt, i morgen er der flere';

  @override
  String get voiceNeedsInvite =>
      'Egen stemme er indtil videre kun til testere med invitationskode';
}
