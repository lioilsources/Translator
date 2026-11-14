// The checks from ol1n_telemetry's test kit (README "Testovací sada"):
// dictionary ↔ docs/telemetry.md, no free text, version constant ↔ pubspec,
// literal event names, no key → no network, off → nothing. Plus the
// mappings this app adds.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ol1n_telemetry/testing.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/telemetry/telemetry_dictionary.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('docs/telemetry.md lists exactly the dictionary', () {
    expect(
      telemetryDocProblems(
        appDictionary,
        File('../docs/telemetry.md').readAsStringSync(),
      ),
      isEmpty,
    );
  });

  test('no property is free text', () {
    expect(telemetryDictionaryProblems(appDictionary), isEmpty);
  });

  test('app version matches pubspec.yaml', () {
    expect(
      telemetryVersionProblems(
        kAppVersion,
        File('pubspec.yaml').readAsStringSync(),
      ),
      isEmpty,
    );
  });

  test('the code sends only dictionary events, and every one of them', () {
    expect(telemetryTrackCallProblems(appDictionary), isEmpty);
  });

  test('no key, no network', () async {
    expect(await telemetryNoKeyProblems(appDictionary), isEmpty);
  }, skip: const bool.fromEnvironment('TELEMETRY_DEBUG'));

  test('off means nothing', () async {
    expect(await telemetryOffProblems(appDictionary), isEmpty);
  });

  test('every screen route is a named route the observer knows', () {
    final names = RegExp(r"RouteSettings\(name: '([^']+)'\)");
    final used = {
      for (final f in Directory('lib').listSync(recursive: true))
        if (f is File && f.path.endsWith('.dart'))
          for (final m in names.allMatches(f.readAsStringSync())) m.group(1)!,
    };
    expect(used.difference(kScreenRoutes.keys.toSet()), isEmpty);
    expect(kScreenRoutes.keys.toSet().difference({...used, '/'}), isEmpty);
  });

  test('a conversation with any translation is ok, else the error decides', () {
    expect(translateResult(translated: true, lastError: 'quota'), 'ok');
    expect(translateResult(translated: false), 'cancel');
    expect(
      translateResult(translated: false, lastError: 'connection_lost'),
      'offline',
    );
    expect(
      translateResult(translated: false, lastError: 'mt_unavailable'),
      'no_gpu',
    );
    expect(translateResult(translated: false, lastError: 'queue_full'), 'busy');
    expect(translateResult(translated: false, lastError: 'quota'), 'quota');
    expect(translateResult(translated: false, lastError: 'too_long'), 'error');
    for (final code in ['connection_lost', 'busy', 'tts_unavailable', 'x']) {
      expect(appDictionary.errorKinds, contains(telemetryErrorKind(code)));
    }
  });

  test('languages and servers stay closed lists', () {
    expect(telemetryLang('cs'), 'cs');
    expect(telemetryLang('klingon'), 'other');
    expect(telemetryServer(servers['SPARK']!), 'spark');
    expect(telemetryServer('wss://example.invalid/v1/ws'), 'custom');
  });
}
