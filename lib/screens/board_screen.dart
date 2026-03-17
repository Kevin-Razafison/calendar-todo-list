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
import '../main.dart';
import 'package:home_widget/home_widget.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();
    _handleWidgetIntent();
    HomeWidget.widgetClicked.listen(_handleWidgetClick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F08),
      body: SafeArea(
        child: Consumer2<CalendarProvider, NotesProvider>(
          builder: (context, calProv, notesProv, _) {
            if (!notesProv.isLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.stickyYellow),
              );
            }

            return Column(
              children: [
                _YearNavBar(
                  year: calProv.displayYear,
                  onPrev: calProv.goToPreviousYear,
                  onNext: calProv.goToNextYear,
                  onToday: calProv.goToToday,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                    child: WoodBoard(
                      child: BoardLayout(
                        months: calProv.months,
                        currentMonthIndex: calProv.centralMonthIndex,

                        miniMonthBuilder: (month, isCurrent) => MonthMiniWidget(
                          month: month,
                          isCurrent: isCurrent,
                          onDayTap: _onDayTap,
                          onNoteTap: _onNoteTap,
                        ),

                        mainMonthBuilder: (month) => MonthMainWidget(
                          month: month,
                          onDayTap: _onDayTap,
                          onNoteTap: _onNoteTap,
                        ),

                        quickNotesBar: Consumer<NotesProvider>(
                          builder: (ctx, notesProv, _) => QuickNotesBar(
                            notes: notesProv.quickNotes,
                            onAddNote: _onAddQuickNote,
                            onNoteTap: _onQuickNoteTap,
                            onNoteLongPress: _onQuickNoteLongPress,
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

  Future<void> _onDayTap(DateTime date) async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final result = await showDialog<dynamic>(
      context: ctx,
      builder: (_) => AddNoteDialog(date: date),
    );
    if (result == null || result is! StickyNote) return;
    if (!mounted) return;
    context.read<CalendarProvider>().addNote(
      date: result.date,
      text: result.text,
      color: result.color,
    );
  }

  Future<void> _onNoteTap(StickyNote note) async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final result = await showDialog<dynamic>(
      context: ctx,
      builder: (_) => AddNoteDialog(date: note.date, existingNote: note),
    );
    if (!mounted) return;
    if (result == 'delete') {
      context.read<CalendarProvider>().deleteNote(note.id);
    } else if (result is StickyNote) {
      context.read<CalendarProvider>().updateNote(result);
    }
  }

  Future<void> _onAddQuickNote() async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final result = await showDialog<dynamic>(
      context: ctx,
      builder: (_) => const AddQuickNoteDialog(),
    );
    if (result == null || result is! QuickNote) return;
    if (!mounted) return;
    context.read<NotesProvider>().addQuickNote(result);
  }

  Future<void> _onQuickNoteTap(QuickNote note) async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final result = await showDialog<dynamic>(
      context: ctx,
      builder: (_) => AddQuickNoteDialog(existingNote: note),
    );
    if (!mounted) return;
    if (result == 'delete') {
      context.read<NotesProvider>().deleteQuickNote(note.id);
    } else if (result is QuickNote) {
      context.read<NotesProvider>().updateQuickNote(result);
    }
  }

  Future<void> _onQuickNoteLongPress(QuickNote note) async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    final picked = await showDatePicker(
      context: ctx,
      initialDate: note.linkedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.woodMedium),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;
    if (picked != null) {
      context.read<NotesProvider>().linkQuickNoteToDate(note.id, picked);
    }
  }

  Future<void> _handleWidgetIntent() async {
    final uri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    if (uri != null) _processWidgetUri(uri);
  }

  void _handleWidgetClick(Uri? uri) {
    if (uri != null) _processWidgetUri(uri);
  }

  void _processWidgetUri(Uri uri) {
    final action = uri.queryParameters['action'];
    final dateStr = uri.queryParameters['date'];

    if (action == 'add_note' && dateStr != null) {
      final date = DateTime.parse(dateStr);
      // Ouvre directement le dialog d'ajout
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onDayTap(date);
      });
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
          _NavButton(icon: Icons.chevron_left, onTap: onPrev),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.stickyYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.stickyYellow.withValues(alpha: 0.4),
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
          color: AppColors.woodMedium.withValues(alpha: 0.4),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.woodLight.withValues(alpha: 0.5)),
        ),
        child: Icon(icon, color: AppColors.stickyYellow, size: 20),
      ),
    );
  }
}
