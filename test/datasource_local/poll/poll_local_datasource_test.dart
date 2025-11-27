import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/datasource_local/poll/poll_local_datasource.dart';
import 'package:esmorga_flutter/datasource_local/poll/poll_local_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<PollLocalModel> {}

void main() {
  late MockBox box;
  late PollLocalDatasourceImpl datasource;

  setUp(() {
    box = MockBox();
    datasource = PollLocalDatasourceImpl(box);
  });

  final localPoll = PollLocalModel(
    localId: '1',
    localName: 'Poll 1',
    localDescription: 'desc',
    localOptions: const [],
    localUserSelectedOptionIds: const [],
    localVoteDeadline: DateTime.now().millisecondsSinceEpoch,
    localIsMultipleChoice: false,
    localCreationTime: DateTime.now().millisecondsSinceEpoch,
  );

  final pollData = PollDataModel(
    dataId: '1',
    dataName: 'Poll 1',
    dataDescription: 'desc',
    dataOptions: const [],
    dataUserSelectedOptionIds: const [],
    dataVoteDeadline: DateTime.now().millisecondsSinceEpoch,
    dataIsMultipleChoice: false,
    dataCreationTime: DateTime.now().millisecondsSinceEpoch,
  );

  test('getPolls returns mapped data from box', () async {
    when(() => box.values).thenReturn([localPoll]);

    final result = await datasource.getPolls();

    verify(() => box.values).called(1);
    expect(result.length, 1);
    expect(result.first.dataId, localPoll.localId);
  });

  test('cachePolls clears box and puts new data', () async {
    when(() => box.clear()).thenAnswer((_) async => 0);
    when(() => box.putAll(any())).thenAnswer((_) async {});

    await datasource.cachePolls([pollData]);

    verify(() => box.clear()).called(1);
    verify(() => box.putAll(any())).called(1);
  });
}
