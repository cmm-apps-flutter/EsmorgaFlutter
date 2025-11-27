class EventAttendeeRemoteModel {
  final String name;

  EventAttendeeRemoteModel({required this.name});

  factory EventAttendeeRemoteModel.fromJson(Map<String, dynamic> json) {
    return EventAttendeeRemoteModel(
      name: json['name'] ?? '',
    );
  }
}