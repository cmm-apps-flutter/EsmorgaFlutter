import 'package:esmorga_flutter/domain/poll/model/poll.dart';

class PollListWrapperRemoteModel {
  final int totalPolls;
  final List<PollRemoteModel> polls;

  PollListWrapperRemoteModel({
    required this.totalPolls,
    required this.polls,
  });

  factory PollListWrapperRemoteModel.fromJson(Map<String, dynamic> json) {
    return PollListWrapperRemoteModel(
      totalPolls: json['totalPolls'] as int,
      polls: (json['polls'] as List).map((e) => PollRemoteModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class PollRemoteModel {
  final String pollId;
  final String pollName;
  final String description;
  final List<PollOptionRemoteModel> options;
  final List<String> userSelectedOptions;
  final String voteDeadline;
  final bool isMultipleChoice;

  PollRemoteModel({
    required this.pollId,
    required this.pollName,
    required this.description,
    required this.options,
    required this.userSelectedOptions,
    required this.voteDeadline,
    required this.isMultipleChoice,
  });

  factory PollRemoteModel.fromJson(Map<String, dynamic> json) {
    return PollRemoteModel(
      pollId: json['pollId'] as String,
      pollName: json['pollName'] as String,
      description: json['description'] as String,
      options: (json['options'] as List).map((e) => PollOptionRemoteModel.fromJson(e as Map<String, dynamic>)).toList(),
      userSelectedOptions: (json['userSelectedOptions'] as List).map((e) => e as String).toList(),
      voteDeadline: json['voteDeadline'] as String,
      isMultipleChoice: json['isMultipleChoice'] as bool,
    );
  }

  Poll toDomain() {
    return Poll(
      id: pollId,
      name: pollName,
      description: description,
      options: options.map((e) => e.toDomain()).toList(),
      userSelectedOptionIds: userSelectedOptions,
      voteDeadline: DateTime.parse(voteDeadline),
      isMultipleChoice: isMultipleChoice,
    );
  }
}

class PollOptionRemoteModel {
  final String optionId;
  final String option;
  final int voteCount;

  PollOptionRemoteModel({
    required this.optionId,
    required this.option,
    required this.voteCount,
  });

  factory PollOptionRemoteModel.fromJson(Map<String, dynamic> json) {
    return PollOptionRemoteModel(
      optionId: json['optionId'] as String,
      option: json['option'] as String,
      voteCount: json['voteCount'] as int,
    );
  }

  PollOption toDomain() {
    return PollOption(
      id: optionId,
      option: option,
      voteCount: voteCount,
    );
  }
}
