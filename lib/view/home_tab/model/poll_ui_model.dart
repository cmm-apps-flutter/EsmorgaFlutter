import 'package:equatable/equatable.dart';

class PollUiModel extends Equatable {
  final String id;
  final String title;
  final String deadline;
  final String? imageUrl;

  const PollUiModel({
    required this.id,
    required this.title,
    required this.deadline,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, deadline, imageUrl];
}
