import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A big rounded title with a bold ink outline and a drop shadow, used for
/// brand moments (splash, auth headers) — the "SIGN UP" / "LOG IN" style
/// lettering from the reference screens.
class ComicTitle extends StatelessWidget {
  const ComicTitle(
    this.text, {
    super.key,
    this.fillColor = AppColors.accentYellow,
    this.fontSize = 40,
  });

  final String text;
  final Color fillColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontFamily: 'Baloo2',
      fontWeight: FontWeight.w800,
      fontSize: fontSize,
      height: 1.1,
      letterSpacing: 0.5,
    );

    return Stack(
      children: [
        // Drop shadow, offset behind the outline.
        Positioned(
          left: 3,
          top: 5,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: baseStyle.copyWith(color: AppColors.ink.withValues(alpha: 0.25)),
          ),
        ),
        // Ink outline.
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = fontSize / 9
              ..color = AppColors.ink,
          ),
        ),
        // Fill.
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(color: fillColor),
        ),
      ],
    );
  }
}
