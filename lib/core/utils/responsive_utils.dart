import 'package:flutter/material.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  /// Largeur de référence (tablet/desktop)
  static const double _baseWidth = 1226.0;

  /// Calcule un facteur d'échelle basé sur la largeur réelle de l'écran
  static double scaleFactor(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return (screenW / _baseWidth).clamp(0.35, 1.0);
  }

  /// Taille adaptée
  static double scale(BuildContext context, double baseSize) {
    return baseSize * scaleFactor(context);
  }

  // ── Tailles sticky notes ─────────────────────────────────────────────

  static double stickyMainW(BuildContext context) =>
      scale(context, 62.0).clamp(28.0, 62.0);

  static double stickyMainH(BuildContext context) =>
      scale(context, 32.0).clamp(14.0, 32.0);

  static double stickyMiniW(BuildContext context) =>
      scale(context, 24.0).clamp(10.0, 24.0);

  static double stickyMiniH(BuildContext context) =>
      scale(context, 16.0).clamp(7.0, 16.0);

  static double stickyOffsetX(BuildContext context) =>
      scale(context, 3.0).clamp(1.5, 3.0);

  static double stickyOffsetY(BuildContext context) =>
      scale(context, 2.0).clamp(1.0, 2.0);

  // ── Tailles texte ────────────────────────────────────────────────────

  static double fontMiniMonth(BuildContext context) =>
      scale(context, 8.0).clamp(5.0, 8.0);

  static double fontMainMonth(BuildContext context) =>
      scale(context, 13.0).clamp(8.0, 13.0);

  static double fontMonthTitle(BuildContext context) =>
      scale(context, 22.0).clamp(12.0, 22.0);

  static double fontDayHeader(BuildContext context) =>
      scale(context, 11.0).clamp(6.0, 11.0);

  // ── Espacement ───────────────────────────────────────────────────────

  static double monthGap(BuildContext context) =>
      scale(context, 8.0).clamp(3.0, 8.0);

  static double woodBorder(BuildContext context) =>
      scale(context, 14.0).clamp(6.0, 14.0);
}
