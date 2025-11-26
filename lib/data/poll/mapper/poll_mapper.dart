import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';

extension PollDataModelMapper on PollDataModel {
  Poll toDomain() {
    return Poll(
      id: dataId,
      name: dataName,
      description: dataDescription,
      options: dataOptions.map((e) => e.toDomain()).toList(),
      userSelectedOptionIds: dataUserSelectedOptionIds,
      voteDeadline: DateTime.fromMillisecondsSinceEpoch(dataVoteDeadline),
      isMultipleChoice: dataIsMultipleChoice,
    );
  }
}

extension PollOptionDataModelMapper on PollOptionDataModel {
  PollOption toDomain() {
    return PollOption(
      id: dataId,
      option: dataOption,
      voteCount: dataVoteCount,
    );
  }
}

extension PollDataModelListMapper on List<PollDataModel> {
  List<Poll> toDomainList() {
    return map((dataModel) => dataModel.toDomain()).toList();
  }
}

extension PollMapper on Poll {
  PollDataModel toDataModel() {
    return PollDataModel(
      dataId: id,
      dataName: name,
      dataDescription: description,
      dataOptions: options.map((e) => e.toDataModel()).toList(),
      dataUserSelectedOptionIds: userSelectedOptionIds,
      dataVoteDeadline: voteDeadline.millisecondsSinceEpoch,
      dataIsMultipleChoice: isMultipleChoice,
      dataCreationTime: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

extension PollOptionMapper on PollOption {
  PollOptionDataModel toDataModel() {
    return PollOptionDataModel(
      dataId: id,
      dataOption: option,
      dataVoteCount: voteCount,
    );
  }
}
