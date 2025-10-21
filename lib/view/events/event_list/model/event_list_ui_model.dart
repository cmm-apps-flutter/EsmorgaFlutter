import 'package:equatable/equatable.dart';

class EventListUiState extends Equatable {
  final bool loading;
  final List<EventListUiModel> eventList;
  final String? error;

  const EventListUiState({
    this.loading = false,
    this.eventList = const [],
    this.error,
  });

  @override
  List<Object?> get props => [loading, eventList, error];
}

class EventListUiModel extends Equatable {
  final String id;
  final String? imageUrl;
  final String cardTitle;
  final String cardSubtitle1;
  final String cardSubtitle2;

  const EventListUiModel({
    required this.id,
    this.imageUrl,
    required this.cardTitle,
    required this.cardSubtitle1,
    required this.cardSubtitle2,
  });

  @override
  List<Object?> get props => [id, imageUrl, cardTitle, cardSubtitle1, cardSubtitle2];
}
