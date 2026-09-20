enum CodingLevel { beginner, someBasics, comfortable }

/// A short, badge-friendly label — the onboarding screen instead uses full
/// question-style sentences (see `app_fr.arb`'s `onboardingLevel*` keys),
/// which are too long for a filter chip or a project card (EP07/US38).
String codingLevelShortLabel(CodingLevel level) {
  switch (level) {
    case CodingLevel.beginner:
      return 'Débutant';
    case CodingLevel.someBasics:
      return 'Bases acquises';
    case CodingLevel.comfortable:
      return 'À l\'aise';
  }
}
