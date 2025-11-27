import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/poll_repository.dart';
import 'package:esmorga_flutter/domain/poll/usecase/vote_poll_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPollRepository extends Mock implements PollRepository {}

void main() {
  late MockPollRepository repository;
  late VotePollUseCase useCase;

  setUp(() {
    repository = MockPollRepository();
    useCase = VotePollUseCase(repository);
  });

  final poll = Poll(
    id: '1',
    name: 'Poll 1',
    description: 'desc',
    options: const [],
    userSelectedOptionIds: const [],
    voteDeadline: DateTime.now(),
    isMultipleChoice: false,
  );

  test('should call repository votePoll', () async {
    when(() => repository.votePoll(any(), any())).thenAnswer((_) async => poll);

    final result = await useCase('1', ['opt1']);

    verify(() => repository.votePoll('1', ['opt1'])).called(1);
    expect(result, poll);
  });
}
