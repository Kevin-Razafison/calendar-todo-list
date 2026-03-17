import 'package:uuid/uuid.dart';

class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final bool isAllDay;

  CalendarEvent({
    String? id,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.isAllDay = false,
  }) : id = id ?? const Uuid().v4();

  CalendarEvent copyWith({
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? isAllDay,
  }) {
    return CalendarEvent(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startHour': startTime?.hour,
      'startMinute': startTime?.minute,
      'endHour': endTime?.hour,
      'endMinute': endTime?.minute,
      'isAllDay': isAllDay,
    };
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    TimeOfDay? parseTime(dynamic h, dynamic m) {
      if (h == null || m == null) return null;
      return TimeOfDay(hour: h as int, minute: m as int);
    }

    return CalendarEvent(
      id: map['id'] as String,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      startTime: parseTime(map['startHour'], map['startMinute']),
      endTime: parseTime(map['endHour'], map['endMinute']),
      isAllDay: map['isAllDay'] as bool? ?? false,
    );
  }

  /// Format affiché sur le calendrier, ex: "16:00 Eat" ou "Service Planned"
  String get displayLabel {
    if (isAllDay || startTime == null) return title;
    final h = startTime!.hour.toString().padLeft(2, '0');
    final m = startTime!.minute.toString().padLeft(2, '0');
    return '$h:$m $title';
  }

  @override
  bool operator ==(Object other) => other is CalendarEvent && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Redéfini ici pour éviter l'import de Material dans le modèle
class TimeOfDay {
  final int hour;
  final int minute;
  const TimeOfDay({required this.hour, required this.minute});

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
