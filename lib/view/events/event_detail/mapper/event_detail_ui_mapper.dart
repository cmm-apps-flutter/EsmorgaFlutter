import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/event_detail/model/event_detail_ui_model.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';

class EventDetailUiMapper {
  static EventDetailUiModel map(
    Event event, {
    required bool isAuthenticated,
    required bool isJoinEnabled,
  }) {
    final dateFormatter = getIt<EsmorgaDateTimeFormatter>();
    final l10n = getIt<LocalizationService>().current;

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
    } else if (isDeadlinePassed || !isJoinEnabled) {
      buttonEnabled = false;
    } else if (isFull) {
      buttonEnabled = event.userJoined;
    } else {
      buttonEnabled = true;
    }

    final String buttonText;
    if (!isAuthenticated) {
      buttonText = l10n.buttonLoginToJoin;
    } else if (isDeadlinePassed) {
      buttonText = l10n.button_join_event_closed;
    } else if (!isJoinEnabled) {
      buttonText = l10n.button_join_event_closed;
    } else if (isFull && !event.userJoined) {
      buttonText = l10n.buttonJoinEventDisabled;
    } else {
      buttonText = event.userJoined
          ? l10n.buttonLeaveEvent
          : l10n.buttonJoinEvent;
    }

    String? rawDeadlineString;
    try {
      if (event.joinDeadline != null) {
        rawDeadlineString = DateTime.fromMillisecondsSinceEpoch(
          event.joinDeadline as int,
        ).toIso8601String();
      }
    } catch (_) {}

    String? formattedDeadline;
    try {
      if (event.joinDeadline != null) {
        formattedDeadline =
            dateFormatter.formatEventDate(event.joinDeadline as int);
      }
    } catch (_) {}

    return EventDetailUiModel(
      id: event.id,
      title: event.name,
      description: event.description,
      date: dateFormatter.formatEventDate(event.date),
      locationName: event.location.name,
      imageUrl: event.imageUrl != null
          ? Uri.decodeComponent(event.imageUrl!)
          : null,
      userJoined: event.userJoined,
      showNavigateButton:
          event.location.lat != null && event.location.long != null,
      currentAttendeeCount: event.currentAttendeeCount,
      maxCapacity: event.maxCapacity,
      joinDeadLine: rawDeadlineString,
      formattedJoinDeadLine: formattedDeadline,

      buttonEnabled: buttonEnabled,
      buttonText: buttonText,
    );
  }
}
