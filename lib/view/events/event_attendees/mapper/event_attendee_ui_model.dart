class EventAttendeeUiModel {
  final String name;
  final bool isPaid;

  EventAttendeeUiModel({
    required this.name,
    required this.isPaid,
  });

  EventAttendeeUiModel copyWith({bool? isPaid}) {
    return EventAttendeeUiModel(
      name: name,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}