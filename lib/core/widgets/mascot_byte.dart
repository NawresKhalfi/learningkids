import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// "Byte", the app's coding-buddy mascot: a small rounded robot built from
/// simple shapes (no image asset yet) so it stays crisp at any size and is
/// cheap to theme/re-colour.
class MascotByte extends StatelessWidget {
  const MascotByte({super.key, this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.15,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Antenna.
          Positioned(
            top: 0,
            child: Container(
              width: size * 0.06,
              height: size * 0.18,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(size),
              ),
            ),
          ),
          Positioned(
            top: -size * 0.06,
            child: Container(
              width: size * 0.16,
              height: size * 0.16,
              decoration: BoxDecoration(
                color: AppColors.accentYellow,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.ink, width: 2.5),
              ),
            ),
          ),
          // Body.
          Positioned(
            top: size * 0.16,
            child: Container(
              width: size,
              height: size * 0.9,
              decoration: BoxDecoration(
                color: AppColors.brandPurple,
                borderRadius: BorderRadius.circular(size * 0.32),
                border: Border.all(color: AppColors.ink, width: 3),
              ),
              padding: EdgeInsets.all(size * 0.1),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(size * 0.22),
                  border: Border.all(color: AppColors.ink, width: 2.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Eye(size: size * 0.14),
                    _Eye(size: size * 0.14),
                  ],
                ),
              ),
            ),
          ),
          // Arms.
          Positioned(
            top: size * 0.55,
            left: -size * 0.04,
            child: _Arm(size: size),
          ),
          Positioned(
            top: size * 0.55,
            right: -size * 0.04,
            child: Transform.flip(flipX: true, child: _Arm(size: size)),
          ),
        ],
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.ink,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: size * 0.35,
        height: size * 0.35,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Arm extends StatelessWidget {
  const _Arm({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 0.16,
      height: size * 0.34,
      decoration: BoxDecoration(
        color: AppColors.brandPurple,
        borderRadius: BorderRadius.circular(size * 0.1),
        border: Border.all(color: AppColors.ink, width: 2.5),
      ),
    );
  }
}
