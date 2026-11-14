import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/ui/languages.dart';

/// Id of this app at the collector (`apps.yaml` in StoreMetrics).
const kTelemetryApp = 'tlumocnik';

/// The app version this build reports; `test/telemetry_test.dart` keeps it
/// equal to `version:` in `pubspec.yaml`.
const kAppVersion = '1.0.0';

/// Route name → screen. Every pushed page carries one of these names.
const kScreenRoutes = {
  '/': 'setup',
  '/conversation': 'conversation',
  '/history': 'history',
  '/transcript': 'transcript',
  '/voices': 'voices',
  '/voices/record': 'voice_record',
  '/settings': 'settings',
};

/// Conversation languages as a closed list: the codes offered in setup.
final kLanguageCodes = {for (final l in languages) l.code, 'other'};

/// Where a conversation stands when it ends: before the socket (`setup`), or
/// the conversation phase at that moment.
const kTranslateSteps = {
  'setup',
  'connecting',
  'listening',
  'recording',
  'translating',
  'speaking',
  'paused',
};

/// Outcomes of `translate_end` beyond the package's `ok`, `cancel`, `error`
/// and `background`.
const kTranslateResults = {'no_mic', 'offline', 'no_gpu', 'busy', 'quota'};

/// The one event dictionary of this app, mirrored in `docs/telemetry.md`.
/// Nothing about speech, text or translations: only enums, counts and times.
final appDictionary = TelemetryDictionary(
  appVersion: kAppVersion,
  languages: {
    for (final l in AppLocalizations.supportedLocales) telemetryLocaleId(l),
  },
  screens: kScreenRoutes.values.toSet(),
  features: {
    'ptt',
    'streaming',
    'pause',
    'tts_off',
    'speaker_force',
    'clone_voice',
    'voice_record',
    'history',
    'transcript_share',
    'server_switch',
    'invite',
  },
  errorKinds: {
    'mic_denied',
    'connection',
    'backend',
    'voice',
    'busy',
    'quota',
    'too_long',
    'generic',
    'invite_wrong',
    'invite_unavailable',
    'voice_server',
  },
  lockedTargets: {'voice_record'},
  common: {
    'server': const EnumProp({'l40s', 'spark', 'custom'}),
  },
  events: {
    ...TelemetryDictionary.flow(
      'translate',
      results: kTranslateResults,
      start: {
        'lang_a': EnumProp(kLanguageCodes),
        'lang_b': EnumProp(kLanguageCodes),
      },
      end: {'step': const EnumProp(kTranslateSteps)},
    ),
    'translate_ready': {'ms': const IntProp(600000)},
  },
);

/// A conversation language as the dictionary knows it.
String telemetryLang(String code) =>
    kLanguageCodes.contains(code) ? code : 'other';

/// The backend in use, never its address.
String telemetryServer(String url) => switch (url) {
  _ when url == servers['L40S'] => 'l40s',
  _ when url == servers['SPARK'] => 'spark',
  _ => 'custom',
};

/// Error codes of the conversation (docs/protocol.md) → `error_shown.kind`,
/// grouped as the conversation screen shows them.
String telemetryErrorKind(String code) => switch (code) {
  'connection_lost' => 'connection',
  'asr_unavailable' || 'mt_unavailable' => 'backend',
  'tts_unavailable' || 'playback_failed' => 'voice',
  'busy' || 'queue_full' => 'busy',
  'quota' => 'quota',
  'too_long' => 'too_long',
  _ => 'generic',
};

/// How a conversation ended. Any translation at all counts as `ok`;
/// otherwise the last error decides, and none means the user left.
String translateResult({required bool translated, String? lastError}) {
  if (translated) return 'ok';
  return switch (lastError) {
    null => 'cancel',
    'connection_lost' => 'offline',
    'asr_unavailable' || 'mt_unavailable' => 'no_gpu',
    'busy' || 'queue_full' => 'busy',
    'quota' => 'quota',
    _ => 'error',
  };
}

/// The client's few values in the app's existing SharedPreferences.
class PrefsTelemetryStore implements TelemetryStore {
  PrefsTelemetryStore(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<String?> read(String key) async => _prefs.getString(key);

  @override
  Future<void> write(String key, String value) => _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}
