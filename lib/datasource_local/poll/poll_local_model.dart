import 'package:hive_ce/hive.dart';

part 'poll_local_model.g.dart';

@HiveType(typeId: 2)
class PollLocalModel extends HiveObject {
  @HiveField(0)
  final String localId;

  @HiveField(1)
  final String localName;

  @HiveField(2)
  final String localDescription;

  @HiveField(3)
  final List<PollOptionLocalModel> localOptions;

  @HiveField(4)
  final List<String> localUserSelectedOptionIds;

  @HiveField(5)
  final int localVoteDeadline;

  @HiveField(6)
  final bool localIsMultipleChoice;

  @HiveField(7)
  final int localCreationTime;

  PollLocalModel({
    required this.localId,
    required this.localName,
    required this.localDescription,
    required this.localOptions,
    required this.localUserSelectedOptionIds,
    required this.localVoteDeadline,
    required this.localIsMultipleChoice,
    required this.localCreationTime,
  });
}

@HiveType(typeId: 3)
class PollOptionLocalModel {
  @HiveField(0)
  final String localId;

  @HiveField(1)
  final String localOption;

  @HiveField(2)
  final int localVoteCount;

  PollOptionLocalModel({
    required this.localId,
    required this.localOption,
    required this.localVoteCount,
  });
}
