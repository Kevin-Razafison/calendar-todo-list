import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/quick_note.dart';
import 'sticky_note_widget.dart';

class QuickNotesBar extends StatelessWidget {
  final List<QuickNote> notes;
  final VoidCallback? onAddNote;
  final void Function(QuickNote note)? onNoteTap;
  final void Function(QuickNote note)? onNoteLongPress;

  const QuickNotesBar({
    super.key,
    required this.notes,
    this.onAddNote,
    this.onNoteTap,
    this.onNoteLongPress,
  });

  static const int kMaxNotes = 5;
  static const double kNoteW = 72.0;
  static const double kNoteH = 72.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Légère bande bois en haut de la barre
        border: Border(
          top: BorderSide(
            color: AppColors.woodMedium.withOpacity(0.4),
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          // ── Post-its existants ─────────────────────────────────────────
          ...notes.take(kMaxNotes).map((note) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: onNoteTap != null ? () => onNoteTap!(note) : null,
              onLongPress: onNoteLongPress != null
                  ? () => onNoteLongPress!(note)
                  : null,
              child: _QuickNoteItem(note: note),
            ),
          )),

          // ── Bouton "+" si moins de 5 notes ────────────────────────────
          if (notes.length < kMaxNotes)
            GestureDetector(
              onTap: onAddNote,
              child: const _AddNoteButton(),
            ),
        ],
      ),
    );
  }
}

class _QuickNoteItem extends StatelessWidget {
  final QuickNote note;
  const _QuickNoteItem({required this.note});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Post-it
        Transform.rotate(
          angle: note.rotationAngle,
          child: Container(
            width: QuickNotesBar.kNoteW,
            height: QuickNotesBar.kNoteH,
            decoration: BoxDecoration(
              color: note.color.color,
              borderRadius: BorderRadius.circular(AppDimensions.stickyCornerRadius),
              boxShadow: [
                BoxShadow(
                  color: note.color.shadowColor.withOpacity(0.35),
                  blurRadius: 5,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    note.text,
                    style: AppTextStyles.stickyNoteMain.copyWith(fontSize: 11),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Badge date si liée à un jour
                if (note.linkedDate != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    decoration: BoxDecoration(
                      color: note.color.shadowColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      '${note.linkedDate!.day}/${note.linkedDate!.month}',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnSticky,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddNoteButton extends StatelessWidget {
  const _AddNoteButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: QuickNotesBar.kNoteW,
      height: QuickNotesBar.kNoteH,
      decoration: BoxDecoration(
        color: AppColors.stickyYellow.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.stickyCornerRadius),
        border: Border.all(
          color: AppColors.stickyYellowDark.withOpacity(0.4),
          width: 1.5,
          // Bordure en pointillés simulée via dashes
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: AppColors.woodMedium.withOpacity(0.6),
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            'Add note',
            style: TextStyle(
              fontSize: 9,
              color: AppColors.woodMedium.withOpacity(0.6),
              fontFamily: 'Caveat',
            ),
          ),
        ],
      ),
    );
  }
}
