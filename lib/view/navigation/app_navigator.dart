import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';
import 'package:esmorga_flutter/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppNavigator {
  void toLogin({String? snackbarMessage, bool replace = true});
  void toRegistration({bool replace = false});
  void toRegistrationConfirmation(String email, {bool replace = true});
  void toEventList({bool replace = true});
  void back();
}

class GoRouterAppNavigator implements AppNavigator {
  final GoRouter _router;
  GoRouterAppNavigator(this._router);

  @override
  void toLogin({String? snackbarMessage, bool replace = true}) {
    final uri = Uri(path: AppRoutes.login, queryParameters: {
      if (snackbarMessage != null) 'message': snackbarMessage,
    });
    replace ? _router.go(uri.toString()) : _router.push(uri.toString());
  }

  @override
  void toRegistration({bool replace = false}) =>
      replace ? _router.go(AppRoutes.registration) : _router.push(AppRoutes.registration);

  @override
  void toRegistrationConfirmation(String email, {bool replace = true}) {
    final uri = Uri(path: AppRoutes.registrationConfirmation, queryParameters: {'email': email});
    replace ? _router.go(uri.toString()) : _router.push(uri.toString());
  }

  @override
  void toEventList({bool replace = true}) =>
      replace ? _router.go(AppRoutes.eventList) : _router.push(AppRoutes.eventList);

  @override
  void back() => _router.pop();
}

extension NavX on BuildContext {
  AppNavigator get nav {
    try {
      return RepositoryProvider.of<AppNavigator>(this);
    } catch (_) {
      // Fallback a service locator si aún no se ha inyectado por provider
      return getIt<AppNavigator>();
    }
  }
}
