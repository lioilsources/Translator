import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_app/core/platform.dart';

/// A stand-in for the server's /v1/devices endpoints.
class _Server {
  late HttpServer _http;
  final calls = <String>[];
  final bearers = <String?>[];
  final bodies = <Map<String, dynamic>>[];
  var valid = <String>{};
  var registerStatus = 201;

  String get wsUrl => 'ws://127.0.0.1:${_http.port}/v1/ws';

  Future<void> start() async {
    _http = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _http.listen((r) async {
      final text = await utf8.decoder.bind(r).join();
      final auth = r.headers.value('authorization');
      final bearer = auth?.replaceFirst('Bearer ', '');
      calls.add('${r.method} ${r.uri.path}');
      bearers.add(bearer);
      bodies.add(text.isEmpty ? {} : jsonDecode(text) as Map<String, dynamic>);
      final res = r.response;
      void json(int status, Map<String, Object> body) {
        res.statusCode = status;
        res.write(jsonEncode(body));
      }

      switch (r.uri.path) {
        case '/v1/devices/me':
          if (valid.contains(bearer)) {
            json(200, {'deviceId': 'dev1', 'tier': 'public'});
          } else {
            res.statusCode = 401;
          }
        case '/v1/devices':
          if (registerStatus != 201) {
            res.statusCode = registerStatus;
            break;
          }
          final id = bodies.last['deviceId'] as String? ?? 'fresh-device-id';
          valid.add('tok-$id');
          json(201, {'token': 'tok-$id', 'deviceId': id, 'tier': bearer == null ? 'public' : 'tester'});
        case '/v1/devices/upgrade':
          if (bodies.last['invite'] == 'pozvanka') {
            json(200, {'token': 'tok-tester', 'deviceId': 'fresh-device-id', 'tier': 'tester'});
          } else {
            res.statusCode = 403;
          }
      }
      await res.close();
    });
  }

  Future<void> stop() => _http.close(force: true);
}

void main() {
  late _Server server;

  setUp(() async {
    server = _Server();
    await server.start();
  });
  tearDown(() => server.stop());

  Future<Settings> settings(Map<String, Object> prefs) async {
    SharedPreferences.setMockInitialValues(prefs);
    return (await Settings.load())..url = server.wsUrl;
  }

  test('a fresh phone registers without any token and keeps the answer', () async {
    final s = await settings({});
    expect(await DeviceAuth(s).ensure(), DeviceTier.public);
    expect(server.calls, ['POST /v1/devices']);
    expect(server.bearers.single, isNull);
    expect(server.bodies.single, isEmpty);
    expect(s.deviceToken, 'tok-fresh-device-id');
    expect(s.deviceId, 'fresh-device-id');
    expect(s.token, 'tok-fresh-device-id');

    expect(await DeviceAuth(s).ensure(), DeviceTier.public);
    expect(server.calls.last, 'GET /v1/devices/me');
    expect(server.calls, hasLength(2));
  });

  test('the old shared token carries the phone and its voices over', () async {
    final s = await settings({'token': 'shared', 'deviceId': 'old-uuid-1234'});
    expect(await DeviceAuth(s).ensure(), DeviceTier.tester);
    expect(server.bearers.single, 'shared');
    expect(server.bodies.single, {'deviceId': 'old-uuid-1234'});
    expect(s.token, 'tok-old-uuid-1234');
  });

  test('a revoked token is dropped and the phone registers again', () async {
    final s = await settings({'deviceToken': 'revoked'});
    expect(await DeviceAuth(s).ensure(), DeviceTier.public);
    expect(server.calls, ['GET /v1/devices/me', 'POST /v1/devices']);
    expect(s.deviceToken, 'tok-fresh-device-id');
  });

  test('a server without device tokens leaves the shared token in use', () async {
    server.registerStatus = 404;
    final s = await settings({'token': 'shared'});
    expect(await DeviceAuth(s).ensure(), isNull);
    expect(s.deviceToken, isNull);
    expect(s.token, 'shared');
  });

  test('an unreachable server changes nothing', () async {
    final s = await settings({'deviceToken': 'kept'});
    s.url = 'ws://127.0.0.1:1/v1/ws';
    expect(await DeviceAuth(s).ensure(), isNull);
    expect(s.deviceToken, 'kept');
  });

  test('an invite code upgrades the phone, a wrong one is rejected', () async {
    final s = await settings({});
    await expectLater(DeviceAuth(s).redeem('spatne'), throwsA(isA<InviteRejected>()));
    expect(await DeviceAuth(s).redeem('pozvanka'), DeviceTier.tester);
    expect(server.bearers.last, 'tok-fresh-device-id');
    expect(s.deviceToken, 'tok-tester');
  });
}
