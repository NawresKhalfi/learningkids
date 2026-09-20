import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// A mascot speech bubble with a bold outline and a tail pointing down
/// towards the mascot, used in the onboarding chat screens.
class SpeechBubble extends StatelessWidget {
  const SpeechBubble({
    super.key,
    required this.message,
    this.color = AppColors.accentYellow,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(color: color),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Text(
          message,
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const radius = AppRadii.card;
    const tailSize = 14.0;
    final bodyHeight = size.height - tailSize;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, bodyHeight),
          const Radius.circular(radius),
        ),
      );

    final tailPath = Path()
      ..moveTo(size.width * 0.28, bodyHeight - 1)
      ..lineTo(size.width * 0.28 + tailSize, bodyHeight - 1)
      ..lineTo(size.width * 0.28 + tailSize * 0.3, bodyHeight + tailSize)
      ..close();

    final fillPaint = Paint()..color = color;
    final strokePaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(tailPath, fillPaint);
    canvas.drawPath(path, strokePaint);
    canvas.drawPath(tailPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) =>
      oldDelegate.color != color;
}
