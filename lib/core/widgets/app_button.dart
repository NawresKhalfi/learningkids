import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, danger }

/// A rounded button with a solid offset "ink" shadow that appears to press
/// down when tapped, matching the reference screens' CTA style.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  (Color fill, Color textColor) get _colors {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return (AppColors.accentYellow, AppColors.ink);
      case AppButtonVariant.secondary:
        return (AppColors.brandBlue, AppColors.surface);
      case AppButtonVariant.outline:
        return (AppColors.surface, AppColors.ink);
      case AppButtonVariant.danger:
        return (AppColors.error, AppColors.surface);
    }
  }

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final (fill, textColor) = _colors;
    final offset = _isPressed ? 1.0 : AppShadowOffsets.button;

    return Opacity(
      opacity: _isDisabled ? 0.6 : 1,
      child: GestureDetector(
        onTapDown: _isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: _isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          width: widget.expand ? double.infinity : null,
          padding: EdgeInsets.only(bottom: AppShadowOffsets.button - offset),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: AppShadowOffsets.button,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(AppRadii.button),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 90),
                margin: EdgeInsets.only(top: AppShadowOffsets.button - offset),
                height: 52,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(AppRadii.button),
                  border: widget.variant == AppButtonVariant.outline
                      ? Border.all(color: AppColors.ink, width: 2)
                      : null,
                ),
                alignment: Alignment.center,
                child: widget.isLoading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: textColor,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              widget.icon!,
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            Flexible(
                              child: Text(
                                widget.label,
                                style: AppTextStyles.button.copyWith(color: textColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
