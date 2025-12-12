
class EventAttendeeDomainModel {
  final String name;
  final bool isPaid;

  EventAttendeeDomainModel({
    required this.name,
    required this.isPaid,
  });

  EventAttendeeDomainModel copyWith({bool? isPaid}) {
    return EventAttendeeDomainModel(
      name: name,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}