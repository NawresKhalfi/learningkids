import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../data/tts_service.dart';

/// US66's "lecture vocale" — reads [text] aloud in French on tap and turns
/// into a stop button while speaking.
class ReadAloudButton extends ConsumerStatefulWidget {
  const ReadAloudButton({super.key, required this.text});

  final String text;

  @override
  ConsumerState<ReadAloudButton> createState() => _ReadAloudButtonState();
}

class _ReadAloudButtonState extends ConsumerState<ReadAloudButton> {
  bool _isSpeaking = false;
  TtsService? _tts;

  @override
  void dispose() {
    if (_isSpeaking) _tts?.stop();
    super.dispose();
  }

  Future<void> _toggle() async {
    final tts = ref.read(ttsServiceProvider);
    _tts = tts;
    if (_isSpeaking) {
      await tts.stop();
      if (mounted) setState(() => _isSpeaking = false);
      return;
    }
    await tts.setLanguage('fr-FR');
    setState(() => _isSpeaking = true);
    await tts.speak(
      widget.text,
      onComplete: () {
        if (mounted) setState(() => _isSpeaking = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: _isSpeaking
          ? l10n.accessibilityReadAloudStop
          : l10n.accessibilityReadAloudStart,
      icon: Icon(
        _isSpeaking ? Icons.stop_circle_outlined : Icons.volume_up_outlined,
        color: AppColors.ink,
      ),
      onPressed: _toggle,
    );
  }
}
