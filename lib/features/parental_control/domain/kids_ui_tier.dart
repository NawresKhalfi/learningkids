import '../../onboarding/domain/age_range.dart';

/// US11 ("Kids UI" adapted to age): the youngest bracket gets simplified,
/// icon-forward wording; everyone else keeps the standard copy. Widgets
/// consult this instead of the raw [AgeRange] so the age→tier mapping
/// lives in one testable place as more screens grow tier-specific variants.
enum KidsUiTier { young, standard }

KidsUiTier resolveKidsUiTier(AgeRange ageRange) {
  return ageRange == AgeRange.fourToSix ? KidsUiTier.young : KidsUiTier.standard;
}
