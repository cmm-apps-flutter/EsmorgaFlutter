import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_cubit.dart';
import 'package:esmorga_flutter/view/change_password/cubit/change_password_state.dart';
import 'package:esmorga_flutter/view/change_password/change_password_strings.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
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

  group('ChangePasswordCubit', () {
    blocTest<ChangePasswordCubit, ChangePasswordState>(
      skip: 4,
      'emits submitting and then success when change succeeds',
      build: () {
        when(() => userRepository.changePassword(any(), any()))
            .thenAnswer((_) async {});
        return ChangePasswordCubit(
          userRepository: userRepository,
          validator: validator,
        );
      },
      act: (cubit) async {
        cubit.onCurrentChanged('Current1!');
        cubit.onNewChanged('NewPass1!');
        cubit.onRepeatChanged('NewPass1!');
        await cubit.submit();
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ChangePasswordSuccess>()
            .having((s) => s.messageKey, 'messageKey', ChangePasswordStrings.passwordChangedSuccess),
      ],
      verify: (_) =>
          verify(() => userRepository.changePassword('Current1!', 'NewPass1!'))
              .called(1),
    );

    blocTest<ChangePasswordCubit, ChangePasswordState>(
      skip: 4,
      'emits submitting and then error with network failure when network error occurs',
      build: () {
        when(() => userRepository.changePassword(any(), any()))
            .thenThrow(Exception('network issue'));
        return ChangePasswordCubit(
          userRepository: userRepository,
          validator: validator,
        );
      },
      act: (cubit) async {
        cubit.onCurrentChanged('Current1!');
        cubit.onNewChanged('NewPass1!');
        cubit.onRepeatChanged('NewPass1!');
        await cubit.submit();
      },
      expect: () => [
        isA<ChangePasswordEditing>()
            .having((s) => s.isSubmitting, 'isSubmitting', true),
        isA<ChangePasswordError>()
            .having((s) => s.failure, 'failure', ChangePasswordFailure.network),
        isA<ChangePasswordEditing>()
            .having((s) => s.isSubmitting, 'isSubmitting', false),
      ],
    );
  });
}
