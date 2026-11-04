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

  @override
  String get cancel => 'Cancel';

  @override
  String get voiceLibrary => 'My voices';

  @override
  String get voiceAdd => 'Record a voice';

  @override
  String get voiceEmpty => 'No voices yet.';

  @override
  String get voiceServerError => 'Voices are not available right now';

  @override
  String get voiceDefault => 'Default voice';

  @override
  String get voiceName => 'Name this voice';

  @override
  String get voiceConsent =>
      'I agree to my voice recording being stored on the server and used to speak translations in my voice. It is biometric data, I may only record myself, and deleting the voice withdraws my consent.';

  @override
  String get voiceReadThis =>
      'Press the button and read naturally for 30 seconds:';

  @override
  String get voiceSampleText =>
      'Hello, this is a sample of my voice. I am speaking calmly and naturally, as if I were chatting with someone at a table. Yesterday I went for a walk, ran into an old friend, and we had a coffee together. He told me about his trip to the seaside, the weather, the good food, and what is waiting for him at work. When I finish reading, I will simply carry on in my own words until the recording ends.';

  @override
  String get voiceRecord => 'Record 30 seconds';

  @override
  String voiceRecording(int seconds) {
    return 'Recording, $seconds s left';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Delete the voice $name?';
  }

  @override
  String get voiceDeleteBody =>
      'The recording is permanently removed from the server.';

  @override
  String get serverChecking => 'checking…';

  @override
  String get serverReady => 'ready';

  @override
  String get serverDegraded => 'partly down';

  @override
  String get serverOffline => 'offline';

  @override
  String get serverRecheck => 'Check again';

  @override
  String get deviceTier => 'This device';

  @override
  String get deviceTierPublic => 'Basic: limited translation time a day';

  @override
  String get deviceTierTester =>
      'Tester: longer translation and your own voice';

  @override
  String get deviceTierUnknown => 'The server is not answering';

  @override
  String get inviteCode => 'Invite code';

  @override
  String get inviteHelp => 'From the app\'s author, unlocks testing';

  @override
  String get inviteWrong => 'This code is not valid';

  @override
  String get inviteUnavailable => 'The code cannot be checked now, try later';

  @override
  String get errorQuota =>
      'Today\'s translation minutes are used up, more tomorrow';

  @override
  String get voiceNeedsInvite =>
      'Your own voice is for testers with an invite code for now';
}
