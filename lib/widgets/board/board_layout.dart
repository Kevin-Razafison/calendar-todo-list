import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/month_data.dart';

/// Disposition des 12 mois + quick notes bar autour du mois central.
///
/// Layout réel (inspiré de la photo) :
///
///  ┌──────┬──────┬──────┬──────┐
///  │ JAN  │ FEB  │ MAR  │ APR  │  ← row 0
///  ├──────┼──────┴──────┼──────┤
///  │ DEC  │  MARCH 2026 │ MAY  │  ← row 1 (mois central 2×2)
///  ├──────┤  (central)  ├──────┤
///  │ NOV  │             │ JUN  │  ← row 2
///  ├──────┼──────┬──────┼──────┤
///  │ OCT  │ SEP  │ AUG  │ JUL  │  ← row 3
///  └──────┴──────┴──────┴──────┘
///  ═══════ QUICK NOTES BAR ════════  ← row 4
///
class BoardLayout extends StatelessWidget {
  /// Les 12 mois triés par index 0=Janvier … 11=Décembre
  final List<MonthData> months;

  /// Mois actuellement affiché en grand (central)
  final int currentMonthIndex; // 0–11

  /// Builder pour un mini-mois périphérique
  final Widget Function(MonthData month, bool isCurrent) miniMonthBuilder;

  /// Builder pour le grand mois central
  final Widget Function(MonthData month) mainMonthBuilder;

  /// Widget de la barre de quick notes en bas
  final Widget quickNotesBar;

  const BoardLayout({
    super.key,
    required this.months,
    required this.currentMonthIndex,
    required this.miniMonthBuilder,
    required this.mainMonthBuilder,
    required this.quickNotesBar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppDimensions.monthGap;

        // Hauteur réservée à la quick notes bar
        const quickBarHeight = 90.0;
        const quickBarMargin = 6.0;

        final availableH = constraints.maxHeight - quickBarHeight - quickBarMargin;
        final availableW = constraints.maxWidth;

        // Chaque cellule mini = 1/4 de la largeur
        final cellW = (availableW - gap * 3) / 4;
        // 4 lignes de mini-mois → la centrale occupe 2 lignes
        final cellH = (availableH - gap * 3) / 4;

        return Column(
          children: [
            // ── Grille des mois ──────────────────────────────────────────
            SizedBox(
              width: availableW,
              height: availableH,
              child: Stack(
                children: [
                  // ── Séparateurs de grille (lignes ivoire) ──────────────
                  ..._buildGridLines(availableW, availableH, cellW, cellH, gap),

                  // ── Row 0 : JAN FEB MAR APR ───────────────────────────
                  _positioned(0, 0, cellW, cellH, gap,
                      _miniCell(months[0], cellW, cellH)),
                  _positioned(1, 0, cellW, cellH, gap,
                      _miniCell(months[1], cellW, cellH)),
                  _positioned(2, 0, cellW, cellH, gap,
                      _miniCell(months[2], cellW, cellH)),
                  _positioned(3, 0, cellW, cellH, gap,
                      _miniCell(months[3], cellW, cellH)),

                  // ── Col 0 : DEC NOV ────────────────────────────────────
                  _positioned(0, 1, cellW, cellH, gap,
                      _miniCell(months[11], cellW, cellH)),
                  _positioned(0, 2, cellW, cellH, gap,
                      _miniCell(months[10], cellW, cellH)),

                  // ── Col 3 : MAY JUN ────────────────────────────────────
                  _positioned(3, 1, cellW, cellH, gap,
                      _miniCell(months[4], cellW, cellH)),
                  _positioned(3, 2, cellW, cellH, gap,
                      _miniCell(months[5], cellW, cellH)),

                  // ── Row 3 : OCT SEP AUG JUL ───────────────────────────
                  _positioned(0, 3, cellW, cellH, gap,
                      _miniCell(months[9], cellW, cellH)),
                  _positioned(1, 3, cellW, cellH, gap,
                      _miniCell(months[8], cellW, cellH)),
                  _positioned(2, 3, cellW, cellH, gap,
                      _miniCell(months[7], cellW, cellH)),
                  _positioned(3, 3, cellW, cellH, gap,
                      _miniCell(months[6], cellW, cellH)),

                  // ── Mois central (2×2) ─────────────────────────────────
                  Positioned(
                    left: cellW + gap,
                    top: cellH + gap,
                    width: cellW * 2 + gap,
                    height: cellH * 2 + gap,
                    child: _MainMonthCell(
                      child: mainMonthBuilder(months[currentMonthIndex]),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: quickBarMargin),

            // ── Quick Notes Bar ──────────────────────────────────────────
            SizedBox(
              height: quickBarHeight,
              child: quickNotesBar,
            ),
          ],
        );
      },
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Widget _miniCell(MonthData month, double w, double h) {
    final isCurrent = month.month - 1 == currentMonthIndex;
    return miniMonthBuilder(month, isCurrent);
  }

  /// Positionne un widget dans la grille (col, row)
  Widget _positioned(
    int col, int row, double cellW, double cellH, double gap, Widget child,
  ) {
    return Positioned(
      left: col * (cellW + gap),
      top: row * (cellH + gap),
      width: cellW,
      height: cellH,
      child: child,
    );
  }

  /// Lignes de séparation entre les cellules (effet tableau à cases)
  List<Widget> _buildGridLines(
    double w, double h, double cellW, double cellH, double gap,
  ) {
    final lines = <Widget>[];
    final paint = AppColors.boardGrid;

    // Lignes verticales
    for (int col = 1; col < 4; col++) {
      final x = col * (cellW + gap) - gap / 2;
      lines.add(Positioned(
        left: x,
        top: 0,
        child: Container(
          width: 1,
          height: h,
          color: paint.withOpacity(0.6),
        ),
      ));
    }

    // Lignes horizontales
    for (int row = 1; row < 4; row++) {
      final y = row * (cellH + gap) - gap / 2;
      lines.add(Positioned(
        top: y,
        left: 0,
        child: Container(
          width: w,
          height: 1,
          color: paint.withOpacity(0.6),
        ),
      ));
    }

    return lines;
  }
}

/// Conteneur du mois central avec ombre et bordure marquée
class _MainMonthCell extends StatelessWidget {
  final Widget child;
  const _MainMonthCell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.boardWhite,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: AppColors.woodMedium.withOpacity(0.7),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(2, 3),
          ),
          BoxShadow(
            color: AppColors.woodDark.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}



