import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/dateformatting/esmorga_date_time_formatter.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';

extension EventListUiMapper on Event {
  EventListUiModel toEventUi() {
    final formatter = getIt<EsmorgaDateTimeFormatter>();

    return EventListUiModel(
      id: id,
      imageUrl: imageUrl != null ? Uri.decodeComponent(imageUrl!) : null,
      cardTitle: name,
      cardSubtitle1: formatter.formatEventDate(date),
      cardSubtitle2: location.name,
    );
  }
}

extension EventListUiMapperList on List<Event> {
  List<EventListUiModel> toEventUiList() {
    return map((event) => event.toEventUi()).toList();
  }
}
