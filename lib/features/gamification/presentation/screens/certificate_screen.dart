import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/preview_capture.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../learning_path/domain/learning_path.dart';
import '../../../learning_path/domain/learning_path_info.dart';
import '../../../profile/application/profile_controller.dart';
import '../../domain/french_date.dart';

/// The end-of-path certificate (US45): a designed widget captured as a
/// PNG (same `PreviewCapture` technique as EP07's project thumbnails, just
/// at full resolution) and shared via the native share sheet — no PDF
/// dependency needed for a document a learner mostly wants to show off.
class CertificateScreen extends ConsumerStatefulWidget {
  const CertificateScreen({super.key, required this.path});

  final LearningPath path;

  @override
  ConsumerState<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends ConsumerState<CertificateScreen> {
  final _captureKey = GlobalKey();
  bool _isSharing = false;
  final _completedOn = DateTime.now();

  Future<void> _share() async {
    setState(() => _isSharing = true);
    final base64Image = await PreviewCapture.captureBase64(_captureKey, pixelRatio: 2.5);
    if (!mounted) return;
    setState(() => _isSharing = false);
    final bytes = decodeThumbnail(base64Image);
    if (bytes == null) return;
    await SharePlus.instance.share(
      ShareParams(files: [XFile.fromData(bytes, mimeType: 'image/png', name: 'certificat.png')]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final info = learningPathInfo(widget.path);
    final pseudo = ref.watch(currentProfileProvider).valueOrNull?.pseudo ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.certificateTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: PreviewCapture(
                    boundaryKey: _captureKey,
                    child: _CertificateCard(pseudo: pseudo, pathTitle: info.title, emoji: info.emoji, date: _completedOn),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: l10n.certificateShare, isLoading: _isSharing, onPressed: _share),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.pseudo, required this.pathTitle, required this.emoji, required this.date});

  final String pseudo;
  final String pathTitle;
  final String emoji;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: 320,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.certificateHeading, style: AppTextStyles.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          Text(pseudo, style: AppTextStyles.headline, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.certificateBody(pathTitle), style: AppTextStyles.body, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.lg),
          Text(formatFrenchDate(date), style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
