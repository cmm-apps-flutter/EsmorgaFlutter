import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/password/reset_password_cubit.dart';
import 'package:esmorga_flutter/view/password/reset_password_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  late _MockUserRepository userRepository;
  late FormValidator validator;

  setUp(() {
    userRepository = _MockUserRepository();
    validator = FormValidator();
  });

  group('ResetPasswordCubit', () {
    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits submitting then success when reset succeeds',
      build: () {
        when(() => userRepository.resetPassword(any(), any()))
            .thenAnswer((_) async {});
        return ResetPasswordCubit(
            userRepository: userRepository, validator: validator, code: 'ABC');
      },
      act: (cubit) async {
        cubit.onNewChanged('NewPass1!');
        cubit.onRepeatChanged('NewPass1!');
        await cubit.submit();
      },
      skip: 2,
      expect: () => [
        isA<ResetPasswordState>()
            .having((s) => s.status, 'status', ResetPasswordStatus.submitting),
        isA<ResetPasswordState>()
            .having((s) => s.status, 'status', ResetPasswordStatus.success),
      ],
      verify: (_) =>
          verify(() => userRepository.resetPassword('ABC', 'NewPass1!'))
              .called(1),
    );

    blocTest<ResetPasswordCubit, ResetPasswordState>(
      'emits validation errors when passwords invalid and does not submit',
      build: () => ResetPasswordCubit(
          userRepository: userRepository, validator: validator, code: 'ABC'),
      act: (cubit) async {
        await cubit.submit();
      },
      expect: () => [
        isA<ResetPasswordState>()
            .having((s) => s.status, 'status', ResetPasswordStatus.idle)
            .having((s) => s.newError, 'newError', isNotNull),
      ],
      verify: (_) =>
          verifyNever(() => userRepository.resetPassword(any(), any())),
    );
  });
}
