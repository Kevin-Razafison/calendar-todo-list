import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../models/sticky_note.dart';
import '../models/quick_note.dart';
import '../providers/calendar_provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/board/wood_board.dart';
import '../widgets/board/board_layout.dart';
import '../widgets/calendar/month_mini_widget.dart';
import '../widgets/calendar/month_main_widget.dart';
import '../widgets/notes/quick_notes_bar.dart';
import '../widgets/notes/add_note_dialog.dart';
import '../widgets/notes/add_quick_note_dialog.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F08), // mur sombre derrière le tableau
      body: SafeArea(
        child: Consumer<CalendarProvider>(
          builder: (context, calProv, _) {
            if (!context.read<NotesProvider>().isLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.stickyYellow),
              );
            }

            return Column(
              children: [
                // ── Barre de navigation année ────────────────────────────
                _YearNavBar(
                  year: calProv.displayYear,
                  onPrev: calProv.goToPreviousYear,
                  onNext: calProv.goToNextYear,
                  onToday: calProv.goToToday,
                ),

                // ── Tableau principal ────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                    child: WoodBoard(
                      child: BoardLayout(
                        months: calProv.months,
                        currentMonthIndex: calProv.centralMonthIndex,

                        // ── Mini mois ──────────────────────────────────
                        miniMonthBuilder: (month, isCurrent) => MonthMiniWidget(
                          month: month,
                          isCurrent: isCurrent,
                          onDayTap: (date) => _onDayTap(context, date),
                        ),

                        // ── Mois central ───────────────────────────────
                        mainMonthBuilder: (month) => MonthMainWidget(
                          month: month,
                          onDayTap: (date) => _onDayTap(context, date),
                          onNoteTap: (note) => _onNoteTap(context, note),
                        ),

                        // ── Quick notes bar ────────────────────────────
                        quickNotesBar: Consumer<NotesProvider>(
                          builder: (context, notesProv, _) => QuickNotesBar(
                            notes: notesProv.quickNotes,
                            onAddNote: () => _onAddQuickNote(context),
                            onNoteTap: (note) => _onQuickNoteTap(context, note),
                            onNoteLongPress: (note) => _onQuickNoteLongPress(context, note),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _onDayTap(BuildContext context, DateTime date) async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (_) => AddNoteDialog(date: date),
    );

    if (result == null || result is! StickyNote) return;
    if (!context.mounted) return;
    await context.read<CalendarProvider>().addNote(
      date: result.date,
      text: result.text,
      color: result.color,
    );
  }

  Future<void> _onNoteTap(BuildContext context, StickyNote note) async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (_) => AddNoteDialog(
        date: note.date,
        existingNote: note,
      ),
    );

    if (!context.mounted) return;
    if (result == 'delete') {
      await context.read<CalendarProvider>().deleteNote(note.id);
    } else if (result is StickyNote) {
      await context.read<CalendarProvider>().updateNote(result);
    }
  }

  Future<void> _onAddQuickNote(BuildContext context) async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (_) => const AddQuickNoteDialog(),
    );

    if (result == null || result is! QuickNote) return;
    if (!context.mounted) return;
    await context.read<NotesProvider>().addQuickNote(result);
  }

  Future<void> _onQuickNoteTap(BuildContext context, QuickNote note) async {
    final result = await showDialog<dynamic>(
      context: context,
      builder: (_) => AddQuickNoteDialog(existingNote: note),
    );

    if (!context.mounted) return;
    if (result == 'delete') {
      await context.read<NotesProvider>().deleteQuickNote(note.id);
    } else if (result is QuickNote) {
      await context.read<NotesProvider>().updateQuickNote(result);
    }
  }

  Future<void> _onQuickNoteLongPress(BuildContext context, QuickNote note) async {
    // Long press → picker de date pour lier/délier la note
    final picked = await showDatePicker(
      context: context,
      initialDate: note.linkedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: note.linkedDate == null
          ? 'Link note to a date'
          : 'Change linked date',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.woodMedium,
          ),
        ),
        child: child!,
      ),
    );

    if (!context.mounted) return;
    if (picked != null) {
      await context.read<NotesProvider>().linkQuickNoteToDate(note.id, picked);
    }
  }
}

// ── Barre navigation année ─────────────────────────────────────────────────

class _YearNavBar extends StatelessWidget {
  final int year;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const _YearNavBar({
    required this.year,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Année précédente
          _NavButton(icon: Icons.chevron_left, onTap: onPrev),

          // Année + bouton Today
          Row(
            children: [
              Text(
                '$year',
                style: const TextStyle(
                  color: AppColors.stickyYellow,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onToday,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.stickyYellow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.stickyYellow.withOpacity(0.4),
                    ),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: AppColors.stickyYellow,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Caveat',
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Année suivante
          _NavButton(icon: Icons.chevron_right, onTap: onNext),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.woodMedium.withOpacity(0.4),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.woodLight.withOpacity(0.5),
          ),
        ),
        child: Icon(icon, color: AppColors.stickyYellow, size: 20),
      ),
    );
  }
}
