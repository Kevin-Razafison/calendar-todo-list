class AppDimensions {
  AppDimension._();

  static const double woodBorderWidth   =  18.0;
  static const double woodCornerRadius  =  6.0;
  static const double woodInnerPadding  =  6.0;

  //Layout grille des mois
  static const int boardColumns         =  4;
  static const int boardRows            =  3;
  static const double mobthGao          =  6.0;


  //Mois central
  static const double mainMonthHeaderH  =  36.0;
  static const double mainMonthDayRowH  =  22.0;
  static const double mainMonthCellH    =  52.0;
  static const double mainMonthCellW    =  46.0;
  static const double mainDayNumberSize =  18.0;

  //Mois mini
  static const double miniMonthHeaderH  = 16.0;
  static const double miniMonthDayRowH  = 10.0;
  static const double miniMonthCellH    = 11.0;
  static const double miniMonthCellW    = 11.0;
  static const double miniDayNumberSize = 10.0;

  // ── Post-its ─────────────────────────────────────────────────────────────
  static const double stickyNoteW         = 42.0;  // largeur sur mini-mois
  static const double stickyNoteH         = 30.0;  // hauteur sur mini-mois
  static const double stickyNoteMainW     = 80.0;  // largeur sur mois central
  static const double stickyNoteMainH     = 55.0;  // hauteur sur mois central

  /// Décalage de chaque post-it supplémentaire sur un même jour
  /// → crée l'effet de chevauchement visible
  static const double stickyStackOffsetX  = 5.0;
  static const double stickyStackOffsetY  = 3.0;
  static const double stickyMaxStackShown = 3.0;   // max post-its visibles empilés

  static const double stickyCornerRadius  = 2.0;
  static const double stickyElevation     = 3.0;

  // ── Badge "compteur" de notes ────────────────────────────────────────────
  // Affiché quand il y a > maxStackShown notes sur un même jour
  static const double noteBadgeSize       = 14.0;
  static const double noteBadgeFontSize   = 8.0;

  // ── Dialog ajout/édition post-it ─────────────────────────────────────────
  static const double dialogWidth         = 280.0;
  static const double dialogPadding       = 20.0;
  static const double dialogRadius        = 4.0;
  static const double colorPickerSize     = 28.0;
  static const double colorPickerSpacing  = 10.0;
}
}
