// Fáze 0 plánu Ucho: mikrofon telefonu běží, zvuk jde do Bluetooth sluchátek
// a jednotlivé klipy se na chvíli přepnou na reproduktor. Měří přepnutí a
// výpadky mikrofonu; výsledek se sdílí jako text.
import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator_app/core/ear_spike.dart';
import 'package:translator_app/l10n/app_localizations.dart';

class EarSpikeScreen extends StatefulWidget {
  const EarSpikeScreen({super.key});

  @override
  State<EarSpikeScreen> createState() => _EarSpikeScreenState();
}

class _EarSpikeScreenState extends State<EarSpikeScreen> {
  final _avs = AVAudioSession();
  final _rec = AudioRecorder();
  final _player = AudioPlayer();
  final _results = <SpikeResult>[];
  final _clock = Stopwatch()..start();
  StreamSubscription<dynamic>? _mic;
  StreamSubscription<dynamic>? _routes;
  AVAudioSessionMode _mode = AVAudioSessionMode.defaultMode;
  bool _echoCancel = false;
  bool _running = false;
  bool _busy = false;
  String _route = '';
  int _frames = 0;
  int _lastFrame = 0;
  int _maxGap = 0;
  String? _clip;

  String get _config =>
      'mode ${_mode.name}, echoCancel $_echoCancel, a2dp, no hfp';

  @override
  void dispose() {
    unawaited(_stop());
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _start() async {
    if (!await _rec.hasPermission()) return;
    final file = File('${(await getTemporaryDirectory()).path}/ear_beep.wav');
    await file.writeAsBytes(beepWav(), flush: true);
    _clip = file.path;
    await (await AudioSession.instance).configure(
      AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        // A2DP only: allowing HFP would turn the headset into a phone-quality
        // headset with its own microphone, which the plan rules out.
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetoothA2dp,
        avAudioSessionMode: _mode,
      ),
    );
    await _rec.ios?.manageAudioSession(false);
    final stream = await _rec.startStream(
      RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
        echoCancel: _echoCancel,
        noiseSuppress: _echoCancel,
      ),
    );
    _lastFrame = _clock.elapsedMilliseconds;
    _mic = stream.listen((_) {
      final now = _clock.elapsedMilliseconds;
      _maxGap = _maxGap > now - _lastFrame ? _maxGap : now - _lastFrame;
      _lastFrame = now;
      _frames++;
    });
    _routes = _avs.routeChangeStream.listen((_) => _showRoute());
    await _showRoute();
    setState(() => _running = true);
  }

  Future<void> _stop() async {
    await _mic?.cancel();
    await _routes?.cancel();
    _mic = null;
    _routes = null;
    if (_running) await _rec.stop();
    if (mounted) setState(() => _running = false);
  }

  Future<List<String>> _outputs() async => [
    for (final p in (await _avs.currentRoute).outputs) p.portType.name,
  ];

  Future<void> _showRoute() async {
    final r = await _avs.currentRoute;
    String names(Iterable<AVAudioSessionPortDescription> ps) =>
        ps.map((p) => '${p.portType.name} (${p.portName})').join(', ');
    if (mounted) {
      setState(() => _route = '↓ ${names(r.inputs)}\n↑ ${names(r.outputs)}');
    }
  }

  /// Waits until the route does or does not include the speaker; returns ms.
  Future<int> _awaitSpeaker(bool wanted) async {
    final t0 = _clock.elapsedMilliseconds;
    while (_clock.elapsedMilliseconds - t0 < 2000) {
      if ((await _outputs()).contains('builtInSpeaker') == wanted) break;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    return _clock.elapsedMilliseconds - t0;
  }

  Future<void> _play(SpikeOutput out) async {
    _maxGap = 0;
    var switchMs = 0;
    var backMs = 0;
    if (out == SpikeOutput.speaker) {
      await _avs.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker);
      switchMs = await _awaitSpeaker(true);
    }
    final outputs = await _outputs();
    await _player.setFilePath(_clip!);
    await _player.seek(Duration.zero);
    await _player.play();
    await _player.stop();
    if (out == SpikeOutput.speaker) {
      await _avs.overrideOutputAudioPort(AVAudioSessionPortOverride.none);
      backMs = await _awaitSpeaker(false);
    }
    _results.add(
      SpikeResult(
        output: out,
        switchMs: switchMs,
        backMs: backMs,
        micGapMs: _maxGap,
        outputs: outputs,
      ),
    );
    await _showRoute();
  }

  Future<void> _run(Future<void> Function() body) async {
    setState(() => _busy = true);
    try {
      await body();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _series() async {
    for (var i = 0; i < 10; i++) {
      await _play(i.isEven ? SpikeOutput.ear : SpikeOutput.speaker);
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
  }

  /// Gives time to lock the phone; then plays to the ear and checks the mic.
  Future<void> _background() async {
    final before = _frames;
    await Future<void>.delayed(const Duration(seconds: 10));
    await _play(SpikeOutput.ear);
    final r = _results.removeLast();
    _results.add(
      SpikeResult(
        output: r.output,
        switchMs: r.switchMs,
        backMs: r.backMs,
        micGapMs: r.micGapMs,
        outputs: [...r.outputs, 'locked:${_frames - before}frames'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final idle = _running && !_busy;
    return Scaffold(
      appBar: AppBar(title: Text(l.earSpikeTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l.earSpikeIntro),
          const SizedBox(height: 12),
          SegmentedButton<AVAudioSessionMode>(
            segments: [
              for (final m in const [
                AVAudioSessionMode.defaultMode,
                AVAudioSessionMode.spokenAudio,
                AVAudioSessionMode.voiceChat,
              ])
                ButtonSegment(value: m, label: Text(m.name)),
            ],
            selected: {_mode},
            onSelectionChanged: _running
                ? null
                : (v) => setState(() => _mode = v.first),
          ),
          SwitchListTile(
            title: Text(l.earSpikeEchoCancel),
            value: _echoCancel,
            onChanged: _running ? null : (v) => setState(() => _echoCancel = v),
          ),
          FilledButton(
            onPressed: _busy ? null : (_running ? _stop : _start),
            child: Text(_running ? l.earSpikeStop : l.earSpikeStart),
          ),
          const SizedBox(height: 12),
          Text(_route, style: Theme.of(context).textTheme.bodySmall),
          Text(l.earSpikeFrames(_frames)),
          const Divider(),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: idle
                    ? () => _run(() => _play(SpikeOutput.ear))
                    : null,
                child: Text(l.earSpikeToEar),
              ),
              OutlinedButton(
                onPressed: idle
                    ? () => _run(() => _play(SpikeOutput.speaker))
                    : null,
                child: Text(l.earSpikeToSpeaker),
              ),
              OutlinedButton(
                onPressed: idle ? () => _run(_series) : null,
                child: Text(l.earSpikeSeries),
              ),
              OutlinedButton(
                onPressed: idle ? () => _run(_background) : null,
                child: Text(l.earSpikeLocked),
              ),
            ],
          ),
          const Divider(),
          for (final r in _results.reversed)
            Text(r.toLine(), style: Theme.of(context).textTheme.bodySmall),
          if (_results.isNotEmpty)
            TextButton.icon(
              onPressed: () => SharePlus.instance.share(
                ShareParams(text: spikeReport(_config, _results)),
              ),
              icon: const Icon(Icons.ios_share),
              label: Text(l.earSpikeShare),
            ),
        ],
      ),
    );
  }
}
