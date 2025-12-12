import 'package:hive_ce/hive.dart';

part 'event_local_model.g.dart';

@HiveType(typeId: 0)
class EventLocalModel extends HiveObject {
  @HiveField(0)
  final String localId;

  @HiveField(1)
  final String localName;

  @HiveField(2)
  final int localDate;

  @HiveField(3)
  final String localDescription;

  @HiveField(4)
  final String? localImageUrl;

  @HiveField(5)
  final EventLocationLocalModel localLocation;

  @HiveField(6)
  final List<String> localTags;

  @HiveField(7)
  final int localCreationTime;

  @HiveField(8)
  final bool localUserJoined;

  @HiveField(9)
  final int localCurrentAttendeeCount;

  @HiveField(10)
  final int? localMaxCapacity;

  @HiveField(11)
  final int localJoinDeadline;

  @HiveField(12)
  List<EventAttendeeLocalModel> attendees;

  EventLocalModel({
    required this.localId,
    required this.localName,
    required this.localDate,
    required this.localDescription,
    this.localImageUrl,
    required this.localLocation,
    required this.localTags,
    required this.localCreationTime,
    required this.localUserJoined,
    required this.localCurrentAttendeeCount,
    required this.localMaxCapacity,
    required this.localJoinDeadline,
    required this.attendees,
  }){ this.attendees = attendees ?? []; }
}

@HiveType(typeId: 1)
class EventLocationLocalModel {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double? lat;

  @HiveField(2)
  final double? long;

  EventLocationLocalModel({
    required this.name,
    this.lat,
    this.long,
  });
}

@HiveType(typeId: 4) 
class EventAttendeeLocalModel {
  @HiveField(0)
  final String userName;

  @HiveField(1)
  final bool isPaid;

  EventAttendeeLocalModel({
    required this.userName,
    required this.isPaid,
  });
}