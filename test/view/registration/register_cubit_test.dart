import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_cubit.dart';
import 'package:esmorga_flutter/view/registration/cubit/register_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _StubValidator extends FormValidator {
  _StubValidator() : super();

  @override
  String? validateName(String value, {bool acceptsEmpty = true}) => value.isEmpty && !acceptsEmpty ? 'empty' : null;

  @override
  String? validateLastName(String value, {bool acceptsEmpty = true}) => value.isEmpty && !acceptsEmpty ? 'empty' : null;

  @override
  String? validateEmail(String value, {bool acceptsEmpty = true}) => value.isEmpty && !acceptsEmpty ? 'empty' : null;

  @override
  String? validatePassword(String value, {bool acceptsEmpty = true}) => value.isEmpty && !acceptsEmpty ? 'empty' : null;

  @override
  String? validateRepeatPassword(String value, String? comparisonField, {bool acceptsEmpty = true}) {
    if (!acceptsEmpty && value.isEmpty) return 'empty';
    if (value.isNotEmpty && value != comparisonField) return 'mismatch';
    return null;
  }
}

class _MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late _MockUserRepository userRepository;
  late FormValidator validator;
  late LocalizationService mockL10nService;

  setUp(() {
    userRepository = _MockUserRepository();
    mockL10nService = _MockLocalizationService();
    getIt.registerSingleton<LocalizationService>(mockL10nService);
    when(() => mockL10nService.current).thenReturn(AppLocalizationsEn());
    validator = _StubValidator();
  });

  tearDown(() {
    getIt.reset();
  });
  group('RegisterCubit', () {
    const name = 'John';
    const lastName = 'Doe';
    const email = 'john@doe.com';
    const password = 'Pass1234!';

    blocTest<RegisterCubit, RegisterState>(
      'emits submitting then success when register succeeds',
      build: () {
        when(() => userRepository.register(any(), any(), any(), any())).thenAnswer((_) async {});
        return RegisterCubit(userRepository: userRepository, validator: validator);
      },
      act: (cubit) {
        cubit.onNameChanged(name);
        cubit.onLastNameChanged(lastName);
        cubit.onEmailChanged(email);
        cubit.onPasswordChanged(password);
        cubit.onRepeatPasswordChanged(password);
        cubit.submit();
      },
      skip: 5,
      expect: () => [
        isA<RegisterState>().having((s) => s.status, 'status', RegisterStatus.submitting),
        isA<RegisterState>().having((s) => s.status, 'status', RegisterStatus.success).having((s) => s.successEmail, 'successEmail', email),
      ],
      verify: (_) => verify(() => userRepository.register(name, lastName, email, password)).called(1),
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits submitting then failure when register throws',
      build: () {
        when(() => userRepository.register(any(), any(), any(), any())).thenThrow(Exception('network error'));
        return RegisterCubit(userRepository: userRepository, validator: validator);
      },
      act: (cubit) {
        cubit.onNameChanged(name);
        cubit.onLastNameChanged(lastName);
        cubit.onEmailChanged(email);
        cubit.onPasswordChanged(password);
        cubit.onRepeatPasswordChanged(password);
        cubit.submit();
      },
      skip: 5,
      expect: () => [
        isA<RegisterState>().having((s) => s.status, 'status', RegisterStatus.submitting),
        isA<RegisterState>().having((s) => s.status, 'status', RegisterStatus.failure).having((s) => s.failureMessage, 'failureMessage', contains('network error')),
      ],
      verify: (_) => verify(() => userRepository.register(name, lastName, email, password)).called(1),
    );

    blocTest<RegisterCubit, RegisterState>(
      'emits validation errors and does not submit when required fields empty',
      build: () => RegisterCubit(userRepository: userRepository, validator: validator),
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<RegisterState>().having((s) => s.status, 'status', RegisterStatus.idle).having((s) => s.nameError, 'nameError', isNotNull).having((s) => s.emailError, 'emailError', isNotNull),
      ],
      verify: (_) => verifyNever(() => userRepository.register(any(), any(), any(), any())),
    );
  });
}
