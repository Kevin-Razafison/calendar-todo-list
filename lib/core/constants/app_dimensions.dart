/// Toutes les dimensions de l'application.
/// Principe : on raisonne en proportions du board,
/// puis on calcule les tailles réelles dans les widgets.
class AppDimensions {
  AppDimensions._();

  // ── Cadre bois ───────────────────────────────────────────────────────────
  static const double woodBorderWidth = 14.0; // épaisseur du cadre
  static const double woodCornerRadius = 6.0; // arrondi des coins
  static const double woodInnerPadding = 3.0; // espace entre bois et grille

  // ── Layout grille des mois ───────────────────────────────────────────────
  // Le board est divisé en 4 colonnes × 3 lignes de mini-mois
  // + 1 mois central qui occupe 2×2 au centre
  static const int boardColumns = 4;
  static const int boardRows = 3;
  static const double monthGap = 8.0; // espace entre les mois

  // ── Mois central ─────────────────────────────────────────────────────────
  static const double mainMonthHeaderH = 36.0; // hauteur ligne "MARCH 2026"
  static const double mainMonthDayRowH = 22.0; // hauteur ligne S M T W T F S
  static const double mainMonthCellH = 52.0; // hauteur d'une cellule jour
  static const double mainMonthCellW = 46.0; // largeur d'une cellule jour
  static const double mainDayNumberSize = 18.0; // cercle "aujourd'hui"

  // ── Mois mini ────────────────────────────────────────────────────────────
  static const double miniMonthHeaderH = 16.0;
  static const double miniMonthDayRowH = 10.0;
  static const double miniMonthCellH = 11.0;
  static const double miniMonthCellW = 11.0;
  static const double miniDayNumberSize = 10.0;

  // ── Post-its ─────────────────────────────────────────────────────────────
  static const double stickyNoteW = 22.0; // ← mini-mois plus petit
  static const double stickyNoteH = 16.0;
  static const double stickyNoteMainW = 62.0;
  static const double stickyNoteMainH = 35.0;

  /// Décalage de chaque post-it supplémentaire sur un même jour
  /// → crée l'effet de chevauchement visible
  static const double stickyStackOffsetX = 3.0;
  static const double stickyStackOffsetY = 2.0;
  static const double stickyMaxStackShown =
      3.0; // max post-its visibles empilés

  static const double stickyCornerRadius = 2.0;
  static const double stickyElevation = 3.0;

  // ── Badge "compteur" de notes ────────────────────────────────────────────
  // Affiché quand il y a > maxStackShown notes sur un même jour
  static const double noteBadgeSize = 14.0;
  static const double noteBadgeFontSize = 8.0;

  // ── Dialog ajout/édition post-it ─────────────────────────────────────────
  static const double dialogWidth = 280.0;
  static const double dialogPadding = 20.0;
  static const double dialogRadius = 4.0;
  static const double colorPickerSize = 28.0;
  static const double colorPickerSpacing = 10.0;
}
