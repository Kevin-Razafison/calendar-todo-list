import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/month_data.dart';
import '../../models/sticky_note.dart';
import 'month_header.dart';
import 'day_cell.dart';

class MonthMainWidget extends StatelessWidget {
  final MonthData month;
  final void Function(DateTime date)? onDayTap;
  final void Function(StickyNote note)? onNoteTap;

  const MonthMainWidget({
    super.key,
    required this.month,
    this.onDayTap,
    this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Titre MARCH 2026 ───────────────────────────────────────────
        _MainTitle(month: month),

        // ── En-tête S M T W T F S ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            height: AppDimensions.mainMonthDayRowH,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.boardGrid, width: 1),
              ),
            ),
            child: const MonthHeader(isMain: true),
          ),
        ),

        // ── Grille des jours ───────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _MainGrid(
              month: month,
              onDayTap: onDayTap,
              onNoteTap: onNoteTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _MainTitle extends StatelessWidget {
  final MonthData month;
  const _MainTitle({required this.month});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.mainMonthHeaderH,
      decoration: BoxDecoration(
        color: AppColors.mainMonthBg,
        border: Border(
          bottom: BorderSide(color: AppColors.boardGrid, width: 1.5),
        ),
      ),
      child: Center(
        child: Text(
          '${month.monthName} ${month.year}',
          style: AppTextStyles.monthMainTitle,
        ),
      ),
    );
  }
}

class _MainGrid extends StatelessWidget {
  final MonthData month;
  final void Function(DateTime)? onDayTap;
  final void Function(StickyNote)? onNoteTap;

  const _MainGrid({required this.month, this.onDayTap, this.onNoteTap});

  @override
  Widget build(BuildContext context) {
    final grid = month.weeksGrid;
    final now = DateTime.now();

    return Column(
      children: grid.map((week) {
        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(7, (dowIndex) {
              final day = week[dowIndex];
              if (day == null) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.mainMonthBg.withValues(alpha: 0.6),
                        width: 0.5,
                      ),
                      color: AppColors.mainMonthBg.withValues(alpha: 0.6),
                    ),
                  ),
                );
              }

              final date = DateTime(month.year, month.month, day);
              final isToday =
                  date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;

              return Expanded(
                child: DayCell(
                  day: day,
                  isToday: isToday,
                  isSunday: dowIndex == 0,
                  isMain: true,
                  notes: month.notesForDay(day),
                  events: month.eventsForDay(day),
                  onTap: onDayTap != null ? () => onDayTap!(date) : null,
                  onNoteTap: onNoteTap,
                ),
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}
