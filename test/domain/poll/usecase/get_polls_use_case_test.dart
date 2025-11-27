import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/poll_repository.dart';
import 'package:esmorga_flutter/domain/poll/usecase/get_polls_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPollRepository extends Mock implements PollRepository {}

void main() {
  late MockPollRepository repository;
  late GetPollsUseCase useCase;

  setUp(() {
    repository = MockPollRepository();
    useCase = GetPollsUseCase(repository);
  });

  final poll1 = Poll(
    id: '1',
    name: 'Poll 1',
    description: 'desc',
    options: const [],
    userSelectedOptionIds: const [],
    voteDeadline: DateTime(2025, 1, 2), // Later
    isMultipleChoice: false,
  );

  final poll2 = Poll(
    id: '2',
    name: 'Poll 2',
    description: 'desc',
    options: const [],
    userSelectedOptionIds: const [],
    voteDeadline: DateTime(2025, 1, 1), // Earlier
    isMultipleChoice: false,
  );

  test('should call repository and return sorted polls', () async {
    // Arrange
    when(() => repository.getPolls()).thenAnswer((_) async => [poll1, poll2]);

    // Act
    final result = await useCase();

    // Assert
    verify(() => repository.getPolls()).called(1);
    expect(result, [poll2, poll1]); // Sorted by deadline
  });
}
