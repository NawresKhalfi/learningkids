const _frenchMonths = [
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

/// A plain-French long date ("20 septembre 2026") for the certificate
/// (US45) — written by hand rather than via `intl`'s `DateFormat`, which
/// needs locale data initialized first for named months.
String formatFrenchDate(DateTime date) => '${date.day} ${_frenchMonths[date.month - 1]} ${date.year}';
