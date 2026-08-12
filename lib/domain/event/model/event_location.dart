class EventLocation {
  final String name;
  final double? lat;
  final double? long;

  factory EventLocation.fromJson(Map<String, dynamic> json) {
    return EventLocation(
      name: json['name'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
    );
  }

  const EventLocation({
    required this.name,
    this.lat,
    this.long,
  });
}

