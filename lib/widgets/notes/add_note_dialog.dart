import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/sticky_note.dart';

class AddNoteDialog extends StatefulWidget {
  final DateTime date;
  final StickyNote? existingNote;

  const AddNoteDialog({super.key, required this.date, this.existingNote});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  late TextEditingController _controller;
  late StickyNoteColor _selectedColor;
  late bool _bold;
  late bool _italic;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existingNote?.text ?? '');
    _selectedColor = widget.existingNote?.color ?? StickyNoteColor.yellow;
    _bold = widget.existingNote?.isBold ?? false;
    _italic = widget.existingNote?.isItalic ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _formattedDate {
    final d = widget.date;
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingNote != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: AppDimensions.dialogWidth,
        decoration: BoxDecoration(
          color: _selectedColor.color,
          borderRadius: BorderRadius.circular(AppDimensions.dialogRadius),
          boxShadow: [
            BoxShadow(
              color: _selectedColor.shadowColor.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimensions.dialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── En-tête ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Text(
                    isEdit ? 'Edit note' : _formattedDate,
                    style: AppTextStyles.dialogTitle,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.textOnSticky.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Zone de texte ──────────────────────────────────────────
            Container(
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 160),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                style: AppTextStyles.dialogInput.copyWith(
                  fontWeight: _bold ? FontWeight.w800 : FontWeight.w400,
                  fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                ),
                maxLines: null,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your note...',
                  hintStyle: AppTextStyles.dialogInput.copyWith(
                    color: AppColors.textOnSticky.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Sélecteur de couleur + Bold/Italic ────────────────────
            Row(
              children: [
                // Couleurs
                ...StickyNoteColor.values.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: AppDimensions.colorPickerSize,
                      height: AppDimensions.colorPickerSize,
                      margin: const EdgeInsets.only(
                        right: AppDimensions.colorPickerSpacing,
                      ),
                      decoration: BoxDecoration(
                        color: color.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.textOnSticky
                              : color.shadowColor.withValues(alpha: 0.5),
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.shadowColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 14,
                              color: AppColors.textOnSticky,
                            )
                          : null,
                    ),
                  );
                }),

                const Spacer(),

                // Bold
                GestureDetector(
                  onTap: () => setState(() => _bold = !_bold),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _bold
                          ? AppColors.textOnSticky.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.textOnSticky.withValues(
                          alpha: _bold ? 0.5 : 0.2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'B',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textOnSticky,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // Italic
                GestureDetector(
                  onTap: () => setState(() => _italic = !_italic),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _italic
                          ? AppColors.textOnSticky.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.textOnSticky.withValues(
                          alpha: _italic ? 0.5 : 0.2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'I',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOnSticky,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Boutons action ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isEdit)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop('delete'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        'Delete',
                        style: AppTextStyles.dialogInput.copyWith(
                          fontSize: 13,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ),

                if (isEdit) const SizedBox(width: 8),

                GestureDetector(
                  onTap: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;

                    if (isEdit) {
                      Navigator.of(context).pop(
                        widget.existingNote!.copyWith(
                          text: text,
                          color: _selectedColor,
                          isBold: _bold,
                          isItalic: _italic,
                        ),
                      );
                    } else {
                      Navigator.of(context).pop(
                        StickyNote(
                          text: text,
                          date: widget.date,
                          color: _selectedColor,
                          isBold: _bold,
                          isItalic: _italic,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textOnSticky.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'Save',
                      style: AppTextStyles.dialogInput.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
