import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single 4-digit PIN field, styled like [AppTextField] but numeric-only
/// and centered — used for every Espace Parent PIN step (create, confirm,
/// enter).
class PinInput extends StatelessWidget {
  const PinInput({
    super.key,
    required this.controller,
    this.hintText,
    this.errorText,
    this.autofocus = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? errorText;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.field),
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.ink,
              width: hasError ? 2 : 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            autofocus: autofocus,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            obscureText: true,
            textAlign: TextAlign.center,
            style: AppTextStyles.headline.copyWith(letterSpacing: 12),
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.inkMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorText!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}
