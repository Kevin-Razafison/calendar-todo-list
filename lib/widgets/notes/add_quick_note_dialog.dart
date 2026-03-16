import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/quick_note.dart';
import '../../models/sticky_note.dart';

class AddQuickNoteDialog extends StatefulWidget {
  final QuickNote? existingNote;

  const AddQuickNoteDialog({super.key, this.existingNote});

  @override
  State<AddQuickNoteDialog> createState() => _AddQuickNoteDialogState();
}

class _AddQuickNoteDialogState extends State<AddQuickNoteDialog> {
  late TextEditingController _controller;
  late StickyNoteColor _selectedColor;
  DateTime? _linkedDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.existingNote?.text ?? '',
    );
    _selectedColor = widget.existingNote?.color ?? StickyNoteColor.yellow;
    _linkedDate = widget.existingNote?.linkedDate;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _linkedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.woodMedium,
            onSurface: AppColors.textDark,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _linkedDate = picked);
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
              color: _selectedColor.shadowColor.withOpacity(0.4),
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
                    isEdit ? 'Edit quick note' : 'New quick note',
                    style: AppTextStyles.dialogTitle,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 18,
                      color: AppColors.textOnSticky.withOpacity(0.6)),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Texte ──────────────────────────────────────────────────
            Container(
              constraints: const BoxConstraints(minHeight: 80, maxHeight: 140),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                style: AppTextStyles.dialogInput,
                maxLines: null,
                autofocus: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Quick note...',
                  hintStyle: AppTextStyles.dialogInput.copyWith(
                    color: AppColors.textOnSticky.withOpacity(0.4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Lier à une date (optionnel) ────────────────────────────
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: AppColors.textOnSticky.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today,
                        size: 13, color: AppColors.textOnSticky.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Text(
                      _linkedDate == null
                          ? 'Link to a date (optional)'
                          : '${_linkedDate!.day}/${_linkedDate!.month}/${_linkedDate!.year}',
                      style: AppTextStyles.stickyNoteMain.copyWith(fontSize: 12),
                    ),
                    if (_linkedDate != null) ...[
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => setState(() => _linkedDate = null),
                        child: Icon(Icons.close,
                            size: 13,
                            color: AppColors.textOnSticky.withOpacity(0.6)),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Couleurs ───────────────────────────────────────────────
            Row(
              children: StickyNoteColor.values.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: AppDimensions.colorPickerSize,
                    height: AppDimensions.colorPickerSize,
                    margin: const EdgeInsets.only(right: AppDimensions.colorPickerSpacing),
                    decoration: BoxDecoration(
                      color: color.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.textOnSticky
                            : color.shadowColor.withOpacity(0.5),
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, size: 14, color: AppColors.textOnSticky)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // ── Actions ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isEdit)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop('delete'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text('Delete',
                          style: AppTextStyles.dialogInput.copyWith(
                              fontSize: 13, color: Colors.red.shade700)),
                    ),
                  ),
                if (isEdit) const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    final note = isEdit
                        ? widget.existingNote!.copyWith(
                            text: text,
                            color: _selectedColor,
                            linkedDate: _linkedDate,
                            clearLinkedDate: _linkedDate == null,
                          )
                        : QuickNote(
                            text: text,
                            color: _selectedColor,
                            linkedDate: _linkedDate,
                          );
                    Navigator.of(context).pop(note);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.textOnSticky.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text('Save',
                        style: AppTextStyles.dialogInput.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w700)),
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
