import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

/// A dark, monospace code sample block, used for the code examples inside
/// a lesson section.
class CodeBlock extends StatelessWidget {
  const CodeBlock({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          color: AppColors.surface,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }
}
