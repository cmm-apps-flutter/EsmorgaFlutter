class EventAttendeeRemoteModel {
  final String name;

  EventAttendeeRemoteModel({required this.name});

  factory EventAttendeeRemoteModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('name')) {
      throw Exception("Missing mandatory field 'name'");
    }
    return EventAttendeeRemoteModel(
      name: json['name'] as String,
    );
  }
}