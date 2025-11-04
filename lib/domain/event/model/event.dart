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

  const Event({
    required this.id,
    required this.name,
    required this.date,
    required this.description,
    this.imageUrl,
    required this.location,
    this.tags = const [],
    required this.userJoined,
  });

  Event copyWith({
    String? id,
    String? name,
    int? date,
    String? description,
    String? imageUrl,
    EventLocation? location,
    List<String>? tags,
    bool? userJoined,
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
    );
  }
}
