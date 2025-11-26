import 'package:esmorga_flutter/data/poll/model/poll_data_model.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_api.dart';
import 'package:esmorga_flutter/datasource_remote/poll/poll_remote_datasource.dart';
import 'package:esmorga_flutter/datasource_remote/poll/poll_remote_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEsmorgaApi extends Mock implements EsmorgaApi {}

void main() {
  late MockEsmorgaApi api;
  late PollRemoteDatasourceImpl datasource;

  setUp(() {
    api = MockEsmorgaApi();
    datasource = PollRemoteDatasourceImpl(api);
  });

  final remotePoll = PollRemoteModel(
    pollId: '1',
    pollName: 'Poll 1',
    description: 'desc',
    options: const [],
    userSelectedOptions: const [],
    voteDeadline: '2025-01-01T00:00:00.000Z',
    isMultipleChoice: false,
  );

  test('getPolls calls api and maps to data model', () async {
    when(() => api.getPolls()).thenAnswer((_) async => [remotePoll]);

    final result = await datasource.getPolls();

    verify(() => api.getPolls()).called(1);
    expect(result.length, 1);
    expect(result.first, isA<PollDataModel>());
    expect(result.first.dataId, remotePoll.pollId);
    expect(result.first.dataName, remotePoll.pollName);
  });
}
