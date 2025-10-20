import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/login/cubit/login_cubit.dart';
import 'package:esmorga_flutter/view/login/cubit/login_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  late _MockUserRepository userRepository;
  late FormValidator validator;
  const testUser = User(name: 'John', lastName: 'Doe', email: 'user@test.com', role: RoleType.user);

  setUp(() {
    userRepository = _MockUserRepository();
    validator = FormValidator();
  });

  group('LoginCubit', () {
    blocTest<LoginCubit, LoginState>(
      'emits submitting then success when credentials valid',
      build: () {
        when(() => userRepository.login(any(), any())).thenAnswer((_) async => testUser);
        final cubit = LoginCubit(userRepository: userRepository, validator: validator)
          ..changeEmail('user@test.com')
          ..changePassword('Passw0rd!');
        return cubit;
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<LoginState>().having((s) => s.status, 'status', LoginStatus.submitting),
        isA<LoginState>().having((s) => s.status, 'status', LoginStatus.success),
      ],
      verify: (_) => verify(() => userRepository.login('user@test.com', 'Passw0rd!')).called(1),
    );

    blocTest<LoginCubit, LoginState>(
      'emits validation errors and does not submit when fields empty',
      build: () => LoginCubit(userRepository: userRepository, validator: validator),
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<LoginState>()
            .having((s) => s.status, 'status', LoginStatus.idle)
            .having((s) => s.emailError, 'emailError', isNotNull)
            .having((s) => s.passwordError, 'passwordError', isNotNull),
      ],
      verify: (_) => verifyNever(() => userRepository.login(any(), any())),
    );

    blocTest<LoginCubit, LoginState>(
      'emits failure when repository throws',
      build: () {
        when(() => userRepository.login(any(), any())).thenThrow(Exception('invalid credentials'));
        final cubit = LoginCubit(userRepository: userRepository, validator: validator)
          ..changeEmail('user@test.com')
          ..changePassword('Passw0rd!');
        return cubit;
      },
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<LoginState>().having((s) => s.status, 'status', LoginStatus.submitting),
        isA<LoginState>()
            .having((s) => s.status, 'status', LoginStatus.failure)
            .having((s) => s.failureMessage, 'failureMessage', contains('invalid credentials')),
      ],
    );
  });
}
