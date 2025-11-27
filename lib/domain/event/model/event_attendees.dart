
class EventAttendees {
  final int totalUsers;
  final List<String> users;

  EventAttendees({required this.totalUsers, required this.users});

  factory EventAttendees.fromJson(Map<String, dynamic> json) {
    final usersList = (json['users'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];
    return EventAttendees(
      totalUsers: json['totalUsers'] ?? 0,
      users: usersList,
    );
  }
}