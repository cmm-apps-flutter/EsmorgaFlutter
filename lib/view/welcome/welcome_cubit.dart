import 'dart:async';

import 'package:esmorga_flutter/view/welcome/model/welcome_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeCubit extends Cubit<WelcomeUiState> {
  final _effectController = StreamController<WelcomeEffect>.broadcast();
  Stream<WelcomeEffect> get effects => _effectController.stream;

  WelcomeCubit() : super(WelcomeUiState());

  void onPrimaryButtonClicked() {
    _effectController.add(NavigateToLogin());
  }

  void onSecondaryButtonClicked() {
    _effectController.add(NavigateToEventList());
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
