import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_effect.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyAccountCubit extends Cubit<VerifyAccountState> {
  final UserRepository userRepository;
  final String verificationCode;

  final _effectController = StreamController<VerifyAccountEffect>();
  Stream<VerifyAccountEffect> get effectStream => _effectController.stream;

  VerifyAccountCubit({required this.userRepository, required this.verificationCode}) : super(VerifyAccountInitial());

  Future<void> verifyAccount() async {
    if (kDebugMode) debugPrint('[VerifyAccountCubit] verifyAccount() start code=$verificationCode');
    emit(VerifyAccountLoading());
    try {
      await userRepository.activateAccount(verificationCode);
      if (kDebugMode) debugPrint('[VerifyAccountCubit] activateAccount succeeded for code=$verificationCode');
      _emitEffect(NavigateToHomeEffect());
    } catch (e, st) {
      if (kDebugMode) debugPrint('[VerifyAccountCubit] activateAccount failed: $e\n$st');
      final msg = e.toString().toLowerCase();
      if (msg.contains('network') || msg.contains('connection')) {
        // emit(VerifyAccountNoNetwork());
      } else {
        // emit(VerifyAccountFailure(e.toString()));
      }
    }
  }

  void _emitEffect(VerifyAccountEffect effect) => _effectController.add(effect);

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }

}
