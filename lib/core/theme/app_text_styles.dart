import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Text styles for the two type families of the design system:
/// - Baloo2 (rounded, bold) for headings, buttons and the comic-style brand
///   titles.
/// - Nunito for body copy, labels and captions.
abstract final class AppTextStyles {
  static const _baloo = 'Baloo2';
  static const _nunito = 'Nunito';

  /// Big rounded headline, e.g. screen titles ("Daily task").
  static const headline = TextStyle(
    fontFamily: _baloo,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.15,
    color: AppColors.ink,
  );

  /// Section / card title.
  static const title = TextStyle(
    fontFamily: _baloo,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.2,
    color: AppColors.ink,
  );

  /// Button label.
  static const button = TextStyle(
    fontFamily: _baloo,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.0,
    color: AppColors.ink,
  );

  static const body = TextStyle(
    fontFamily: _nunito,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.4,
    color: AppColors.ink,
  );

  static const bodyMuted = TextStyle(
    fontFamily: _nunito,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.4,
    color: AppColors.inkMuted,
  );

  static const caption = TextStyle(
    fontFamily: _nunito,
    fontWeight: FontWeight.w700,
    fontSize: 13,
    height: 1.3,
    color: AppColors.inkMuted,
  );

  static const badge = TextStyle(
    fontFamily: _nunito,
    fontWeight: FontWeight.w800,
    fontSize: 13,
    height: 1.0,
    color: AppColors.surface,
  );
}
