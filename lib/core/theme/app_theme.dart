import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the app's [ThemeData]. Most screens use the custom widgets under
/// `lib/core/widgets/` directly, but this still sets sane, on-brand
/// defaults for the few stock Material widgets left in the tree (dialogs,
/// snackbars, scaffolds).
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.brandPurple,
    brightness: Brightness.light,
    primary: AppColors.brandPurple,
    secondary: AppColors.brandBlue,
    error: AppColors.error,
    surface: AppColors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      headlineMedium: AppTextStyles.headline,
      titleLarge: AppTextStyles.title,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      labelLarge: AppTextStyles.button,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      centerTitle: true,
      titleTextStyle: AppTextStyles.title,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      titleTextStyle: AppTextStyles.title,
      contentTextStyle: AppTextStyles.body,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.ink,
      contentTextStyle: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w700,
        color: AppColors.surface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.brandPurple,
    ),
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}
