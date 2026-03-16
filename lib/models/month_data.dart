import 'sticky_note.dart';
import 'calendar_event.dart';

class MonthData {
  final int year;
  final int month;

  final List<StickyNote> notes;
  final List<CalendarEvent> events;

  MonthData({
    required this.year,
    required this.month,
    List<StickyNote> notes,
    List<CalendarEvent> events;
  }) : notes = notes ?? [],
       events = events ?? [];


  //Infos de base

  String get monthName {
    const names = [
      '', 'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST',
      'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER',
    ];
    return names [month];
  }

  
  String get shortMonthName => monthName.substring(0, 3);
  
  
  //Nombre de jours dans ce mois
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  ///jour de la semaine du 1er (0 = dimanche, 6 = Samedi)
  int get firstWeekday {
    final d = DateTime(year, month, 1).weekday;
    return d % 7;
  }

  // Grille calendrier

  //Retourne une grille de 6 semaines x 7 jours,
  /// Null = case vide (avant le 1er ou après le dernier jour).
  List<List<int?>> get weeksGrid {
    final grid = <List<int?>>[];
    var currentDay = 1;
    final offset = firstWeekday;

    for (var week = 0; week < 6; week++) {
      final row = <int?>[];
      for (var dow = 0; dow < 7; dow++) {
        final cellIndex = week * 7 + dow;
        if(cellIndex < offset || currentDay > daysInMonth) {
          row.add(null);
        } else {
          row.add(currentDay++);
        }
      }
      if (row.any((d) => d != null)) grid .add(row);
    }
    return grid;
  }

  List<StickyNote> notesForDay(int day) {
    final target = DateTime(year, month, day);
    return notes.where((n) =>
      n.date.year == target.year &&
      n.date.month == target.month &&
      n.date.day == target.day,
    ).toList();
  }

  List<CalendarEvent> eventsForDay(int day) {
    final target = DateTime(year, month, day);
    return events.where((e) =>
      e.date.year == target.year &&
      e.date.month == target.month &&
      e.date.day == target.day,
    ).toList();
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  MonthData copyWith({
    List<StickyNote>? notes,
    List<CalendarEvent>? events,
  }) {
    return MonthData(
      year: year,
      month: month,
      notes: notes ?? List.from(this.notes),
      events: events ?? List.from(this.events),
    );
  }

  MonthData addNote(StickyNote note) =>
    copyWith(notes : [...notes, note]);


  MonthData removeNote(String noteId) =>
    copyWith(notes: notes.where((n) => n.id != noteId).toList());

  MonthData updateNote(StickyNote updated) => copyWith(
    notes: notes.map((n) => n.id == updated.id ? updated : n).toList(),
    );

  @override
  String toString() => 'MonthData($monthName $year, ${notes.length} notes)';
}
