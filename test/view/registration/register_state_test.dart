import 'package:esmorga_flutter/view/registration/cubit/register_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterState.copyWith retain behavior', () {
    test('retains nameError when parameter omitted', () {
      const initial = RegisterState(nameError: 'Required');
      expect(initial.copyWith().nameError, 'Required');
    });

    test('retains lastNameError when parameter omitted', () {
      const initial = RegisterState(lastNameError: 'Required');
      expect(initial.copyWith().lastNameError, 'Required');
    });

    test('retains emailError when parameter omitted', () {
      const initial = RegisterState(emailError: 'Invalid email');
      expect(initial.copyWith().emailError, 'Invalid email');
    });

    test('retains passwordError when parameter omitted', () {
      const initial = RegisterState(passwordError: 'Too weak');
      expect(initial.copyWith().passwordError, 'Too weak');
    });

    test('retains repeatPasswordError when parameter omitted', () {
      const initial = RegisterState(repeatPasswordError: 'No match');
      expect(initial.copyWith().repeatPasswordError, 'No match');
    });

    test('retains failureMessage when parameter omitted', () {
      const initial = RegisterState(failureMessage: 'Server error');
      expect(initial.copyWith().failureMessage, 'Server error');
    });

    test('retains successEmail when parameter omitted', () {
      const initial = RegisterState(successEmail: 'user@test.com');
      expect(initial.copyWith().successEmail, 'user@test.com');
    });
  });

  group('RegisterState.withValidationResult', () {
    const base = RegisterState(
      nameError: 'old',
      lastNameError: 'old',
      emailError: 'old',
      passwordError: 'old',
      repeatPasswordError: 'old',
    );

    test('clears nameError when null is passed', () {
      expect(
        base.withValidationResult(
          nameError: null,
          lastNameError: base.lastNameError,
          emailError: base.emailError,
          passwordError: base.passwordError,
          repeatPasswordError: base.repeatPasswordError,
        ).nameError,
        isNull,
      );
    });

    test('replaces emailError with new value', () {
      expect(
        base.withValidationResult(
          nameError: base.nameError,
          lastNameError: base.lastNameError,
          emailError: 'New error',
          passwordError: base.passwordError,
          repeatPasswordError: base.repeatPasswordError,
        ).emailError,
        'New error',
      );
    });

    test('clears all error fields when null is passed for each', () {
      final result = base.withValidationResult(
        nameError: null,
        lastNameError: null,
        emailError: null,
        passwordError: null,
        repeatPasswordError: null,
      );
      expect(result.nameError, isNull);
      expect(result.lastNameError, isNull);
      expect(result.emailError, isNull);
      expect(result.passwordError, isNull);
      expect(result.repeatPasswordError, isNull);
    });
  });

  group('RegisterState.clearErrors', () {
    test('clears failureMessage when requested', () {
      const initial = RegisterState(failureMessage: 'Server error');
      expect(initial.clearErrors(failureMessage: true).failureMessage, isNull);
    });

    test('retains failureMessage when not requested', () {
      const initial = RegisterState(failureMessage: 'Server error');
      expect(initial.clearErrors().failureMessage, 'Server error');
    });

    test('clears successEmail when requested', () {
      const initial = RegisterState(successEmail: 'user@test.com');
      expect(initial.clearErrors(successEmail: true).successEmail, isNull);
    });
  });
}
