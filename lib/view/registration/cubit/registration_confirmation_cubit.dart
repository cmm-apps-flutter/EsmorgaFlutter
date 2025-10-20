import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/registration/cubit/registration_confirmation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationConfirmationCubit extends Cubit<RegistrationConfirmationState> {
  final UserRepository userRepository;

  RegistrationConfirmationCubit({required this.userRepository}) : super(RegistrationConfirmationInitial());

  void openEmailAppRequested() {
    emit(RegistrationConfirmationOpenEmailApp());
    emit(RegistrationConfirmationInitial());
  }

  Future<void> resendEmailRequested(String email) async {
    emit(RegistrationConfirmationResending());
    try {
      await userRepository.emailVerification(email.trim());
      emit(RegistrationConfirmationResendSuccess());
      emit(RegistrationConfirmationInitial());
    } catch (_) {
      emit(RegistrationConfirmationResendFailure());
      emit(RegistrationConfirmationInitial());
    }
  }
}
