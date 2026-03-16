import 'package:flutter/foundation.dart';
import '../models/month_data.dart';
import '../models/sticky_note.dart';
import '../models/calendar_event.dart';
import '../core/utils/calendar_helpers.dart';
import 'notes_provider.dart';

/// Gère l'année affichée et le mois central sélectionné.
/// Délègue la persistance des notes au NotesProvider.
class CalendarProvider extends ChangeNotifier {
  final NotesProvider _notesProvider;

  int _displayYear;
  int _centralMonthIndex; // 0–11

  // Cache local des MonthData enrichis avec notes/events
  List<MonthData> _months = [];

  CalendarProvider({
    required NotesProvider notesProvider,
    int? initialYear,
    int? initialMonthIndex,
  })  : _notesProvider = notesProvider,
        _displayYear = initialYear ?? DateTime.now().year,
        _centralMonthIndex =
            initialMonthIndex ?? CalendarHelpers.currentMonthIndex {
    _rebuildMonths();
    // Se re-construit quand les notes changent
    _notesProvider.addListener(_onNotesChanged);
  }

  // ── Getters ──────────────────────────────────────────────────────────────

  int get displayYear => _displayYear;
  int get centralMonthIndex => _centralMonthIndex;
  List<MonthData> get months => List.unmodifiable(_months);
  MonthData get centralMonth => _months[_centralMonthIndex];

  // ── Navigation ───────────────────────────────────────────────────────────

  void goToPreviousYear() {
    _displayYear--;
    _rebuildMonths();
    notifyListeners();
  }

  void goToNextYear() {
    _displayYear++;
    _rebuildMonths();
    notifyListeners();
  }

  void selectMonth(int monthIndex) {
    assert(monthIndex >= 0 && monthIndex <= 11);
    _centralMonthIndex = monthIndex;
    notifyListeners();
  }

  void goToToday() {
    final now = DateTime.now();
    if (_displayYear != now.year) {
      _displayYear = now.year;
      _rebuildMonths();
    }
    _centralMonthIndex = CalendarHelpers.currentMonthIndex;
    notifyListeners();
  }

  // ── Actions sur les notes (délégation au NotesProvider) ─────────────────

  Future<void> addNote({
    required DateTime date,
    required String text,
    StickyNoteColor color = StickyNoteColor.yellow,
  }) async {
    final note = StickyNote(text: text, date: date, color: color);
    await _notesProvider.addNote(note);
    // _onNotesChanged() sera appelé via le listener → rebuild auto
  }

  Future<void> updateNote(StickyNote updated) async {
    await _notesProvider.updateNote(updated);
  }

  Future<void> deleteNote(String noteId) async {
    await _notesProvider.deleteNote(noteId);
  }

  // ── Reconstruction interne ───────────────────────────────────────────────

  void _onNotesChanged() {
    _rebuildMonths();
    notifyListeners();
  }

  /// Reconstruit la liste des 12 MonthData en injectant
  /// les notes et events depuis le NotesProvider.
  void _rebuildMonths() {
    final base = CalendarHelpers.generateYear(_displayYear);
    _months = base.map((monthData) {
      final notes = _notesProvider.notesForMonth(
        year: monthData.year,
        month: monthData.month,
      );
      final events = _notesProvider.eventsForMonth(
        year: monthData.year,
        month: monthData.month,
      );
      return monthData.copyWith(notes: notes, events: events);
    }).toList();
  }

  @override
  void dispose() {
    _notesProvider.removeListener(_onNotesChanged);
    super.dispose();
  }
}
