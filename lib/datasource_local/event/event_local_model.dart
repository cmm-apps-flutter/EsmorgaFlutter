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
  final String localType;

  @HiveField(5)
  final String? localImageUrl;

  @HiveField(6)
  final EventLocationLocalModel localLocation;

  @HiveField(7)
  final List<String> localTags;

  @HiveField(8)
  final int localCreationTime;

  @HiveField(9)
  final bool localUserJoined;

  EventLocalModel({
    required this.localId,
    required this.localName,
    required this.localDate,
    required this.localDescription,
    required this.localType,
    this.localImageUrl,
    required this.localLocation,
    required this.localTags,
    required this.localCreationTime,
    required this.localUserJoined,
  });
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

