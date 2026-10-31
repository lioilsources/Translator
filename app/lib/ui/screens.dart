import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_app/ui/conversation_view.dart';
import 'package:translator_app/ui/languages.dart';
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
    if (!await mic.hasPermission()) {
      messenger.showSnackBar(SnackBar(content: Text(l.micDenied)));
      return;
    }
    await navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => LiveConversationScreen(settings: s, mic: mic),
      ),
    );
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HistoryScreen()),
            ),
          ),
          IconButton(
            tooltip: l.settings,
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
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
            const SizedBox(height: 12),
            _LangCard(
              label: l.colleague,
              language: languageOf(s.langB),
              onTap: () => _pick(isA: false),
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
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
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
    super.key,
  });

  final Settings settings;
  final MicCapture mic;

  @override
  State<LiveConversationScreen> createState() => _LiveConversationScreenState();
}

class _LiveConversationScreenState extends State<LiveConversationScreen> {
  late final ConversationController _c;
  final _store = FileTranscriptStore();

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
        if (mounted) setState(() {});
      },
    );
    _c.start(deviceId: s.deviceId, langA: s.langA, langB: s.langB);
    unawaited(WakelockPlus.enable());
    unawaited(widget.mic.start(_c.onMicFrame));
  }

  Future<void> _end() async {
    final navigator = Navigator.of(context);
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
                  onTap: () => unawaited(
                    SharePlus.instance.share(ShareParams(text: t.exportText())),
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

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({required this.settings, super.key});
  final Settings settings;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final _url = TextEditingController(text: widget.settings.url);
  late final _token = TextEditingController(text: widget.settings.token);

  @override
  void dispose() {
    _url.dispose();
    _token.dispose();
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
            TextField(
              controller: _url,
              decoration: InputDecoration(labelText: l.serverUrl),
            ),
            TextField(
              controller: _token,
              obscureText: true,
              decoration: InputDecoration(labelText: l.serverToken),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                widget.settings
                  ..url = _url.text.trim()
                  ..token = _token.text.trim();
                Navigator.pop(context);
              },
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
  }
}
