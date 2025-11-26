import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/datasource_local/poll/poll_local_model.dart';

extension PollLocalModelMapper on PollLocalModel {
  PollDataModel toPollDataModel() {
    return PollDataModel(
      dataId: localId,
      dataName: localName,
      dataDescription: localDescription,
      dataOptions: localOptions.map((e) => e.toPollOptionDataModel()).toList(),
      dataUserSelectedOptionIds: localUserSelectedOptionIds,
      dataVoteDeadline: localVoteDeadline,
      dataIsMultipleChoice: localIsMultipleChoice,
      dataCreationTime: localCreationTime,
    );
  }
}

extension PollOptionLocalModelMapper on PollOptionLocalModel {
  PollOptionDataModel toPollOptionDataModel() {
    return PollOptionDataModel(
      dataId: localId,
      dataOption: localOption,
      dataVoteCount: localVoteCount,
    );
  }
}

extension PollDataModelToLocalMapper on PollDataModel {
  PollLocalModel toPollLocalModel() {
    return PollLocalModel(
      localId: dataId,
      localName: dataName,
      localDescription: dataDescription,
      localOptions: dataOptions.map((e) => e.toPollOptionLocalModel()).toList(),
      localUserSelectedOptionIds: dataUserSelectedOptionIds,
      localVoteDeadline: dataVoteDeadline,
      localIsMultipleChoice: dataIsMultipleChoice,
      localCreationTime: dataCreationTime,
    );
  }
}

extension PollOptionDataModelToLocalMapper on PollOptionDataModel {
  PollOptionLocalModel toPollOptionLocalModel() {
    return PollOptionLocalModel(
      localId: dataId,
      localOption: dataOption,
      localVoteCount: dataVoteCount,
    );
  }
}

extension PollLocalModelListMapper on List<PollLocalModel> {
  List<PollDataModel> toPollDataModelList() {
    return map((localModel) => localModel.toPollDataModel()).toList();
  }
}

extension PollDataModelListToLocalMapper on List<PollDataModel> {
  List<PollLocalModel> toPollLocalModelList() {
    return map((dataModel) => dataModel.toPollLocalModel()).toList();
  }
}
