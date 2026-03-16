import 'package:uuid/uuid.dart';
import 'sticky_note.dart';

class QuickNote {
  final String id;
  final String text;
  final StickyNoteColor color;
  final DateTime? linkedDate;
  final double rotationAngle;
  final DateTime createdAt;
  final DateTime? updatedAt;

  QuickNote({
    String? id,
    required this.text,
    this.color = StickyNoteColor.yellow,
    this.linkedDate,
    double? rotationAngle,
    DateTime? createdAt,
    this.updatedAt,
  })  : id = id ?? const Uuid().v4(),
        rotationAngle = rotationAngle ?? _randomAngle(),
        createdAt = createdAt ?? DateTime.now();

  static double _randomAngle() {
    return (DateTime.now().millisecondsSinceEpoch % 14 - 7) / 100.0;
  }

  QuickNote copyWith({
    String? text,
    StickyNoteColor? color,
    DateTime? linkedDate,
    bool clearLinkedDate = false,
    double? rotationAngle,
  }) {
    return QuickNote(
      id: id,
      text: text ?? this.text,
      color: color ?? this.color,
      linkedDate: clearLinkedDate ? null : (linkedDate ?? this.linkedDate),
      rotationAngle: rotationAngle ?? this.rotationAngle,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'color': color.name,
    'linkedDate': linkedDate?.toIso8601String(),
    'rotationAngle': rotationAngle,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory QuickNote.fromMap(Map<String, dynamic> map) => QuickNote(
    id: map['id'] as String,
    text: map['text'] as String,
    color: StickyNoteColorExtension.fromString(map['color'] as String),
    linkedDate: map['linkedDate'] != null
        ? DateTime.parse(map['linkedDate'] as String)
        : null,
    rotationAngle: (map['rotationAngle'] as num).toDouble(),
    createdAt: DateTime.parse(map['createdAt'] as String),
    updatedAt: map['updatedAt'] != null
        ? DateTime.parse(map['updatedAt'] as String)
        : null,
  );

  @override
  bool operator ==(Object other) => other is QuickNote && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
