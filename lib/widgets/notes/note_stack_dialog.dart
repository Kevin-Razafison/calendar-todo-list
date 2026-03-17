import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/sticky_note.dart';

/// Affiche toutes les notes d'un jour côte à côte
class NoteStackDialog extends StatelessWidget {
  final List<StickyNote> notes;
  final DateTime date;
  final void Function(StickyNote note)? onNoteTap;
  final VoidCallback? onAddNote;

  const NoteStackDialog({
    super.key,
    required this.notes,
    required this.date,
    this.onNoteTap,
    this.onAddNote,
  });

  String get _formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: AppColors.boardWhite,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── En-tête ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.boardGrid, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formattedDate,
                      style: AppTextStyles.monthMainTitle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Bouton ajouter
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      onAddNote?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.stickyYellow.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.stickyYellowDark.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: 14,
                            color: AppColors.textOnSticky,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Add note',
                            style: AppTextStyles.stickyNoteMain.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Fermer
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),

            // ── Notes côte à côte ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notes.map((note) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          onNoteTap?.call(note);
                        },
                        child: _NoteCard(note: note),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Hint ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Tap a note to edit or delete it',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textLight,
                  fontFamily: 'Caveat',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final StickyNote note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: note.rotationAngle * 0.5, // légère rotation
      child: Container(
        width: 110,
        constraints: const BoxConstraints(minHeight: 90),
        decoration: BoxDecoration(
          color: note.color.color,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: note.color.shadowColor.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          note.text,
          style: AppTextStyles.stickyNoteMain.copyWith(fontSize: 13),
        ),
      ),
    );
  }
}
