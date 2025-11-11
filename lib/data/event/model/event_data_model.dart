import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';

class EventDataModel {
  final String dataId;
  final String dataName;
  final int dataDate;
  final String dataDescription;
  final String? dataImageUrl;
  final EventLocationDataModel dataLocation;
  final List<String> dataTags;
  final int dataCreationTime;
  final bool dataUserJoined;
  final int dataCurrentAttendeeCount;
  final int? dataMaxCapacity;
  final int? dataJoinDeadLine;

  const EventDataModel({
    required this.dataId,
    required this.dataName,
    required this.dataDate,
    required this.dataDescription,
    this.dataImageUrl,
    required this.dataLocation,
    this.dataTags = const [],
    int? dataCreationTime,
    required this.dataUserJoined,
    required this.dataCurrentAttendeeCount,
    required this.dataMaxCapacity,
    this.dataJoinDeadLine,
  }) : dataCreationTime = dataCreationTime ?? 0;

  factory EventDataModel.fromRemoteModel(EventRemoteModel remote) {
    return EventDataModel(
      dataId: remote.remoteId,
      dataName: remote.remoteName,
      dataDate: _parseDateToMillis(remote.remoteDate),
      dataDescription: remote.remoteDescription,
      dataImageUrl: remote.remoteImageUrl,
      dataLocation: EventLocationDataModel.fromRemoteModel(remote.remoteLocation),
      dataTags: remote.remoteTags,
      dataCreationTime: DateTime.now().millisecondsSinceEpoch,
      dataUserJoined: false,
      dataCurrentAttendeeCount: remote.remoteCurrentAttendeeCount,
      dataMaxCapacity: remote.remoteMaxCapacity,
      dataJoinDeadLine: _parseDateToMillis(remote.remoteJoinDeadLine ?? '')
    );
  }

  EventDataModel copyWith({
    String? dataId,
    String? dataName,
    int? dataDate,
    String? dataDescription,
    String? dataImageUrl,
    EventLocationDataModel? dataLocation,
    List<String>? dataTags,
    int? dataCreationTime,
    bool? dataUserJoined,
    int? dataCurrentAttendeeCount,
    int? dataMaxCapacity,
    int? dataJoinDeadLine,
  }) {
    return EventDataModel(
      dataId: dataId ?? this.dataId,
      dataName: dataName ?? this.dataName,
      dataDate: dataDate ?? this.dataDate,
      dataDescription: dataDescription ?? this.dataDescription,
      dataImageUrl: dataImageUrl ?? this.dataImageUrl,
      dataLocation: dataLocation ?? this.dataLocation,
      dataTags: dataTags ?? this.dataTags,
      dataCreationTime: dataCreationTime ?? this.dataCreationTime,
      dataUserJoined: dataUserJoined ?? this.dataUserJoined,
      dataCurrentAttendeeCount: dataCurrentAttendeeCount ?? this.dataCurrentAttendeeCount,
      dataMaxCapacity: dataMaxCapacity ?? this.dataMaxCapacity,
      dataJoinDeadLine: dataJoinDeadLine ?? this.dataJoinDeadLine,
    );
  }

  static int _parseDateToMillis(String dateStr) {
    try {
      return DateTime.parse(dateStr).millisecondsSinceEpoch;
    } catch (e) {
      return 0;
    }
  }
}

class EventLocationDataModel {
  final String name;
  final double? lat;
  final double? long;

  const EventLocationDataModel({
    required this.name,
    this.lat,
    this.long,
  });

  factory EventLocationDataModel.fromRemoteModel(EventLocationRemoteModel remote) {
    return EventLocationDataModel(
      name: remote.remoteLocationName,
      lat: remote.remoteLat,
      long: remote.remoteLong,
    );
  }
}