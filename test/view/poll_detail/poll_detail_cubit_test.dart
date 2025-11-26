import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/poll/model/poll.dart';
import 'package:esmorga_flutter/domain/poll/usecase/vote_poll_use_case.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_cubit.dart';
import 'package:esmorga_flutter/view/poll_detail/cubit/poll_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVotePollUseCase extends Mock implements VotePollUseCase {}

void main() {
  late MockVotePollUseCase votePollUseCase;

  setUp(() {
    votePollUseCase = MockVotePollUseCase();
  });

  final poll = Poll(
    id: '1',
    name: 'Poll 1',
    description: 'desc',
    options: const [
      PollOption(id: 'opt1', option: 'Option 1', voteCount: 0),
      PollOption(id: 'opt2', option: 'Option 2', voteCount: 0),
    ],
    userSelectedOptionIds: const [],
    voteDeadline: DateTime.now().add(const Duration(days: 1)),
    isMultipleChoice: false,
  );

  final multiPoll = Poll(
    id: '2',
    name: 'Poll 2',
    description: 'desc',
    options: const [
      PollOption(id: 'opt1', option: 'Option 1', voteCount: 0),
      PollOption(id: 'opt2', option: 'Option 2', voteCount: 0),
    ],
    userSelectedOptionIds: const [],
    voteDeadline: DateTime.now().add(const Duration(days: 1)),
    isMultipleChoice: true,
  );

  group('PollDetailCubit', () {
    test('initial state is correct', () {
      final cubit = PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase);
      expect(cubit.state.poll, poll);
      expect(cubit.state.currentSelection, isEmpty);
    });

    blocTest<PollDetailCubit, PollDetailState>(
      'toggleOption selects option in single choice',
      build: () => PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase),
      act: (cubit) => cubit.toggleOption('opt1'),
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'toggleOption switches option in single choice',
      build: () => PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase),
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.toggleOption('opt2');
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt2']),
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'toggleOption adds/removes option in multiple choice',
      build: () => PollDetailCubit(poll: multiPoll, votePollUseCase: votePollUseCase),
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.toggleOption('opt2');
        cubit.toggleOption('opt1');
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1', 'opt2']),
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt2']),
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'vote emits loading then success',
      build: () {
        when(() => votePollUseCase(any(), any())).thenAnswer((_) async => poll);
        return PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase);
      },
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.vote();
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.isLoading, 'loading', true),
        isA<PollDetailState>()
            .having((s) => s.isLoading, 'loading', false)
            .having((s) => s.showSuccessMessage, 'success', true),
      ],
    );

    blocTest<PollDetailCubit, PollDetailState>(
      'vote emits loading then error',
      build: () {
        when(() => votePollUseCase(any(), any())).thenThrow(Exception('error'));
        return PollDetailCubit(poll: poll, votePollUseCase: votePollUseCase);
      },
      act: (cubit) {
        cubit.toggleOption('opt1');
        cubit.vote();
      },
      expect: () => [
        isA<PollDetailState>().having((s) => s.currentSelection, 'selection', ['opt1']),
        isA<PollDetailState>().having((s) => s.isLoading, 'loading', true),
        isA<PollDetailState>().having((s) => s.isLoading, 'loading', false).having((s) => s.error, 'error', isNotNull),
      ],
    );
  });
}
