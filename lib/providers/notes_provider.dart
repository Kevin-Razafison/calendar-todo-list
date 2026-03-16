import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sticky_note.dart';
import '../models/calendar_event.dart';
import '../models/quick_note.dart';

/// Gère la persistance et l'état de toutes les notes,
/// événements et quick notes via SharedPreferences.
///
/// On utilise SharedPreferences plutôt que Hive pour
/// simplifier le setup (pas de génération de code).
class NotesProvider extends ChangeNotifier {
  // ── État en mémoire ──────────────────────────────────────────────────────
  final List<StickyNote> _notes = [];
  final List<CalendarEvent> _events = [];
  final List<QuickNote> _quickNotes = [];

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  // Clés SharedPreferences
  static const _kNotes       = 'sticky_notes';
  static const _kEvents      = 'calendar_events';
  static const _kQuickNotes  = 'quick_notes';

  // ── Init ─────────────────────────────────────────────────────────────────

  Future<void> loadAll() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();

    // Notes
    final rawNotes = prefs.getString(_kNotes);
    if (rawNotes != null) {
      final list = jsonDecode(rawNotes) as List<dynamic>;
      _notes.addAll(list.map((e) => StickyNote.fromMap(e as Map<String, dynamic>)));
    }

    // Events
    final rawEvents = prefs.getString(_kEvents);
    if (rawEvents != null) {
      final list = jsonDecode(rawEvents) as List<dynamic>;
      _events.addAll(list.map((e) => CalendarEvent.fromMap(e as Map<String, dynamic>)));
    }

    // Quick Notes
    final rawQuick = prefs.getString(_kQuickNotes);
    if (rawQuick != null) {
      final list = jsonDecode(rawQuick) as List<dynamic>;
      _quickNotes.addAll(list.map((e) => QuickNote.fromMap(e as Map<String, dynamic>)));
    }

    _isLoaded = true;
    notifyListeners();
  }

  // ── Accesseurs filtrés ───────────────────────────────────────────────────

  List<StickyNote> notesForMonth({required int year, required int month}) =>
      _notes.where((n) => n.date.year == year && n.date.month == month).toList();

  List<StickyNote> notesForDay({required int year, required int month, required int day}) =>
      _notes.where((n) =>
        n.date.year == year &&
        n.date.month == month &&
        n.date.day == day,
      ).toList();

  List<CalendarEvent> eventsForMonth({required int year, required int month}) =>
      _events.where((e) => e.date.year == year && e.date.month == month).toList();

  List<QuickNote> get quickNotes => List.unmodifiable(_quickNotes);

  // ── CRUD StickyNote ──────────────────────────────────────────────────────

  Future<void> addNote(StickyNote note) async {
    _notes.add(note);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> updateNote(StickyNote updated) async {
    final i = _notes.indexWhere((n) => n.id == updated.id);
    if (i == -1) return;
    _notes[i] = updated;
    await _saveNotes();
    notifyListeners();
  }

  Future<void> deleteNote(String noteId) async {
    _notes.removeWhere((n) => n.id == noteId);
    await _saveNotes();
    notifyListeners();
  }

  // ── CRUD CalendarEvent ───────────────────────────────────────────────────

  Future<void> addEvent(CalendarEvent event) async {
    _events.add(event);
    await _saveEvents();
    notifyListeners();
  }

  Future<void> updateEvent(CalendarEvent updated) async {
    final i = _events.indexWhere((e) => e.id == updated.id);
    if (i == -1) return;
    _events[i] = updated;
    await _saveEvents();
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    _events.removeWhere((e) => e.id == eventId);
    await _saveEvents();
    notifyListeners();
  }

  // ── CRUD QuickNote ───────────────────────────────────────────────────────

  Future<void> addQuickNote(QuickNote note) async {
    if (_quickNotes.length >= 5) return; // max 5
    _quickNotes.add(note);
    await _saveQuickNotes();
    notifyListeners();
  }

  Future<void> updateQuickNote(QuickNote updated) async {
    final i = _quickNotes.indexWhere((n) => n.id == updated.id);
    if (i == -1) return;
    _quickNotes[i] = updated;
    await _saveQuickNotes();
    notifyListeners();
  }

  Future<void> deleteQuickNote(String noteId) async {
    _quickNotes.removeWhere((n) => n.id == noteId);
    await _saveQuickNotes();
    notifyListeners();
  }

  /// Lie une quick note à une date (ou supprime le lien si null)
  Future<void> linkQuickNoteToDate(String noteId, DateTime? date) async {
    final i = _quickNotes.indexWhere((n) => n.id == noteId);
    if (i == -1) return;
    _quickNotes[i] = _quickNotes[i].copyWith(
      linkedDate: date,
      clearLinkedDate: date == null,
    );
    await _saveQuickNotes();
    notifyListeners();
  }

  // ── Persistance ──────────────────────────────────────────────────────────

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kNotes,
      jsonEncode(_notes.map((n) => n.toMap()).toList()),
    );
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kEvents,
      jsonEncode(_events.map((e) => e.toMap()).toList()),
    );
  }

  Future<void> _saveQuickNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kQuickNotes,
      jsonEncode(_quickNotes.map((n) => n.toMap()).toList()),
    );
  }

  // ── Reset (debug) ────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    _notes.clear();
    _events.clear();
    _quickNotes.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kNotes);
    await prefs.remove(_kEvents);
    await prefs.remove(_kQuickNotes);
    notifyListeners();
  }
}
