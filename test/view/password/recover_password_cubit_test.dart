import 'package:bloc_test/bloc_test.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/l10n/app_localizations_en.dart';
import 'package:esmorga_flutter/view/l10n/localization_service.dart';
import 'package:esmorga_flutter/view/password/recover_password_cubit.dart';
import 'package:esmorga_flutter/view/password/recover_password_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepository extends Mock implements UserRepository {}
class _MockLocalizationService extends Mock implements LocalizationService {}

void main() {
  late _MockUserRepository userRepository;
  late FormValidator validator;
  final l10n = AppLocalizationsEn();
  late _MockLocalizationService mockL10nService;
  setUp(() {
    userRepository = _MockUserRepository();
    mockL10nService = _MockLocalizationService();
    getIt.registerSingleton<LocalizationService>(mockL10nService);
    when(() => mockL10nService.current).thenReturn(l10n);
    validator = FormValidator();
  });

  tearDown(() {
    getIt.reset();
  });

  group('RecoverPasswordCubit', () {
    blocTest<RecoverPasswordCubit, RecoverPasswordState>(
      'emits submitting then success when recovery succeeds',
      build: () {
        when(() => userRepository.recoverPassword(any())).thenAnswer((_) async {});
        return RecoverPasswordCubit(userRepository: userRepository, validator: validator);
      },
      act: (cubit) async {
        cubit.onEmailChanged('user@test.com');
        await cubit.submit();
      },
      skip: 1,
      expect: () => [
        isA<RecoverPasswordState>().having((s) => s.status, 'status', RecoverPasswordStatus.submitting),
        isA<RecoverPasswordState>().having((s) => s.status, 'status', RecoverPasswordStatus.success),
      ],
      verify: (_) => verify(() => userRepository.recoverPassword('user@test.com')).called(1),
    );

    blocTest<RecoverPasswordCubit, RecoverPasswordState>(
      'emits failure with network flag when network error',
      build: () {
        when(() => userRepository.recoverPassword(any())).thenThrow(Exception('network failure'));
        return RecoverPasswordCubit(userRepository: userRepository, validator: validator);
      },
      act: (cubit) async {
        cubit.onEmailChanged('user@test.com');
        await cubit.submit();
      },
      skip: 1,
      expect: () => [
        isA<RecoverPasswordState>().having((s) => s.status, 'status', RecoverPasswordStatus.submitting),
        isA<RecoverPasswordState>().having((s) => s.status, 'status', RecoverPasswordStatus.failure).having((s) => s.networkFailure, 'networkFailure', true),
      ],
    );
  });
}
