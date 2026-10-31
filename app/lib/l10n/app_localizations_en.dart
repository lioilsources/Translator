// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Interpreter';

  @override
  String get me => 'Me';

  @override
  String get colleague => 'Colleague';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Mode';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Push to talk';

  @override
  String get modeStreaming => 'Live';

  @override
  String get chooseLanguage => 'Choose a language';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get serverUrl => 'Server address';

  @override
  String get serverToken => 'Access token';

  @override
  String get save => 'Save';

  @override
  String get statusConnecting => 'Connecting…';

  @override
  String get statusListening => 'Listening';

  @override
  String get statusRecording => 'Hearing you';

  @override
  String get statusTranslating => 'Translating';

  @override
  String get statusSpeaking => 'Speaking';

  @override
  String get statusPaused => 'Paused';

  @override
  String get itWasMe => 'That was me';

  @override
  String get promptAuto => 'One at a time, please';

  @override
  String get promptPtt => 'Hold and speak';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get soundOn => 'Sound on';

  @override
  String get soundOff => 'Text only';

  @override
  String get endConversation => 'End';

  @override
  String get volumeHint => 'Turn the volume all the way up';

  @override
  String get share => 'Share';

  @override
  String get delete => 'Delete';

  @override
  String get noHistory => 'No conversations yet';

  @override
  String get micDenied =>
      'This needs microphone access. Please allow it in Settings.';

  @override
  String get errorConnection => 'Lost connection to the server';

  @override
  String get errorBackend => 'The translation service is unavailable';

  @override
  String get errorVoice => 'Voice unavailable, text only';

  @override
  String get errorBusy => 'The server is full, try again shortly';

  @override
  String get errorTooLong => 'That was too long to translate';

  @override
  String get errorGeneric => 'Something went wrong';
}
