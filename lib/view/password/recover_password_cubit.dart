import 'package:bloc/bloc.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/password/recover_password_state.dart';
import 'package:esmorga_flutter/view/validation/form_validator.dart';


class RecoverPasswordCubit extends Cubit<RecoverPasswordState> {
  final UserRepository userRepository;
  final FormValidator validator;

  RecoverPasswordCubit({required this.userRepository, required this.validator}) : super(const RecoverPasswordState());

  bool get _validateEmail => state.emailBlurred || state.attemptedSubmit;

  void onEmailChanged(String email) {
    final error = _validateEmail ? validator.validateEmail(email, acceptsEmpty: false) : null;
    emit(state.copyWith(email: email, emailError: error));
  }

  void onEmailUnfocused() {
    final error = validator.validateEmail(state.email, acceptsEmpty: false);
    emit(state.copyWith(emailBlurred: true, emailError: error));
  }

  Future<void> submit() async {
    final error = validator.validateEmail(state.email, acceptsEmpty: false);
    var newState = state.copyWith(
      attemptedSubmit: true,
      emailBlurred: true,
      emailError: error,
    );
    if (newState.emailError != null) {
      emit(newState);
      return;
    }
    emit(newState.copyWith(status: RecoverPasswordStatus.submitting));
    try {
      await userRepository.recoverPassword(state.email.trim());
      emit(newState.copyWith(status: RecoverPasswordStatus.success));
    } catch (err) {
      final msg = err.toString().toLowerCase();
      final isNetwork = msg.contains('network') || msg.contains('connection');
      emit(newState.copyWith(status: RecoverPasswordStatus.failure, networkFailure: isNetwork));
    }
  }
}
