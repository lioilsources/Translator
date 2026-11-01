import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart' as session;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator_core/translator_core.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

const _defaultUrl = String.fromEnvironment(
  'TRANSLATOR_URL',
  defaultValue: 'wss://tlumocnik.ol1n.com/v1/ws',
);

/// Backends offered in settings; both accept the same token.
const servers = {
  'L40S': 'wss://tlumocnik.ol1n.com/v1/ws',
  'SPARK': 'wss://tlumocnik-spark.ol1n.com/v1/ws',
};

const _defaultToken = String.fromEnvironment('TRANSLATOR_TOKEN');

/// WebSocket transport; binary frames arrive as Uint8List.
class WsTransport implements Transport {
  WsTransport(String url, String token)
    : _channel = IOWebSocketChannel.connect(
        url,
        headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
        pingInterval: const Duration(seconds: 15),
      );

  final IOWebSocketChannel _channel;

  @override
  Stream<Object> get frames => _channel.stream.map((f) {
    if (f is String) return f;
    return f is Uint8List ? f : Uint8List.fromList(f as List<int>);
  });

  @override
  void sendText(String text) => _channel.sink.add(text);

  @override
  void sendBinary(Uint8List data) => _channel.sink.add(data);

  @override
  Future<void> close() => _channel.sink.close();
}

/// Microphone as 16 kHz mono PCM16 with the platform echo canceller on.
class MicCapture {
  final _rec = AudioRecorder();
  StreamSubscription<Uint8List>? _sub;

  Future<bool> hasPermission() => _rec.hasPermission();

  Future<void> start(void Function(Uint8List) onFrame) async {
    final audio = await session.AudioSession.instance;
    await audio.configure(
      const session.AudioSessionConfiguration(
        avAudioSessionCategory: session.AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            session.AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: session.AVAudioSessionMode.voiceChat,
      ),
    );
    final stream = await _rec.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
        echoCancel: true,
        noiseSuppress: true,
      ),
    );
    _sub = stream.listen(onFrame);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    await _rec.stop();
    await _rec.dispose();
  }
}

/// Plays a clip from a temp file. Whole clips, so no streaming source needed.
class JustAudioClipPlayer implements ClipPlayer {
  final _player = AudioPlayer();
  int _n = 0;

  @override
  Future<void> play(Uint8List clip, String format) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/tts_${_n++ % 8}.$format');
    await file.writeAsBytes(clip, flush: true);
    await _player.setFilePath(file.path);
    await _player.seek(Duration.zero);
    await _player.play();
    await _player.stop();
  }

  @override
  Future<void> stop() => _player.stop();
}

/// Persisted user choices.
class Settings {
  Settings(this._prefs);

  static Future<Settings> load() async =>
      Settings(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  String get url => _prefs.getString('url') ?? _defaultUrl;
  set url(String v) => _prefs.setString('url', v);

  String get token => _prefs.getString('token') ?? _defaultToken;
  set token(String v) => _prefs.setString('token', v);

  String get langA => _prefs.getString('langA') ?? 'cs';
  set langA(String v) => _prefs.setString('langA', v);

  String get langB => _prefs.getString('langB') ?? 'en';
  set langB(String v) => _prefs.setString('langB', v);

  Mode get mode => Mode.values.asNameMap()[_prefs.getString('mode')] ?? Mode.auto;
  set mode(Mode v) => _prefs.setString('mode', v.name);

  /// Wire names of the chosen voices, null for the language's default.
  String? get voiceA => _prefs.getString('voiceA');
  set voiceA(String? v) => _setVoice('voiceA', v);

  String? get voiceB => _prefs.getString('voiceB');
  set voiceB(String? v) => _setVoice('voiceB', v);

  /// Switches backend. Voice libraries live per server, so choices are reset.
  void useServer(String wsUrl) {
    if (wsUrl == url) return;
    url = wsUrl;
    voiceA = null;
    voiceB = null;
  }

  void _setVoice(String key, String? v) =>
      v == null ? _prefs.remove(key) : _prefs.setString(key, v);

  void forgetVoice(String id) {
    final wire = Voice.wirePrefix + id;
    if (voiceA == wire) voiceA = null;
    if (voiceB == wire) voiceB = null;
  }

  List<String> get recentLangs => _prefs.getStringList('recent') ?? const [];
  void noteLang(String lang) => _prefs.setStringList('recent', [
    lang,
    ...recentLangs.where((l) => l != lang),
  ].take(4).toList());

  String get deviceId {
    final id = _prefs.getString('deviceId');
    if (id != null) return id;
    final fresh = const Uuid().v4();
    _prefs.setString('deviceId', fresh);
    return fresh;
  }
}

/// Whether a backend can take a conversation right now.
enum ServerHealth { checking, ready, degraded, offline }

ServerHealth parseHealth(int status, String body) {
  if (status != 200) return ServerHealth.offline;
  try {
    final json = jsonDecode(body) as Map<String, dynamic>;
    return json['status'] == 'ready'
        ? ServerHealth.ready
        : ServerHealth.degraded;
  } on FormatException {
    return ServerHealth.offline;
  }
}

/// Asks a backend's /healthz, which also probes its speech and LLM services.
Future<ServerHealth> checkServer(String wsUrl) async {
  final ws = Uri.parse(wsUrl);
  final uri = ws.replace(
    scheme: ws.scheme == 'ws' ? 'http' : 'https',
    path: '/healthz',
  );
  final http = HttpClient()..connectionTimeout = const Duration(seconds: 5);
  try {
    final request = await http.getUrl(uri);
    final response = await request.close().timeout(const Duration(seconds: 5));
    final body = await response.transform(utf8.decoder).join();
    return parseHealth(response.statusCode, body);
  } on Exception {
    return ServerHealth.offline;
  } finally {
    http.close(force: true);
  }
}

/// One recorded voice from the user's library on the server.
class Voice {
  const Voice({required this.id, required this.name});

  factory Voice.fromJson(Map<String, dynamic> json) =>
      Voice(id: json['id'] as String, name: json['name'] as String);

  static const wirePrefix = 'clone:';

  final String id;
  final String name;

  String get wireName => wirePrefix + id;
}

/// The voice library over HTTP. The base URL follows the conversation URL.
class VoiceLibrary {
  VoiceLibrary(this._settings);

  final Settings _settings;
  final _http = HttpClient();

  Uri _uri(String path, [Map<String, String> query = const {}]) {
    final ws = Uri.parse(_settings.url);
    return ws.replace(
      scheme: ws.scheme == 'ws' ? 'http' : 'https',
      path: '/v1/voices$path',
      queryParameters: {'device': _settings.deviceId, ...query},
    );
  }

  Future<String> _send(
    String method,
    Uri uri, {
    Uint8List? body,
    required int expect,
  }) async {
    final request = await _http.openUrl(method, uri);
    request.headers.set('Authorization', 'Bearer ${_settings.token}');
    if (body != null) {
      request.headers.contentType = ContentType.binary;
      request.contentLength = body.length;
      request.add(body);
    }
    final response = await request.close();
    final text = await response.transform(utf8.decoder).join();
    if (response.statusCode != expect) {
      throw HttpException('voices: status ${response.statusCode}', uri: uri);
    }
    return text;
  }

  Future<List<Voice>> list() async {
    final text = await _send('GET', _uri(''), expect: 200);
    return [
      for (final item in jsonDecode(text) as List<dynamic>)
        Voice.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<void> create(String name, Uint8List pcm) => _send(
    'POST',
    _uri('', {'name': name, 'consent': 'true'}),
    body: pcm,
    expect: 201,
  );

  Future<void> delete(String id) => _send('DELETE', _uri('/$id'), expect: 204);
}

/// History as one JSON file per conversation, on the device only.
class FileTranscriptStore implements TranscriptStore {
  Future<Directory> _dir() async {
    final base = await getApplicationSupportDirectory();
    return Directory('${base.path}/history').create(recursive: true);
  }

  @override
  Future<void> save(Transcript t) async {
    final dir = await _dir();
    await File('${dir.path}/${t.id}.json').writeAsString(t.encode(), flush: true);
  }

  @override
  Future<List<Transcript>> list() async {
    final dir = await _dir();
    final out = <Transcript>[];
    await for (final f in dir.list()) {
      if (f is! File || !f.path.endsWith('.json')) continue;
      try {
        out.add(Transcript.decode(await f.readAsString(encoding: utf8)));
      } on FormatException {
        continue; // a damaged file must not hide the rest of the history
      }
    }
    return out..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  @override
  Future<void> delete(String id) async {
    final dir = await _dir();
    await File('${dir.path}/$id.json').delete();
  }
}
