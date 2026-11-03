import 'package:flutter/material.dart';
import 'package:translator_app/l10n/app_localizations.dart';
import 'package:translator_core/translator_core.dart';

const sideColors = {Side.a: Color(0xFF2E7D6B), Side.b: Color(0xFFC2571A)};

/// The split table screen: top half rotated 180° for the person opposite.
class ConversationView extends StatelessWidget {
  const ConversationView({
    required this.controller,
    required this.onEnd,
    super.key,
  });

  final ConversationController controller;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RotatedBox(
                key: const Key('half-b'),
                quarterTurns: 2,
                child: _Half(side: Side.b, controller: controller),
              ),
            ),
            _Controls(controller: controller, onEnd: onEnd),
            Expanded(
              child: _Half(
                key: const Key('half-a'),
                side: Side.a,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Half extends StatelessWidget {
  const _Half({required this.side, required this.controller, super.key});

  final Side side;
  final ConversationController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.state;
    final l = AppLocalizations.of(context);
    final active = state.activeSide == side;
    final color = sideColors[side]!;
    final entries = state.transcript.entries.reversed
        .where((e) => e.original.isNotEmpty)
        .toList();
    final waiting = controller.micOpen ? _prompt(l) : '';

    return Listener(
      onPointerDown: (_) => controller.holdStart(side),
      onPointerUp: (_) => controller.holdEnd(),
      onPointerCancel: (_) => controller.holdEnd(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: controller.mode == Mode.ptt
            ? null
            : () => controller.force(side),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: active ? 10 + controller.level.clamp(0, 0.3) * 60 : 4,
              color: active ? color : color.withValues(alpha: 0.2),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.partial.isNotEmpty && active)
                      Text(
                        state.partial,
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    Expanded(
                      child: entries.isEmpty
                          ? Center(
                              child: Text(
                                waiting,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: entries.length,
                              itemBuilder: (context, i) => _Line(
                                entry: entries[i],
                                side: side,
                                latest: i == 0,
                                onItWasMe: () => controller.force(side),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _prompt(AppLocalizations l) =>
      controller.mode == Mode.ptt ? l.promptPtt : l.promptAuto;
}

class _Line extends StatelessWidget {
  const _Line({
    required this.entry,
    required this.side,
    required this.latest,
    required this.onItWasMe,
  });

  final TranscriptEntry entry;
  final Side side;
  final bool latest;
  final VoidCallback onItWasMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = entry.side == side;
    // Each half leads with text in its reader's language.
    final big = entry.uncertain || mine ? entry.original : entry.translation;
    final small = entry.uncertain
        ? ''
        : (mine ? entry.translation : entry.original);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (small.isNotEmpty)
            Text(
              small,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
          if (big.isNotEmpty)
            Text(
              big,
              style: latest
                  ? theme.textTheme.headlineMedium
                  : theme.textTheme.titleLarge,
            ),
          if (entry.uncertain)
            TextButton(
              onPressed: onItWasMe,
              child: Text(AppLocalizations.of(context).itWasMe),
            ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.controller, required this.onEnd});

  final ConversationController controller;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = controller.state;
    final error = _errorText(l, state.lastError);
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Row(
              children: [
                IconButton(
                  tooltip: controller.paused ? l.resume : l.pause,
                  icon: Icon(
                    controller.paused ? Icons.play_arrow : Icons.pause,
                  ),
                  onPressed: () =>
                      controller.setPaused(paused: !controller.paused),
                ),
                IconButton(
                  tooltip: controller.ttsEnabled ? l.soundOn : l.soundOff,
                  icon: Icon(
                    controller.ttsEnabled ? Icons.volume_up : Icons.subtitles,
                  ),
                  onPressed: () =>
                      controller.setTts(enabled: !controller.ttsEnabled),
                ),
                Expanded(
                  child: Text(
                    _status(l, state.phase),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: l.endConversation,
                  icon: const Icon(Icons.call_end),
                  onPressed: onEnd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _status(AppLocalizations l, Phase p) => switch (p) {
    Phase.connecting => l.statusConnecting,
    Phase.listening => l.statusListening,
    Phase.recording => l.statusRecording,
    Phase.translating => l.statusTranslating,
    Phase.speaking => l.statusSpeaking,
    Phase.paused => l.statusPaused,
  };

  String? _errorText(AppLocalizations l, String? code) => switch (code) {
    null => null,
    'connection_lost' => l.errorConnection,
    'asr_unavailable' || 'mt_unavailable' => l.errorBackend,
    'tts_unavailable' || 'playback_failed' => l.errorVoice,
    'busy' => l.errorBusy,
    'quota' => l.errorQuota,
    'too_long' => l.errorTooLong,
    _ => l.errorGeneric,
  };
}
