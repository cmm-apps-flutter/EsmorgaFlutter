import 'package:esmorga_flutter/domain/event/model/event_type.dart';

class CreateEventParams {
  final String eventName;
  final String eventDate;
  final String description;
  final EventType eventType;
  final String? imageUrl;
  final String locationName;
  final double? locationLat;
  final double? locationLong;
  final int? maxCapacity;

  const CreateEventParams({
    required this.eventName,
    required this.eventDate,
    required this.description,
    required this.eventType,
    this.imageUrl,
    required this.locationName,
    this.locationLat,
    this.locationLong,
    this.maxCapacity,
  });
}
