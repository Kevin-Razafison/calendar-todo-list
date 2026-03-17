import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Bois (cadre & fond) ──────────────────────────────────────────────────
  static const Color woodDark = Color(0xFF3E1F00); // bords extérieurs
  static const Color woodMedium = Color(0xFF6B3A1F); // cadre principal
  static const Color woodLight = Color(0xFF8B5E3C); // reflets bois
  static const Color woodHighlight = Color(0xFFA0714F); // highlight grain
  static const Color woodShadow = Color(0xFF2A1200); // ombre profonde

  // ── Tableau blanc (fond des mois) ────────────────────────────────────────
  static const Color boardWhite = Color(0xFFF5F3EE); // mini-mois
  static const Color mainMonthBg = Color(
    0xFFF0E6D3,
  ); // ← beige plus chaud et visible// mois central — beige chaud
  static const Color boardGrid = Color(0xFFDDDAD3); // lignes de séparation
  static const Color boardShadow = Color(0x33000000); // ombre portée des mois

  // ── Post-its ─────────────────────────────────────────────────────────────
  static const Color stickyYellow = Color(0xFFFFF59D);
  static const Color stickyYellowDark = Color(0xFFF9A825); // bord/ombre
  static const Color stickyYellowShadow = Color(0x66C8A000);

  static const Color stickyGreen = Color(0xFFCCFF90);
  static const Color stickyGreenDark = Color(0xFF558B2F);
  static const Color stickyGreenShadow = Color(0x6633691E);

  static const Color stickyPink = Color(0xFFFFCDD2);
  static const Color stickyPinkDark = Color(0xFFC62828);
  static const Color stickyPinkShadow = Color(0x66880E4F);

  static const Color stickyBlue = Color(0xFFB3E5FC);
  static const Color stickyBlueDark = Color(0xFF0277BD);
  static const Color stickyBlueShadow = Color(0x6601579B);

  // ── Texte ────────────────────────────────────────────────────────────────
  static const Color textDark = Color(0xFF1A1008); // texte principal
  static const Color textMedium = Color(0xFF4A3728); // texte secondaire
  static const Color textLight = Color(0xFF8B7355); // texte désactivé
  static const Color textOnSticky = Color(0xFF2C1A00); // texte sur post-it
  static const Color textMonthTitle = Color(0xFF1A1008); // titre mois central

  // ── Jours spéciaux ───────────────────────────────────────────────────────
  static const Color sundayRed = Color(0xFFC62828); // dimanches en rouge
  static const Color todayAccent = Color(0xFF4A90D9); // cercle "aujourd'hui"
  static const Color todayFill = Color(0x1A4A90D9);

  // ── UI Général ───────────────────────────────────────────────────────────
  static const Color fabBackground = Color(0xFF6B3A1F); // bouton flottant
  static const Color fabIcon = Color(0xFFFFF59D);
  static const Color dialogOverlay = Color(0xAA1A0A00);
}
