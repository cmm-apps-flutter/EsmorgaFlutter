import 'package:esmorga_flutter/domain/event/model/create_event_params.dart';
import 'package:esmorga_flutter/domain/event/model/event_type.dart';

class CreateEventRemoteModel {
  final String eventName;
  final String eventDate;
  final String description;
  final String eventType;
  final String? imageUrl;
  final String locationName;
  final double? locationLat;
  final double? locationLong;
  final int? maxCapacity;

  const CreateEventRemoteModel({
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

  factory CreateEventRemoteModel.fromParams(CreateEventParams params) {
    return CreateEventRemoteModel(
      eventName: params.eventName,
      eventDate: params.eventDate,
      description: params.description,
      eventType: _eventTypeToApiValue(params.eventType),
      imageUrl: params.imageUrl,
      locationName: params.locationName,
      locationLat: params.locationLat,
      locationLong: params.locationLong,
      maxCapacity: params.maxCapacity,
    );
  }

  static String _eventTypeToApiValue(EventType eventType) => switch (eventType) {
    EventType.party => 'Party',
    EventType.sport => 'Sport',
    EventType.food => 'Food',
    EventType.charity => 'Charity',
    EventType.games => 'Games',
  };

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'eventName': eventName,
      'eventDate': eventDate,
      'description': description,
      'eventType': eventType,
      'location': {
        'name': locationName,
        if (locationLat != null) 'lat': locationLat,
        if (locationLong != null) 'long': locationLong,
      },
    };
    if (imageUrl != null) {
      json['imageUrl'] = imageUrl;
    }
    if (maxCapacity != null) {
      json['maxCapacity'] = maxCapacity;
    }
    return json;
  }
}
