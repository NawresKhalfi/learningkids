import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// A rounded, softly-shadowed input field matching the app's forms.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.autofocus = false,
    this.onSubmitted,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? errorText;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.field),
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.ink,
              width: hasError ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.12),
                offset: const Offset(0, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofocus: autofocus,
            onSubmitted: onSubmitted,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.inkMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs, left: AppSpacing.xs),
            child: Text(
              errorText!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}
