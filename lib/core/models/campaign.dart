import 'package:cthulhu_solo_investigator_app/core/models/roll.model.dart';

class Campaign {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime lastPlayedAt;
  final List<Roll> rolls;
  final int mythsCounter;
  final String notes;

  const Campaign({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.lastPlayedAt,
    required this.rolls,
    required this.mythsCounter,
    required this.notes,
  });

  Campaign.fresh({required this.id, required this.name, required DateTime now})
      : createdAt = now,
        lastPlayedAt = now,
        rolls = const [],
        mythsCounter = 0,
        notes = '';

  Campaign copyWith({
    String? name,
    DateTime? lastPlayedAt,
    List<Roll>? rolls,
    int? mythsCounter,
    String? notes,
  }) =>
      Campaign(
        id: id,
        name: name ?? this.name,
        createdAt: createdAt,
        lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
        rolls: rolls ?? this.rolls,
        mythsCounter: mythsCounter ?? this.mythsCounter,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'rolls': rolls.map((r) => r.toJson()).toList(),
        'mythsCounter': mythsCounter,
        'notes': notes,
      };

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
        id: json['id'] as String,
        name: json['name'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
        rolls: (json['rolls'] as List<dynamic>)
            .map((r) => Roll.fromJson(r as Map<String, dynamic>))
            .toList(),
        mythsCounter: json['mythsCounter'] as int,
        notes: json['notes'] as String? ?? '',
      );
}
