import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/telemetry/telemetry_dictionary.dart';
import 'package:translator_app/ui/conversation_view.dart';
import 'package:translator_app/ui/languages.dart';
import 'package:translator_app/ui/voices.dart';
import 'package:translator_core/translator_core.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({required this.settings, super.key});
  final Settings settings;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  Settings get s => widget.settings;
  List<Voice> _voices = const [];

  @override
  void initState() {
    super.initState();
    unawaited(_loadVoices());
  }

  /// A server without cloning, or no connection, simply offers no voices.
  Future<void> _loadVoices() async {
    try {
      final voices = await VoiceLibrary(s).list();
      if (mounted) setState(() => _voices = voices);
    } on Exception {
      if (mounted) setState(() => _voices = const []);
    }
  }

  Future<void> _openLibrary() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/voices'),
        builder: (_) => VoiceLibraryScreen(settings: s),
      ),
    );
    await _loadVoices();
  }

  Future<void> _pick({required bool isA}) async {
    final recent = s.recentLangs.map(languageOf).toList();
    final rest = languages.where((l) => !s.recentLangs.contains(l.code));
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(AppLocalizations.of(context).chooseLanguage)),
            for (final lang in [...recent, ...rest])
              ListTile(
                leading: Text(lang.flag, style: const TextStyle(fontSize: 24)),
                title: Text(lang.name),
                onTap: () => Navigator.pop(context, lang.code),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isA) {
        s.langA = picked;
      } else {
        s.langB = picked;
      }
      s.noteLang(picked);
    });
  }

  Future<void> _start() async {
    final mic = MicCapture();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context);
    // The flow covers the whole wait, from the tap to the end of the
    // conversation; only the pair of languages goes with it.
    var step = 'setup';
    final flow = Telemetry.flow('translate', {
      'lang_a': telemetryLang(s.langA),
      'lang_b': telemetryLang(s.langB),
    }, () => {'step': step});
    if (s.mode == Mode.ptt) Telemetry.feature('ptt');
    if (s.mode == Mode.streaming) Telemetry.feature('streaming');
    if (!await mic.hasPermission()) {
      Telemetry.errorShown('mic_denied');
      flow.end('no_mic', {'step': 'setup'});
      messenger.showSnackBar(SnackBar(content: Text(l.micDenied)));
      return;
    }
    // A first start registers the phone; later ones check its token still works.
    await DeviceAuth(s).ensure();
    await navigator.push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/conversation'),
        builder: (_) => LiveConversationScreen(
          settings: s,
          mic: mic,
          flow: flow,
          onStep: (v) => step = v,
        ),
      ),
    );
    // Whatever way the screen went, the flow has an end.
    flow.end('cancel', {'step': 'setup'});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        actions: [
          IconButton(
            tooltip: l.history,
            icon: const Icon(Icons.history),
            onPressed: () {
              Telemetry.feature('history');
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  settings: const RouteSettings(name: '/history'),
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: l.voiceLibrary,
            icon: const Icon(Icons.record_voice_over),
            onPressed: _openLibrary,
          ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                settings: const RouteSettings(name: '/settings'),
                builder: (_) => SettingsScreen(settings: s),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _LangCard(
              label: l.me,
              language: languageOf(s.langA),
              onTap: () => _pick(isA: true),
            ),
            if (_voices.isNotEmpty)
              VoicePicker(
                voices: _voices,
                selected: s.voiceA,
                onChanged: (v) => setState(() => s.voiceA = v),
              ),
            const SizedBox(height: 12),
            _LangCard(
              label: l.colleague,
              language: languageOf(s.langB),
              onTap: () => _pick(isA: false),
            ),
            if (_voices.isNotEmpty)
              VoicePicker(
                voices: _voices,
                selected: s.voiceB,
                onChanged: (v) => setState(() => s.voiceB = v),
              ),
            const SizedBox(height: 24),
            SegmentedButton<Mode>(
              segments: [
                ButtonSegment(value: Mode.auto, label: Text(l.modeAuto)),
                ButtonSegment(value: Mode.ptt, label: Text(l.modePtt)),
                ButtonSegment(
                  value: Mode.streaming,
                  label: Text(l.modeStreaming),
                ),
              ],
              selected: {s.mode},
              onSelectionChanged: (v) => setState(() => s.mode = v.first),
            ),
            const Spacer(),
            Text(l.volumeHint, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _start,
              style: FilledButton.styleFrom(padding: const EdgeInsets.all(20)),
              child: Text(l.start),
            ),
          ],
        ),
      ),
    );
  }
}

class _LangCard extends StatelessWidget {
  const _LangCard({
    required this.label,
    required this.language,
    required this.onTap,
  });

  final String label;
  final Language language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Text(language.flag, style: const TextStyle(fontSize: 32)),
      title: Text(language.name),
      subtitle: Text(label),
      onTap: onTap,
    ),
  );
}

/// Wires the real microphone, player and socket to the controller.
class LiveConversationScreen extends StatefulWidget {
  const LiveConversationScreen({
    required this.settings,
    required this.mic,
    this.flow,
    this.onStep,
    super.key,
  });

  final Settings settings;
  final MicCapture mic;

  /// The `translate` flow this conversation ends.
  final TelemetryFlow? flow;

  /// Tells the flow where the conversation stands, for an end written while
  /// the app is in the background.
  final void Function(String step)? onStep;

  @override
  State<LiveConversationScreen> createState() => _LiveConversationScreenState();
}

class _LiveConversationScreenState extends State<LiveConversationScreen> {
  late final ConversationController _c;
  final _store = FileTranscriptStore();
  final _opened = DateTime.now();
  var _ready = false;
  var _translated = false;
  String? _shownError;

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    final transcript = Transcript(
      id: const Uuid().v4(),
      startedAt: DateTime.now(),
      langA: s.langA,
      langB: s.langB,
    );
    _c = ConversationController(
      transport: WsTransport(s.url, s.token),
      player: JustAudioClipPlayer(),
      state: ConversationState(transcript),
      mode: s.mode,
      onChanged: () {
        _observe();
        if (mounted) setState(() {});
      },
    );
    if (s.voiceA != null || s.voiceB != null) Telemetry.feature('clone_voice');
    _c.start(
      deviceId: s.deviceId,
      langA: s.langA,
      langB: s.langB,
      voiceA: s.voiceA,
      voiceB: s.voiceB,
    );
    unawaited(WakelockPlus.enable());
    unawaited(widget.mic.start(_c.onMicFrame));
  }

  /// Statistics read only phases, error codes and whether any translation
  /// arrived; never the text.
  void _observe() {
    final state = _c.state;
    widget.onStep?.call(state.phase.name);
    if (!_ready && state.phase != Phase.connecting) {
      _ready = true;
      Telemetry.track('translate_ready', {
        'ms': DateTime.now()
            .difference(_opened)
            .inMilliseconds
            .clamp(0, 600000),
      });
    }
    if (!_translated &&
        state.transcript.entries.any((e) => e.translation.isNotEmpty)) {
      _translated = true;
      Telemetry.activation();
    }
    final error = state.lastError;
    if (error != null && error != _shownError) {
      _shownError = error;
      Telemetry.errorShown(telemetryErrorKind(error));
    }
  }

  Future<void> _end() async {
    final navigator = Navigator.of(context);
    widget.flow?.end(
      translateResult(translated: _translated, lastError: _c.state.lastError),
      {'step': _c.state.phase.name},
    );
    await widget.mic.stop();
    await _c.close();
    await WakelockPlus.disable();
    final t = _c.state.transcript;
    if (t.entries.isNotEmpty) await _store.save(t);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) unawaited(_end());
    },
    child: ConversationView(controller: _c, onEnd: _end),
  );
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _store = FileTranscriptStore();
  late Future<List<Transcript>> _items = _store.list();

  void _reload() => setState(() => _items = _store.list());

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.history)),
      body: FutureBuilder(
        future: _items,
        builder: (context, snap) {
          final items = snap.data;
          if (items == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) return Center(child: Text(l.noHistory));
          return ListView(
            children: [
              for (final t in items)
                ListTile(
                  title: Text(
                    '${languageOf(t.langA).flag} ${languageOf(t.langB).flag}  '
                    '${MaterialLocalizations.of(context).formatShortDate(t.startedAt)}',
                  ),
                  subtitle: Text(
                    t.entries.isEmpty ? '' : t.entries.first.original,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      settings: const RouteSettings(name: '/transcript'),
                      builder: (_) => TranscriptScreen(transcript: t),
                    ),
                  ),
                  trailing: IconButton(
                    tooltip: l.delete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await _store.delete(t.id);
                      _reload();
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// One past conversation to read: who said what, and its translation.
class TranscriptScreen extends StatelessWidget {
  const TranscriptScreen({required this.transcript, super.key});
  final Transcript transcript;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = transcript;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${languageOf(t.langA).flag} ${languageOf(t.langB).flag}  '
          '${MaterialLocalizations.of(context).formatShortDate(t.startedAt)}',
        ),
        actions: [
          IconButton(
            tooltip: l.share,
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              Telemetry.feature('transcript_share');
              unawaited(
                SharePlus.instance.share(ShareParams(text: t.exportText())),
              );
            },
          ),
        ],
      ),
      body: SelectionArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: t.entries.length,
          itemBuilder: (context, i) => _Utterance(entry: t.entries[i]),
        ),
      ),
    );
  }
}

class _Utterance extends StatelessWidget {
  const _Utterance({required this.entry});
  final TranscriptEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = entry.side != Side.b;
    final time = TimeOfDay.fromDateTime(entry.at).format(context);
    return Align(
      alignment: mine ? Alignment.centerLeft : Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.88,
        child: Card(
          color: mine
              ? theme.colorScheme.surfaceContainerHighest
              : theme.colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$time  ${entry.original}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (entry.translation.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(entry.translation, style: theme.textTheme.titleMedium),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.settings, super.key});
  final Settings settings;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final _url = TextEditingController(text: widget.settings.url);
  final _invite = TextEditingController();
  final _health = <String, ServerHealth>{};
  DeviceTier? _tier;
  String? _inviteError;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_checkServers());
    unawaited(_checkDevice());
  }

  Future<void> _checkDevice() async {
    final tier = await DeviceAuth(widget.settings).ensure();
    if (mounted) setState(() => _tier = tier);
  }

  String _tierLabel(AppLocalizations l) => switch (_tier) {
    DeviceTier.public => l.deviceTierPublic,
    DeviceTier.tester => l.deviceTierTester,
    DeviceTier.legacy => l.deviceTierTester,
    _ => l.deviceTierUnknown,
  };

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final url = _url.text.trim();
    if (url != widget.settings.url) Telemetry.feature('server_switch');
    widget.settings.useServer(url);
    final code = _invite.text.trim();
    if (code.isNotEmpty) {
      setState(() {
        _saving = true;
        _inviteError = null;
      });
      try {
        await DeviceAuth(widget.settings).redeem(code);
        Telemetry.feature('invite');
      } on InviteRejected {
        Telemetry.errorShown('invite_wrong');
        setState(() => _inviteError = l.inviteWrong);
        return;
      } on Exception {
        Telemetry.errorShown('invite_unavailable');
        setState(() => _inviteError = l.inviteUnavailable);
        return;
      } finally {
        if (mounted) setState(() => _saving = false);
      }
    }
    navigator.pop();
  }

  Future<void> _checkServers() async {
    setState(() {
      for (final url in servers.values) {
        _health[url] = ServerHealth.checking;
      }
    });
    await Future.wait(
      servers.values.map((url) async {
        final result = await checkServer(url);
        if (mounted) setState(() => _health[url] = result);
      }),
    );
  }

  String _healthLabel(AppLocalizations l, ServerHealth? health) =>
      switch (health ?? ServerHealth.checking) {
        ServerHealth.checking => l.serverChecking,
        ServerHealth.ready => l.serverReady,
        ServerHealth.degraded => l.serverDegraded,
        ServerHealth.offline => l.serverOffline,
      };

  @override
  void dispose() {
    _url.dispose();
    _invite.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SegmentedButton<String>(
              emptySelectionAllowed: true,
              segments: [
                for (final server in servers.entries)
                  ButtonSegment(
                    value: server.value,
                    // Only a ready backend can be chosen; the current one stays.
                    enabled:
                        _health[server.value] == ServerHealth.ready ||
                        _url.text == server.value,
                    label: Text(
                      '${server.key}\n${_healthLabel(l, _health[server.value])}',
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
              selected: {if (servers.containsValue(_url.text)) _url.text},
              onSelectionChanged: (v) {
                if (v.isNotEmpty) setState(() => _url.text = v.first);
              },
            ),
            TextButton.icon(
              onPressed: _checkServers,
              icon: const Icon(Icons.refresh),
              label: Text(l.serverRecheck),
            ),
            TextField(
              controller: _url,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: l.serverUrl),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.deviceTier),
              subtitle: Text(_tierLabel(l)),
            ),
            if (_tier != DeviceTier.tester && _tier != DeviceTier.legacy)
              TextField(
                controller: _invite,
                decoration: InputDecoration(
                  labelText: l.inviteCode,
                  helperText: l.inviteHelp,
                  errorText: _inviteError,
                ),
              ),
            // Only a build with a statistics key has something to switch.
            if (Telemetry.isConfigured)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.statsToggle),
                subtitle: Text(l.statsToggleHelp),
                value: Telemetry.isEnabled,
                onChanged: (on) async {
                  await Telemetry.setEnabled(on);
                  if (mounted) setState(() {});
                },
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}
