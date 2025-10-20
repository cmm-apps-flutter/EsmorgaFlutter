
import 'package:equatable/equatable.dart';
import 'package:esmorga_flutter/view/events/event_list/model/event_list_ui_model.dart';

class EventState extends Equatable {
  final bool loading;
  final List<EventListUiModel> eventList;
  final String? error;
  const EventState({ this.loading = false, this.eventList = const [], this.error });
  @override
  List<Object?> get props => [loading, eventList, error];
}

