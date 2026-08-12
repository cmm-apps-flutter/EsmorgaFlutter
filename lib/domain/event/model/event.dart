import 'package:esmorga_flutter/domain/event/model/event_location.dart';

class Event {
  final String id;
  final String name;
  final int date;
  final String description;
  final String? imageUrl;
  final EventLocation location;
  final List<String> tags;
  final bool userJoined;
  final int currentAttendeeCount;
  final int? maxCapacity;
  final int joinDeadline;

  const Event({
    required this.id,
    required this.name,
    required this.date,
    required this.description,
    this.imageUrl,
    required this.location,
    this.tags = const [],
    required this.userJoined,
    required this.currentAttendeeCount,
    this.maxCapacity,
    required this.joinDeadline,
  });

    factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      name: json['name'] as String,
      date: json['date'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      location: EventLocation.fromJson(
        Map<String, dynamic>.from(json['location']),
      ),
      tags: List<String>.from(json['tags'] ?? []),
      userJoined: json['userJoined'] as bool,
      currentAttendeeCount: json['currentAttendeeCount'] as int,
      maxCapacity: json['maxCapacity'] as int?,
      joinDeadline: json['joinDeadline'] as int,
    );
  }

  Event copyWith({
    String? id,
    String? name,
    int? date,
    String? description,
    String? imageUrl,
    EventLocation? location,
    List<String>? tags,
    bool? userJoined,
    int? currentAttendeeCount,
    int? maxCapacity,
    int? joinDeadline,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      userJoined: userJoined ?? this.userJoined,
      currentAttendeeCount: currentAttendeeCount ?? this.currentAttendeeCount,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      joinDeadline: joinDeadline ?? this.joinDeadline,
    );
  }
}