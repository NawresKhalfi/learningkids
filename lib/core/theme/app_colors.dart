import 'package:flutter/widgets.dart';

/// Colour tokens for the LearningKids "playful premium" identity: a warm
/// cream canvas, a deep-navy ink used for text/outlines/shadows, and a set
/// of saturated pastel accents used for cards, badges and illustrations.
///
/// Widgets should reference these tokens (or the [ColorScheme] built from
/// them in `app_theme.dart`) rather than hard-coding hex values.
abstract final class AppColors {
  // Canvas & ink.
  static const background = Color(0xFFFBF1E2);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF241F47);
  static const inkMuted = Color(0xFF6E6580);

  // Brand accents.
  static const brandPurple = Color(0xFF7C4DE8);
  static const brandPurpleDark = Color(0xFF5A34B0);
  static const brandBlue = Color(0xFF4C5FD9);
  static const brandBlueDark = Color(0xFF37419E);
  static const accentYellow = Color(0xFFF6C445);
  static const accentYellowDark = Color(0xFFD9A521);

  // Semantic.
  static const success = Color(0xFF4CAF6D);
  static const successDark = Color(0xFF357E4C);
  static const error = Color(0xFFE15252);
  static const errorDark = Color(0xFFAD3A3A);

  /// Six pastel-vivid card themes used across category cards, avatars and
  /// onboarding chips, each with a matching darker tone for badges/pills.
  static const cardPurple = CardPalette(
    surface: Color(0xFFCBA9F7),
    on: Color(0xFF7C4FBE),
  );
  static const cardBlue = CardPalette(
    surface: Color(0xFFA6DEEF),
    on: Color(0xFF4C93AE),
  );
  static const cardGreen = CardPalette(
    surface: Color(0xFFACE5B8),
    on: Color(0xFF4F9F63),
  );
  static const cardYellow = CardPalette(
    surface: Color(0xFFF3E08A),
    on: Color(0xFFB99A2E),
  );
  static const cardOrange = CardPalette(
    surface: Color(0xFFF3C696),
    on: Color(0xFFC17F3C),
  );
  static const cardPink = CardPalette(
    surface: Color(0xFFF4AFC7),
    on: Color(0xFFC15A81),
  );

  static const cardPalettes = [
    cardPurple,
    cardBlue,
    cardGreen,
    cardYellow,
    cardOrange,
    cardPink,
  ];
}

/// A pastel/darker colour pair used to theme a single card-like surface.
class CardPalette {
  const CardPalette({required this.surface, required this.on});

  final Color surface;
  final Color on;
}
