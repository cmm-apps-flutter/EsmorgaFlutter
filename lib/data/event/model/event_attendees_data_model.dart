class EventAttendeesDataModel {
  final int totalUsers;
  final List<String> users;

  const EventAttendeesDataModel({
    required this.totalUsers,
    required this.users,
  });

  factory EventAttendeesDataModel.fromJson(Map<String, dynamic> json) {
    return EventAttendeesDataModel(
      totalUsers: json["totalUsers"] ?? 0,
      users: (json["users"] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}