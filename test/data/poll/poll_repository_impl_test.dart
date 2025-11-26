import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/data/poll/poll_datasource.dart';
import 'package:esmorga_flutter/data/poll/poll_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPollDatasource extends Mock implements PollDatasource {}

void main() {
  late MockPollDatasource localDatasource;
  late MockPollDatasource remoteDatasource;
  late PollRepositoryImpl repository;

  setUp(() {
    localDatasource = MockPollDatasource();
    remoteDatasource = MockPollDatasource();
    repository = PollRepositoryImpl(localDatasource, remoteDatasource);
  });

  final freshPoll = PollDataModel(
    dataId: '1',
    dataName: 'Poll 1',
    dataDescription: 'desc',
    dataOptions: const [],
    dataUserSelectedOptionIds: const [],
    dataVoteDeadline: DateTime.now().millisecondsSinceEpoch,
    dataIsMultipleChoice: false,
    dataCreationTime: DateTime.now().millisecondsSinceEpoch, // Fresh
  );

  final stalePoll = PollDataModel(
    dataId: '1',
    dataName: 'Poll 1',
    dataDescription: 'desc',
    dataOptions: const [],
    dataUserSelectedOptionIds: const [],
    dataVoteDeadline: DateTime.now().millisecondsSinceEpoch,
    dataIsMultipleChoice: false,
    dataCreationTime: DateTime.now()
        .subtract(const Duration(hours: 1))
        .millisecondsSinceEpoch, // Stale (assuming cache duration < 1 hour)
  );

  final remotePoll = PollDataModel(
    dataId: '1',
    dataName: 'Poll 1 Remote',
    dataDescription: 'desc',
    dataOptions: const [],
    dataUserSelectedOptionIds: const [],
    dataVoteDeadline: DateTime.now().millisecondsSinceEpoch,
    dataIsMultipleChoice: false,
    dataCreationTime: DateTime.now().millisecondsSinceEpoch,
  );

  group('getPolls', () {
    test('returns local data when available and fresh', () async {
      when(() => localDatasource.getPolls()).thenAnswer((_) async => [freshPoll]);

      final result = await repository.getPolls();

      verify(() => localDatasource.getPolls()).called(1);
      verifyNever(() => remoteDatasource.getPolls());
      expect(result.length, 1);
      expect(result.first.name, freshPoll.dataName);
    });

    test('calls remote when local data is stale', () async {
      when(() => localDatasource.getPolls()).thenAnswer((_) async => [stalePoll]);
      when(() => remoteDatasource.getPolls()).thenAnswer((_) async => [remotePoll]);
      when(() => localDatasource.cachePolls(any())).thenAnswer((_) async {});

      final result = await repository.getPolls();

      verify(() => localDatasource.getPolls()).called(1);
      verify(() => remoteDatasource.getPolls()).called(1);
      verify(() => localDatasource.cachePolls([remotePoll])).called(1);
      expect(result.length, 1);
      expect(result.first.name, remotePoll.dataName);
    });

    test('calls remote when local data is empty', () async {
      when(() => localDatasource.getPolls()).thenAnswer((_) async => []);
      when(() => remoteDatasource.getPolls()).thenAnswer((_) async => [remotePoll]);
      when(() => localDatasource.cachePolls(any())).thenAnswer((_) async {});

      final result = await repository.getPolls();

      verify(() => localDatasource.getPolls()).called(1);
      verify(() => remoteDatasource.getPolls()).called(1);
      verify(() => localDatasource.cachePolls([remotePoll])).called(1);
      expect(result.length, 1);
      expect(result.first.name, remotePoll.dataName);
    });

    test('calls remote when forceRefresh is true', () async {
      when(() => localDatasource.getPolls()).thenAnswer((_) async => [freshPoll]);
      when(() => remoteDatasource.getPolls()).thenAnswer((_) async => [remotePoll]);
      when(() => localDatasource.cachePolls(any())).thenAnswer((_) async {});

      final result = await repository.getPolls(forceRefresh: true);

      verify(() => localDatasource.getPolls()).called(1);
      verify(() => remoteDatasource.getPolls()).called(1);
      expect(result.first.name, remotePoll.dataName);
    });

    test('returns local when forceLocal is true, even if stale', () async {
      when(() => localDatasource.getPolls()).thenAnswer((_) async => [stalePoll]);

      final result = await repository.getPolls(forceLocal: true);

      verify(() => localDatasource.getPolls()).called(1);
      verifyNever(() => remoteDatasource.getPolls());
      expect(result.first.name, stalePoll.dataName);
    });
  });
}
