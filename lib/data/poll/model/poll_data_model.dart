import 'package:esmorga_flutter/datasource_remote/poll/poll_remote_model.dart';

class PollDataModel {
  final String dataId;
  final String dataName;
  final String dataDescription;
  final List<PollOptionDataModel> dataOptions;
  final List<String> dataUserSelectedOptionIds;
  final int dataVoteDeadline;
  final bool dataIsMultipleChoice;
  final int dataCreationTime;

  const PollDataModel({
    required this.dataId,
    required this.dataName,
    required this.dataDescription,
    required this.dataOptions,
    required this.dataUserSelectedOptionIds,
    required this.dataVoteDeadline,
    required this.dataIsMultipleChoice,
    int? dataCreationTime,
  }) : dataCreationTime = dataCreationTime ?? 0;

  factory PollDataModel.fromRemoteModel(PollRemoteModel remote) {
    return PollDataModel(
      dataId: remote.pollId,
      dataName: remote.pollName,
      dataDescription: remote.description,
      dataOptions: remote.options.map((e) => PollOptionDataModel.fromRemoteModel(e)).toList(),
      dataUserSelectedOptionIds: remote.userSelectedOptions,
      dataVoteDeadline: DateTime.parse(remote.voteDeadline).millisecondsSinceEpoch,
      dataIsMultipleChoice: remote.isMultipleChoice,
      dataCreationTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  PollDataModel copyWith({
    String? dataId,
    String? dataName,
    String? dataDescription,
    List<PollOptionDataModel>? dataOptions,
    List<String>? dataUserSelectedOptionIds,
    int? dataVoteDeadline,
    bool? dataIsMultipleChoice,
    int? dataCreationTime,
  }) {
    return PollDataModel(
      dataId: dataId ?? this.dataId,
      dataName: dataName ?? this.dataName,
      dataDescription: dataDescription ?? this.dataDescription,
      dataOptions: dataOptions ?? this.dataOptions,
      dataUserSelectedOptionIds: dataUserSelectedOptionIds ?? this.dataUserSelectedOptionIds,
      dataVoteDeadline: dataVoteDeadline ?? this.dataVoteDeadline,
      dataIsMultipleChoice: dataIsMultipleChoice ?? this.dataIsMultipleChoice,
      dataCreationTime: dataCreationTime ?? this.dataCreationTime,
    );
  }
}

class PollOptionDataModel {
  final String dataId;
  final String dataOption;
  final int dataVoteCount;

  const PollOptionDataModel({
    required this.dataId,
    required this.dataOption,
    required this.dataVoteCount,
  });

  factory PollOptionDataModel.fromRemoteModel(PollOptionRemoteModel remote) {
    return PollOptionDataModel(
      dataId: remote.optionId,
      dataOption: remote.option,
      dataVoteCount: remote.voteCount,
    );
  }
}
