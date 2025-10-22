import 'dart:async';

import 'package:bloc/bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future<void> start({Duration duration = const Duration(seconds: 1)}) async {
    await Future.delayed(duration);
    emit(const SplashState.completed());
  }
}

