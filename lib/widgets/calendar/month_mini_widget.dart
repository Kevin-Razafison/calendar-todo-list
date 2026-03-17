import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/month_data.dart';
import '../../models/sticky_note.dart'; // ← import manquant
import 'month_header.dart';
import 'day_cell.dart';

class MonthMiniWidget extends StatelessWidget {
  final MonthData month;
  final bool isCurrent;
  final void Function(DateTime date)? onDayTap;
  final void Function(StickyNote note)? onNoteTap;

  const MonthMiniWidget({
    super.key,
    required this.month,
    this.isCurrent = false,
    this.onDayTap,
    this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: isCurrent
          ? BoxDecoration(
              border: Border.all(
                color: AppColors.todayAccent.withValues(alpha: 0.4),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            month.monthName,
            style: AppTextStyles.monthMiniTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 1),
          const MonthHeader(isMain: false),
          const SizedBox(height: 1),
          Expanded(
            child: _MiniGrid(
              month: month,
              today: now,
              onDayTap: onDayTap,
              onNoteTap: onNoteTap, // ← passé ici
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniGrid extends StatelessWidget {
  final MonthData month;
  final DateTime today;
  final void Function(DateTime)? onDayTap;
  final void Function(StickyNote)? onNoteTap; // ← ajouté

  const _MiniGrid({
    required this.month,
    required this.today,
    this.onDayTap,
    this.onNoteTap, // ← ajouté
  });

  @override
  Widget build(BuildContext context) {
    final grid = month.weeksGrid;

    return Column(
      children: grid.map((week) {
        return Expanded(
          child: Row(
            children: List.generate(7, (dowIndex) {
              final day = week[dowIndex];
              if (day == null) return const Expanded(child: SizedBox());

              final date = DateTime(month.year, month.month, day);
              final isToday =
                  date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;

              return Expanded(
                child: DayCell(
                  day: day,
                  isToday: isToday,
                  isSunday: dowIndex == 0,
                  isMain: false,
                  notes: month.notesForDay(day),
                  events: month.eventsForDay(day),
                  onTap: onDayTap != null ? () => onDayTap!(date) : null,
                  onNoteTap: onNoteTap, // ← passé ici
                ),
              );
            }),
          ),
        );
      }).toList(),
    );
  }
}
