class EventAttendeeRemoteModel {
  final String name;
  final bool isPaid;

  EventAttendeeRemoteModel({
    required this.name,
    this.isPaid = false,
  });

  EventAttendeeRemoteModel copyWith({
    String? name,
    bool? isPaid,
  }) {
    return EventAttendeeRemoteModel(
      name: name ?? this.name, 
      isPaid: isPaid ?? this.isPaid,
    );
  }

  factory EventAttendeeRemoteModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('name')) {
      throw Exception("Missing mandatory field 'name'");
    }
    return EventAttendeeRemoteModel(
      name: json['name'] as String,
      isPaid: false,
    );
  }
}