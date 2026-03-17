import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/month_data.dart';

class BoardLayout extends StatelessWidget {
  final List<MonthData> months;
  final int currentMonthIndex;
  final Widget Function(MonthData month, bool isCurrent) miniMonthBuilder;
  final Widget Function(MonthData month) mainMonthBuilder;
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
        const quickBarHeight = 90.0;
        const quickBarMargin = 8.0;

        final availableH =
            constraints.maxHeight - quickBarHeight - quickBarMargin;
        final availableW = constraints.maxWidth;

        final cellW = (availableW - gap * 3) / 4;
        final cellH = (availableH - gap * 3) / 4;

        return Listener(
          onPointerDown: (event) {
            print('🪵 BoardLayout pointer down');
          },
          child: Column(
            children: [
              SizedBox(
                width: availableW,
                height: availableH,
                child: Listener(
                  onPointerDown: (event) {
                    print('📦 Stack pointer down');
                  },
                  child: Stack(
                    children: [
                      // ── Row 0 : JAN FEB MAR APR ─────────────────────────
                      _positioned(
                        0,
                        0,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[0]),
                      ),
                      _positioned(
                        1,
                        0,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[1]),
                      ),
                      _positioned(
                        2,
                        0,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[2]),
                      ),
                      _positioned(
                        3,
                        0,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[3]),
                      ),

                      // ── Col 0 : DEC NOV ──────────────────────────────────
                      _positioned(
                        0,
                        1,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[11]),
                      ),
                      _positioned(
                        0,
                        2,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[10]),
                      ),

                      // ── Col 3 : MAY JUN ──────────────────────────────────
                      _positioned(
                        3,
                        1,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[4]),
                      ),
                      _positioned(
                        3,
                        2,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[5]),
                      ),

                      // ── Row 3 : OCT SEP AUG JUL ─────────────────────────
                      _positioned(
                        0,
                        3,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[9]),
                      ),
                      _positioned(
                        1,
                        3,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[8]),
                      ),
                      _positioned(
                        2,
                        3,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[7]),
                      ),
                      _positioned(
                        3,
                        3,
                        cellW,
                        cellH,
                        gap,
                        _miniCell(months[6]),
                      ),

                      // ── Mois central 2×2 ─────────────────────────────────
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
              ),

              SizedBox(height: quickBarMargin),

              SizedBox(height: quickBarHeight, child: quickNotesBar),
            ],
          ),
        );
      },
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _miniCell(MonthData month) {
    final isCurrent = month.month - 1 == currentMonthIndex;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.boardWhite,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: miniMonthBuilder(month, isCurrent),
    );
  }

  Widget _positioned(
    int col,
    int row,
    double cellW,
    double cellH,
    double gap,
    Widget child,
  ) {
    return Positioned(
      left: col * (cellW + gap),
      top: row * (cellH + gap),
      width: cellW,
      height: cellH,
      child: child,
    );
  }
}

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
          color: AppColors.woodMedium.withValues(alpha: 0.7),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
