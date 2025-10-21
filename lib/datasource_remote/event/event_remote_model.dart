import 'package:equatable/equatable.dart';

class EventListWrapperRemoteModel {
  final int remoteTotalEvents;
  final List<EventRemoteModel> remoteEventList;

  EventListWrapperRemoteModel({
    required this.remoteTotalEvents,
    required this.remoteEventList,
  });

  factory EventListWrapperRemoteModel.fromJson(Map<String, dynamic> json) {
    return EventListWrapperRemoteModel(
      remoteTotalEvents: json['totalEvents'],
      remoteEventList: (json['events'] as List).map((e) => EventRemoteModel.fromJson(e)).toList(),
    );
  }
}

class EventRemoteModel extends Equatable{
  final String remoteId;
  final String remoteName;
  final String remoteDate;
  final String remoteDescription;
  final String remoteType;
  final String? remoteImageUrl;
  final EventLocationRemoteModel remoteLocation;
  final List<String> remoteTags;

  const EventRemoteModel({
    required this.remoteId,
    required this.remoteName,
    required this.remoteDate,
    required this.remoteDescription,
    required this.remoteType,
    this.remoteImageUrl,
    required this.remoteLocation,
    required this.remoteTags,
  });

  factory EventRemoteModel.fromJson(Map<String, dynamic> json) {
    return EventRemoteModel(
      remoteId: json['eventId'],
      remoteName: json['eventName'],
      remoteDate: json['eventDate'],
      remoteDescription: json['description'],
      remoteType: json['eventType'],
      remoteImageUrl: json['imageUrl'],
      remoteLocation: EventLocationRemoteModel.fromJson(json['location']),
      remoteTags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }

  @override
  List<Object?> get props => [remoteId, remoteName, remoteDate, remoteDescription, remoteType, remoteImageUrl, remoteLocation, remoteTags];
}

class EventLocationRemoteModel extends Equatable{
  final String remoteLocationName;
  final double? remoteLat;
  final double? remoteLong;

  const EventLocationRemoteModel({
    required this.remoteLocationName,
    this.remoteLat,
    this.remoteLong,
  });

  factory EventLocationRemoteModel.fromJson(Map<String, dynamic> json) {
    return EventLocationRemoteModel(
      remoteLocationName: json['name'],
      remoteLat: json['lat'],
      remoteLong: json['long'],
    );
  }

  @override
  List<Object?> get props => [remoteLocationName, remoteLat, remoteLong];
}
