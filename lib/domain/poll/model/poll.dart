import 'package:equatable/equatable.dart';

class Poll extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<PollOption> options;
  final List<String> userSelectedOptionIds;
  final DateTime voteDeadline;
  final bool isMultipleChoice;

  const Poll({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.options,
    required this.userSelectedOptionIds,
    required this.voteDeadline,
    required this.isMultipleChoice,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        options,
        userSelectedOptionIds,
        voteDeadline,
        isMultipleChoice,
      ];
}

class PollOption extends Equatable {
  final String id;
  final String option;
  final int voteCount;

  const PollOption({
    required this.id,
    required this.option,
    required this.voteCount,
  });

  @override
  List<Object?> get props => [id, option, voteCount];
}
