import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/sticky_note.dart';
import '../../models/calendar_event.dart';
import '../notes/sticky_note_widget.dart';

class DayCell extends StatelessWidget {
  final int? day;             // null = cellule vide
  final bool isToday;
  final bool isSunday;
  final bool isMain;          // true = mois central
  final List<StickyNote> notes;
  final List<CalendarEvent> events;
  final VoidCallback? onTap;
  final void Function(StickyNote note)? onNoteTap;

  const DayCell({
    super.key,
    required this.day,
    this.isToday = false,
    this.isSunday = false,
    required this.isMain,
    this.notes = const [],
    this.events = const [],
    this.onTap,
    this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    if (day == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.boardGrid.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        child: isMain ? _MainCell(
          day: day!,
          isToday: isToday,
          isSunday: isSunday,
          notes: notes,
          events: events,
          onNoteTap: onNoteTap,
        ) : _MiniCell(
          day: day!,
          isToday: isToday,
          isSunday: isSunday,
          notes: notes,
        ),
      ),
    );
  }
}

// ── Cellule du mois central ────────────────────────────────────────────────

class _MainCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSunday;
  final List<StickyNote> notes;
  final List<CalendarEvent> events;
  final void Function(StickyNote)? onNoteTap;

  const _MainCell({
    required this.day,
    required this.isToday,
    required this.isSunday,
    required this.notes,
    required this.events,
    this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Numéro du jour ─────────────────────────────────────────────
        Positioned(
          top: 3,
          left: 4,
          child: _DayNumber(
            day: day,
            isToday: isToday,
            isSunday: isSunday,
            isMain: true,
          ),
        ),

        // ── Événements texte (sous le numéro) ──────────────────────────
        if (events.isNotEmpty)
          Positioned(
            top: 20,
            left: 2,
            right: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: events.take(2).map((e) => Text(
                e.displayLabel,
                style: AppTextStyles.stickyNoteMini.copyWith(fontSize: 8),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )).toList(),
            ),
          ),

        // ── Stack de post-its ──────────────────────────────────────────
        if (notes.isNotEmpty)
          Positioned(
            bottom: 2,
            right: 2,
            child: _StickyStack(
              notes: notes,
              isMain: true,
              onNoteTap: onNoteTap,
            ),
          ),
      ],
    );
  }
}

// ── Cellule d'un mini-mois ─────────────────────────────────────────────────

class _MiniCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSunday;
  final List<StickyNote> notes;

  const _MiniCell({
    required this.day,
    required this.isToday,
    required this.isSunday,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: _DayNumber(
            day: day,
            isToday: isToday,
            isSunday: isSunday,
            isMain: false,
          ),
        ),

        // Post-its empilés sur mini-mois (version compacte)
        if (notes.isNotEmpty)
          Positioned(
            bottom: 0,
            right: 0,
            child: _StickyStack(
              notes: notes,
              isMain: false,
              onNoteTap: null,
            ),
          ),
      ],
    );
  }
}

// ── Numéro de jour avec cercle "aujourd'hui" ───────────────────────────────

class _DayNumber extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSunday;
  final bool isMain;

  const _DayNumber({
    required this.day,
    required this.isToday,
    required this.isSunday,
    required this.isMain,
  });

  @override
  Widget build(BuildContext context) {
    final size = isMain
        ? AppDimensions.mainDayNumberSize
        : AppDimensions.miniDayNumberSize;

    TextStyle style;
    if (isToday) {
      style = isMain
          ? AppTextStyles.monthMainDayNumberToday
          : AppTextStyles.monthMiniDayNumber.copyWith(color: Colors.white);
    } else if (isSunday) {
      style = isMain
          ? AppTextStyles.monthMainDayNumberSunday
          : AppTextStyles.monthMiniDayNumberSunday;
    } else {
      style = isMain
          ? AppTextStyles.monthMainDayNumber
          : AppTextStyles.monthMiniDayNumber;
    }

    return Container(
      width: size,
      height: size,
      decoration: isToday
          ? BoxDecoration(
              color: AppColors.todayAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.todayAccent.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            )
          : null,
      child: Center(
        child: Text('$day', style: style),
      ),
    );
  }
}

// ── Stack de post-its chevauchants ─────────────────────────────────────────

class _StickyStack extends StatelessWidget {
  final List<StickyNote> notes;
  final bool isMain;
  final void Function(StickyNote)? onNoteTap;

  const _StickyStack({
    required this.notes,
    required this.isMain,
    this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    final maxVisible = AppDimensions.stickyMaxStackShown.toInt();
    final visibleNotes = notes.take(maxVisible).toList();
    final extraCount = notes.length - maxVisible;

    final noteW = isMain
        ? AppDimensions.stickyNoteMainW
        : AppDimensions.stickyNoteW;
    final noteH = isMain
        ? AppDimensions.stickyNoteMainH
        : AppDimensions.stickyNoteH;

    final offsetX = AppDimensions.stickyStackOffsetX;
    final offsetY = AppDimensions.stickyStackOffsetY;

    // Largeur totale du stack = noteW + (n-1) * offsetX
    final stackW = noteW + (visibleNotes.length - 1) * offsetX;
    final stackH = noteH + (visibleNotes.length - 1) * offsetY;

    return SizedBox(
      width: stackW,
      height: stackH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Post-its du bas vers le haut (le 1er est en dessous)
          ...List.generate(visibleNotes.length, (i) {
            final note = visibleNotes[visibleNotes.length - 1 - i];
            final revI = visibleNotes.length - 1 - i;

            return Positioned(
              left: revI * offsetX,
              top: revI * offsetY,
              child: GestureDetector(
                onTap: onNoteTap != null ? () => onNoteTap!(note) : null,
                child: StickyNoteWidget(
                  note: note,
                  width: noteW,
                  height: noteH,
                  isCompact: !isMain,
                ),
              ),
            );
          }),

          // Badge "+N" si plus de maxVisible notes
          if (extraCount > 0)
            Positioned(
              top: -AppDimensions.noteBadgeSize / 2,
              right: -AppDimensions.noteBadgeSize / 2,
              child: _ExtraBadge(count: extraCount),
            ),
        ],
      ),
    );
  }
}

class _ExtraBadge extends StatelessWidget {
  final int count;
  const _ExtraBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.noteBadgeSize,
      height: AppDimensions.noteBadgeSize,
      decoration: BoxDecoration(
        color: AppColors.woodMedium,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '+$count',
          style: TextStyle(
            fontSize: AppDimensions.noteBadgeFontSize,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
