import '../../../core/theme/app_colors.dart';

/// A preset avatar: an emoji on one of the six card palettes. There is no
/// image upload pipeline yet, so profile customization (US04) picks from
/// this fixed set instead.
enum Avatar {
  fox('🦊', AppColors.cardOrange),
  cat('🐱', AppColors.cardPink),
  owl('🦉', AppColors.cardPurple),
  frog('🐸', AppColors.cardGreen),
  panda('🐼', AppColors.cardBlue),
  lion('🦁', AppColors.cardYellow);

  const Avatar(this.emoji, this.palette);

  final String emoji;
  final CardPalette palette;

  static Avatar fromId(String? id) => Avatar.values.firstWhere(
    (avatar) => avatar.name == id,
    orElse: () => Avatar.fox,
  );
}
