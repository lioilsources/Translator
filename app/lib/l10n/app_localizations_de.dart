// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Dolmetscher';

  @override
  String get me => 'Ich';

  @override
  String get colleague => 'Kollege';

  @override
  String get start => 'Start';

  @override
  String get modeLabel => 'Modus';

  @override
  String get modeAuto => 'Auto';

  @override
  String get modePtt => 'Halten und sprechen';

  @override
  String get modeStreaming => 'Fortlaufend';

  @override
  String get chooseLanguage => 'Sprache wählen';

  @override
  String get history => 'Verlauf';

  @override
  String get settings => 'Einstellungen';

  @override
  String get serverUrl => 'Serveradresse';

  @override
  String get save => 'Speichern';

  @override
  String get statusConnecting => 'Verbinde…';

  @override
  String get statusListening => 'Ich höre zu';

  @override
  String get statusRecording => 'Ich höre Sie';

  @override
  String get statusTranslating => 'Übersetze';

  @override
  String get statusSpeaking => 'Spreche';

  @override
  String get statusPaused => 'Pausiert';

  @override
  String get itWasMe => 'Das war ich';

  @override
  String get promptAuto => 'Sprechen Sie nacheinander';

  @override
  String get promptPtt => 'Halten und sprechen';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Weiter';

  @override
  String get soundOn => 'Ton an';

  @override
  String get soundOff => 'Nur Text';

  @override
  String get endConversation => 'Beenden';

  @override
  String get volumeHint => 'Stellen Sie die Lautstärke auf Maximum';

  @override
  String get share => 'Teilen';

  @override
  String get delete => 'Löschen';

  @override
  String get noHistory => 'Noch keine Gespräche';

  @override
  String get micDenied =>
      'Ohne Zugriff auf das Mikrofon geht es nicht. Erlauben Sie ihn in den Einstellungen.';

  @override
  String get errorConnection => 'Die Verbindung zum Server ist abgebrochen';

  @override
  String get errorBackend =>
      'Der Übersetzungsdienst ist gerade nicht verfügbar';

  @override
  String get errorVoice => 'Die Stimme ist nicht verfügbar, der Text bleibt';

  @override
  String get errorBusy =>
      'Der Server ist voll, versuchen Sie es gleich noch einmal';

  @override
  String get errorTooLong => 'Die Äußerung ist zu lang';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get voiceLibrary => 'Meine Stimmen';

  @override
  String get voiceAdd => 'Stimme aufnehmen';

  @override
  String get voiceEmpty => 'Hier ist noch keine Stimme.';

  @override
  String get voiceServerError => 'Stimmen sind gerade nicht verfügbar';

  @override
  String get voiceDefault => 'Standardstimme';

  @override
  String get voiceName => 'Stimme benennen';

  @override
  String get voiceConsent =>
      'Ich stimme zu, dass meine Stimmaufnahme auf dem Server gespeichert und verwendet wird, um Übersetzungen mit meiner Stimme zu sprechen. Es sind biometrische Daten, ich darf nur mich selbst aufnehmen, und meine Einwilligung widerrufe ich durch Löschen der Stimme.';

  @override
  String get voiceReadThis =>
      'Drücken Sie die Taste und lesen Sie 30 Sekunden lang natürlich:';

  @override
  String get voiceSampleText =>
      'Guten Tag, das ist eine Probe meiner Stimme. Ich spreche ruhig und natürlich, so als würde ich mich mit jemandem am Tisch unterhalten. Gestern war ich spazieren, unterwegs traf ich einen alten Freund, und wir tranken zusammen einen Kaffee. Er erzählte mir von seiner Reise ans Meer, vom Wetter, vom guten Essen und davon, was ihn bei der Arbeit erwartet. Wenn ich mit dem Lesen fertig bin, spreche ich einfach mit eigenen Worten weiter, bis die Aufnahme endet.';

  @override
  String get voiceRecord => '30 Sekunden aufnehmen';

  @override
  String voiceRecording(int seconds) {
    return 'Aufnahme läuft, noch $seconds s';
  }

  @override
  String voiceDeleteTitle(String name) {
    return 'Stimme $name löschen?';
  }

  @override
  String get voiceDeleteBody =>
      'Die Aufnahme wird endgültig vom Server gelöscht.';

  @override
  String get serverChecking => 'prüfe…';

  @override
  String get serverReady => 'bereit';

  @override
  String get serverDegraded => 'nicht alles läuft';

  @override
  String get serverOffline => 'nicht erreichbar';

  @override
  String get serverRecheck => 'Erneut prüfen';

  @override
  String get deviceTier => 'Dieses Gerät';

  @override
  String get deviceTierPublic => 'Basis: begrenzte Übersetzungszeit pro Tag';

  @override
  String get deviceTierTester =>
      'Tester: längere Übersetzung und eigene Stimme';

  @override
  String get deviceTierUnknown => 'Der Server antwortet gerade nicht';

  @override
  String get inviteCode => 'Einladungscode';

  @override
  String get inviteHelp => 'Vom Autor der App, schaltet das Testen frei';

  @override
  String get inviteWrong => 'Dieser Code ist ungültig';

  @override
  String get inviteUnavailable =>
      'Der Code lässt sich gerade nicht prüfen, versuchen Sie es später';

  @override
  String get errorQuota =>
      'Die Übersetzungsminuten für heute sind aufgebraucht, morgen gibt es neue';

  @override
  String get voiceNeedsInvite =>
      'Die eigene Stimme gibt es vorerst nur für Tester mit Einladungscode';
}
