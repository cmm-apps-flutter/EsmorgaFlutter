import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/event_detail/model/event_detail_ui_model.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';

class EventDetailUiMapper {
  static EventDetailUiModel map(
    Event event, {
    required bool isAuthenticated,
    required LocalizationService l10n,
  }) {
    final dateFormatter = getIt<EsmorgaDateTimeFormatter>();

    bool isDeadlinePassed = false;
    if (event.joinDeadline != null) {
      try {
        isDeadlinePassed = DateTime.now().millisecondsSinceEpoch >
            (event.joinDeadline as int);
      } catch (_) {}
    }

    final isFull = event.maxCapacity != null &&
        event.currentAttendeeCount >= event.maxCapacity!;

    final bool buttonEnabled;
    if (!isAuthenticated) {
      buttonEnabled = true;
    } else if (isDeadlinePassed) {
      buttonEnabled = false;
    } else if (isFull) {
      buttonEnabled = event.userJoined;
    } else {
      buttonEnabled = true;
    }

    final String buttonText;
    if (!isAuthenticated) {
      buttonText = l10n.current.buttonLoginToJoin;
    } else if (isDeadlinePassed) {
      buttonText = l10n.current.button_join_event_closed;
    } else if (isFull && !event.userJoined) {
      buttonText = l10n.current.buttonJoinEventDisabled;
    } else {
      buttonText = event.userJoined
          ? l10n.current.buttonLeaveEvent
          : l10n.current.buttonJoinEvent;
    }

    return EventDetailUiModel(
      id: event.id,
      title: event.name,
      description: event.description,
      date: dateFormatter.formatEventDate(event.date),
      eventDate: DateTime.fromMillisecondsSinceEpoch(event.date),
      locationName: event.location.name,
      imageUrl: event.imageUrl != null
          ? Uri.decodeComponent(event.imageUrl!)
          : null,
      userJoined: event.userJoined,
      showNavigateButton:
          event.location.lat != null && event.location.long != null,
      currentAttendeeCount: event.currentAttendeeCount,
      maxCapacity: event.maxCapacity,
      joinDeadLine: event.joinDeadline != null
          ? DateTime.fromMillisecondsSinceEpoch(event.joinDeadline as int)
              .toIso8601String()
          : null,
      formattedJoinDeadLine: event.joinDeadline != null
          ? dateFormatter.formatEventDate(event.joinDeadline!)
          : dateFormatter.formatEventDate(event.date),
      buttonEnabled: buttonEnabled,
      buttonText: buttonText,
    );
  }
}