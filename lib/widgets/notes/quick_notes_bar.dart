import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/quick_note.dart';
import '../../models/sticky_note.dart';

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Taille d'un slot = largeur totale / 5 → carré parfait
        final slotSize = constraints.maxWidth / kMaxNotes;

        return SizedBox(
          height: slotSize, // ← hauteur = largeur d'un slot = carré
          child: Row(
            children: List.generate(kMaxNotes, (i) {
              final hasNote = i < notes.length;
              final note = hasNote ? notes[i] : null;

              return SizedBox(
                width: slotSize,
                height: slotSize,
                child: _NoteSlot(
                  note: note,
                  isLast: i == kMaxNotes - 1,
                  onTap: hasNote
                      ? () => onNoteTap?.call(note!)
                      : () => onAddNote?.call(),
                  onLongPress: hasNote
                      ? () => onNoteLongPress?.call(note!)
                      : null,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _NoteSlot extends StatelessWidget {
  final QuickNote? note;
  final bool isLast;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _NoteSlot({
    required this.note,
    required this.isLast,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = note == null;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: isEmpty
              ? AppColors.woodDark.withValues(alpha: 0.06)
              : note!.color.color,
          border: Border(
            top: BorderSide(
              color: AppColors.woodMedium.withValues(alpha: 0.35),
              width: 1,
            ),
            right: isLast
                ? BorderSide.none
                : BorderSide(
                    color: AppColors.woodMedium.withValues(alpha: 0.30),
                    width: 1,
                  ),
          ),
        ),
        child: isEmpty ? const _EmptySlot() : _FilledSlot(note: note!),
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.add,
        size: 20,
        color: AppColors.woodMedium.withValues(alpha: 0.30),
      ),
    );
  }
}

class _FilledSlot extends StatelessWidget {
  final QuickNote note;
  const _FilledSlot({required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 5),
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
          if (note.linkedDate != null)
            Container(
              margin: const EdgeInsets.only(top: 3),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: note.color.shadowColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '${note.linkedDate!.day}/${note.linkedDate!.month}',
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnSticky,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
