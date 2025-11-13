import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/domain/event/model/event_location.dart';

class EventDetailUiModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String locationName;
  final String? imageUrl;
  final bool userJoined;
  final bool showNavigateButton;
  final int? maxCapacity;
  final int currentAttendeeCount;
  final String? joinDeadLine;
  final String? formattedJoinDeadLine;

  EventDetailUiModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.locationName,
    this.imageUrl,
    required this.userJoined,
    required this.showNavigateButton,
    required this.currentAttendeeCount,
    this.maxCapacity,
    this.joinDeadLine,
    this.formattedJoinDeadLine,
  });

  Event toDomain() {
    return Event(
      id: id, 
      name: title,
      date: 0,
      description: description,
      imageUrl: imageUrl,
      location: EventLocation(name: locationName), 
      tags: [],
      userJoined: userJoined,
      currentAttendeeCount: currentAttendeeCount,
      maxCapacity: maxCapacity,
    );
  }
}

extension EventMappers on Event {
  EventDetailUiModel toEventDetailUiModel() {
    String? rawDeadlineString;
    if (joinDeadline != null) {
      try {
        final int timestamp = joinDeadline as int;
        rawDeadlineString = DateTime.fromMillisecondsSinceEpoch(timestamp).toIso8601String();
      } catch (e) {
        rawDeadlineString = null;
      }
    }
    
    String? formattedDeadline;
    if (joinDeadline != null) {
      try {
        final int timestamp = joinDeadline as int;
        formattedDeadline = getIt<EsmorgaDateTimeFormatter>().formatEventDate(timestamp);
      } catch (e) {
        formattedDeadline = null;
      }
    }

    return EventDetailUiModel(
      id: id,
      title: name,
      description: description,
      date: getIt<EsmorgaDateTimeFormatter>().formatEventDate(date),
      locationName: location.name,
      userJoined: userJoined,
      imageUrl: imageUrl != null ? Uri.decodeComponent(imageUrl!) : null,
      showNavigateButton: location.lat != null && location.long != null,
      currentAttendeeCount: currentAttendeeCount,
      maxCapacity: maxCapacity,
      joinDeadLine: rawDeadlineString,
      formattedJoinDeadLine: formattedDeadline,
    );
  }
}