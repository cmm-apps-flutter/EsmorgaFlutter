import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_cubit.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_effect.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
  });

  test('verifyAccount success emits loading state and NavigateToHomeEffect', () async {
    final code = '552529';
    when(() => mockRepo.activateAccount(code)).thenAnswer((_) async => Future<void>.value());

    final cubit = VerifyAccountCubit(userRepository: mockRepo, verificationCode: code);

    final effects = <VerifyAccountEffect>[];
    final effSub = cubit.effectStream.listen(effects.add);

    final states = <VerifyAccountState>[];
    final stateSub = cubit.stream.listen(states.add);

    await cubit.verifyAccount();
    await Future<void>.delayed(Duration.zero);

    expect(states, contains(isA<VerifyAccountLoading>()));
    expect(effects, isNotEmpty);
    expect(effects.first, isA<NavigateToHomeEffect>());

    await effSub.cancel();
    await stateSub.cancel();
    await cubit.close();
  });

  test('verifyAccount failure emits loading state and no NavigateToHomeEffect', () async {
    final code = '552529';
    when(() => mockRepo.activateAccount(code)).thenThrow(Exception('boom'));

    final cubit = VerifyAccountCubit(userRepository: mockRepo, verificationCode: code);

    final effects = <VerifyAccountEffect>[];
    final effSub = cubit.effectStream.listen(effects.add);

    final states = <VerifyAccountState>[];
    final stateSub = cubit.stream.listen(states.add);

    await cubit.verifyAccount();
    await Future<void>.delayed(Duration.zero);

    expect(states, contains(isA<VerifyAccountLoading>()));
    expect(effects, isEmpty);

    await effSub.cancel();
    await stateSub.cancel();
    await cubit.close();
  });
}
