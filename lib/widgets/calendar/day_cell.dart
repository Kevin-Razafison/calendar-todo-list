import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/sticky_note.dart';
import '../../models/calendar_event.dart';
import '../notes/sticky_note_widget.dart';
import '../notes/note_stack_dialog.dart';

class DayCell extends StatelessWidget {
  final int? day;
  final bool isToday;
  final bool isSunday;
  final bool isMain;
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.boardGrid.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        child: isMain
            ? _MainCell(
                day: day!,
                isToday: isToday,
                isSunday: isSunday,
                notes: notes,
                events: events,
                onNoteTap: onNoteTap,
                onAddNote: onTap,
              )
            : _MiniCell(
                day: day!,
                isToday: isToday,
                isSunday: isSunday,
                notes: notes,
                onNoteTap: onNoteTap, // ← ajouté
                onAddNote: onTap, // ← ajouté
              ),
      ),
    );
  }
}

// ── Cellule mois central ───────────────────────────────────────────────────

class _MainCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSunday;
  final List<StickyNote> notes;
  final List<CalendarEvent> events;
  final void Function(StickyNote)? onNoteTap;
  final VoidCallback? onAddNote;

  const _MainCell({
    required this.day,
    required this.isToday,
    required this.isSunday,
    required this.notes,
    required this.events,
    this.onNoteTap,
    this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
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

        if (events.isNotEmpty)
          Positioned(
            top: 20,
            left: 2,
            right: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: events
                  .take(2)
                  .map(
                    (e) => Text(
                      e.displayLabel,
                      style: AppTextStyles.stickyNoteMini.copyWith(fontSize: 8),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                  .toList(),
            ),
          ),

        if (notes.isNotEmpty)
          Positioned(
            bottom: 2,
            right: 2,
            child: _StickyStack(
              notes: notes,
              isMain: true,
              onNoteTap: onNoteTap,
              onAddNote: onAddNote,
            ),
          ),

        if (notes.isNotEmpty)
          Positioned(
            top: 3,
            right: 4,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.woodMedium.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.woodMedium.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 9,
                  color: AppColors.woodMedium.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Cellule mini-mois ──────────────────────────────────────────────────────

class _MiniCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSunday;
  final List<StickyNote> notes;
  final void Function(StickyNote)? onNoteTap; // ← ajouté
  final VoidCallback? onAddNote; // ← ajouté

  const _MiniCell({
    required this.day,
    required this.isToday,
    required this.isSunday,
    required this.notes,
    this.onNoteTap,
    this.onAddNote,
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

        if (notes.isNotEmpty)
          Positioned(
            bottom: 0,
            right: 0,
            child: _StickyStack(
              notes: notes,
              isMain: false,
              onNoteTap: onNoteTap, // ← ajouté
              onAddNote: onAddNote, // ← ajouté
            ),
          ),
      ],
    );
  }
}

// ── DayNumber ──────────────────────────────────────────────────────────────

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
                  color: AppColors.todayAccent.withValues(alpha: 0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            )
          : null,
      child: Center(child: Text('$day', style: style)),
    );
  }
}

// ── StickyStack ────────────────────────────────────────────────────────────

class _StickyStack extends StatelessWidget {
  final List<StickyNote> notes;
  final bool isMain;
  final void Function(StickyNote)? onNoteTap;
  final VoidCallback? onAddNote;

  const _StickyStack({
    required this.notes,
    required this.isMain,
    this.onNoteTap,
    this.onAddNote,
  });

  void _showAllNotes(BuildContext context) {
    // Trouve la date depuis la première note
    final date = notes.first.date;
    showDialog(
      context: context,
      builder: (_) => NoteStackDialog(
        notes: notes,
        date: date,
        onNoteTap: onNoteTap,
        onAddNote: onAddNote,
      ),
    );
  }

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

    final stackW = noteW + (visibleNotes.length - 1) * offsetX;
    final stackH = noteH + (visibleNotes.length - 1) * offsetY;

    return SizedBox(
      width: stackW,
      height: stackH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...List.generate(visibleNotes.length, (i) {
            final note = visibleNotes[visibleNotes.length - 1 - i];
            final revI = visibleNotes.length - 1 - i;

            return Positioned(
              left: revI * offsetX,
              top: revI * offsetY,
              child: GestureDetector(
                // ← Tap sur le stack = afficher TOUTES les notes
                onTap: () => _showAllNotes(context),
                behavior: HitTestBehavior.opaque,
                child: StickyNoteWidget(
                  note: note,
                  width: noteW,
                  height: noteH,
                  isCompact: !isMain,
                ),
              ),
            );
          }),

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
          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 3),
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
