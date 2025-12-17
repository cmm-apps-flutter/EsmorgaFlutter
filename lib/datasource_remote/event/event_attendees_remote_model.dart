class EventAttendeeRemoteModel {
  final String name;

  EventAttendeeRemoteModel({
    required this.name,
  });

  EventAttendeeRemoteModel copyWith({
    String? name,
  }) {
    return EventAttendeeRemoteModel(
      name: name ?? this.name, 
    );
  }

  factory EventAttendeeRemoteModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('name')) {
      throw Exception("Missing mandatory field 'name'");
    }
    return EventAttendeeRemoteModel(
      name: json['name'] as String,
    );
  }
}