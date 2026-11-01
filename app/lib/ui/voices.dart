import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:translator_app/core/platform.dart';
import 'package:translator_app/l10n/app_localizations.dart';

const _recordingSeconds = 30;

/// The user's recorded voices: add, delete, and open the recorder.
class VoiceLibraryScreen extends StatefulWidget {
  const VoiceLibraryScreen({required this.settings, super.key});
  final Settings settings;

  @override
  State<VoiceLibraryScreen> createState() => _VoiceLibraryScreenState();
}

class _VoiceLibraryScreenState extends State<VoiceLibraryScreen> {
  late final _library = VoiceLibrary(widget.settings);
  late Future<List<Voice>> _voices = _library.list();

  void _reload() => setState(() => _voices = _library.list());

  Future<void> _delete(Voice voice) async {
    final l = AppLocalizations.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.voiceDeleteTitle(voice.name)),
        content: Text(l.voiceDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (sure != true) return;
    await _library.delete(voice.id);
    widget.settings.forgetVoice(voice.id);
    _reload();
  }

  Future<void> _add() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RecordVoiceScreen(library: _library),
      ),
    );
    if (added ?? false) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.voiceLibrary)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.mic),
        label: Text(l.voiceAdd),
      ),
      body: FutureBuilder<List<Voice>>(
        future: _voices,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text(l.voiceServerError));
          final voices = snapshot.data;
          if (voices == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (voices.isEmpty) return Center(child: Text(l.voiceEmpty));
          return ListView(
            children: [
              for (final voice in voices)
                ListTile(
                  leading: const Icon(Icons.record_voice_over),
                  title: Text(voice.name),
                  trailing: IconButton(
                    tooltip: l.delete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _delete(voice),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Records a sample. Consent comes first: the button stays off without it.
class RecordVoiceScreen extends StatefulWidget {
  const RecordVoiceScreen({required this.library, super.key});
  final VoiceLibrary library;

  @override
  State<RecordVoiceScreen> createState() => _RecordVoiceScreenState();
}

class _RecordVoiceScreenState extends State<RecordVoiceScreen> {
  final _name = TextEditingController();
  final _pcm = BytesBuilder(copy: false);
  MicCapture? _mic;
  Timer? _timer;
  var _left = _recordingSeconds;
  var _consent = false;
  var _uploading = false;
  String? _error;

  bool get _recording => _mic != null;

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_mic?.stop());
    _name.dispose();
    super.dispose();
  }

  Future<void> _record() async {
    final l = AppLocalizations.of(context);
    final mic = MicCapture();
    if (!await mic.hasPermission()) {
      setState(() => _error = l.micDenied);
      return;
    }
    _pcm.clear();
    await mic.start(_pcm.add);
    setState(() {
      _mic = mic;
      _left = _recordingSeconds;
      _error = null;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _left--);
      if (_left <= 0) {
        timer.cancel();
        unawaited(_finish());
      }
    });
  }

  Future<void> _finish() async {
    final l = AppLocalizations.of(context);
    final navigator = Navigator.of(context);
    final mic = _mic;
    setState(() {
      _mic = null;
      _uploading = true;
    });
    await mic?.stop();
    try {
      await widget.library.create(_name.text.trim(), _pcm.takeBytes());
      navigator.pop(true);
    } on Exception {
      if (mounted) {
        setState(() {
          _uploading = false;
          _error = l.voiceServerError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ready = _consent && _name.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(title: Text(l.voiceAdd)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _name,
              maxLength: 40,
              enabled: !_recording && !_uploading,
              decoration: InputDecoration(labelText: l.voiceName),
              onChanged: (_) => setState(() {}),
            ),
            CheckboxListTile(
              value: _consent,
              contentPadding: EdgeInsets.zero,
              title: Text(l.voiceConsent),
              onChanged: _recording || _uploading
                  ? null
                  : (v) => setState(() => _consent = v ?? false),
            ),
            const SizedBox(height: 12),
            Text(l.voiceReadThis),
            const SizedBox(height: 8),
            Text(
              l.voiceSampleText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            if (_error != null) Text(_error!),
            if (_uploading)
              const Center(child: CircularProgressIndicator())
            else
              FilledButton.icon(
                onPressed: !ready || _recording ? null : _record,
                icon: const Icon(Icons.mic),
                label: Text(
                  _recording ? l.voiceRecording(_left) : l.voiceRecord,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Chooses who speaks with which voice, before the conversation starts.
class VoicePicker extends StatelessWidget {
  const VoicePicker({
    required this.voices,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<Voice> voices;
  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DropdownButton<String?>(
      isExpanded: true,
      value: voices.any((v) => v.wireName == selected) ? selected : null,
      items: [
        DropdownMenuItem(child: Text(l.voiceDefault)),
        for (final voice in voices)
          DropdownMenuItem(value: voice.wireName, child: Text(voice.name)),
      ],
      onChanged: onChanged,
    );
  }
}
