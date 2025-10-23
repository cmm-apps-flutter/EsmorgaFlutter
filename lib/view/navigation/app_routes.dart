import 'package:esmorga_flutter/di.dart';
import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/view/change_password/view/change_password_screen.dart';
import 'package:esmorga_flutter/view/events/event_detail/cubit/event_detail_cubit.dart';
import 'package:esmorga_flutter/view/events/event_detail/view/event_detail_screen.dart';
import 'package:esmorga_flutter/view/events/event_list/view/event_list_screen.dart';
import 'package:esmorga_flutter/view/events/my_events/view/my_events_screen.dart';
import 'package:esmorga_flutter/view/home/home_screen.dart';
import 'package:esmorga_flutter/view/login/view/login_screen.dart';
import 'package:esmorga_flutter/view/password/recover_password_screen.dart';
import 'package:esmorga_flutter/view/password/reset_password_screen.dart';
import 'package:esmorga_flutter/view/profile/view/profile_screen.dart';
import 'package:esmorga_flutter/view/registration/verify_account/cubit/verify_account_cubit.dart';
import 'package:esmorga_flutter/view/registration/verify_account/view/verify_account_screen.dart';
import 'package:esmorga_flutter/view/registration/view/register_screen.dart';
import 'package:esmorga_flutter/view/registration/view/registration_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:esmorga_flutter/view/splash/view/splash_screen.dart';
import 'package:esmorga_flutter/view/splash/cubit/splash_cubit.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String registrationConfirmation = '/registration-confirmation';
  static const String eventList = '/events';
  static const String myEvents = '/my-events';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  static const String recoverPassword = '/recover-password';
  static const String resetPassword = '/reset-password';
  static const String eventDetail = '/event';
  static const String verifyAccount = '/verify-account';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: splash,
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => BlocProvider(
            create: (_) => getIt<SplashCubit>(),
            child: SplashScreen(onFinished: () => context.go(eventList)),
          ),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => LoginScreen(
            snackbarMessage: state.uri.queryParameters['message'],
            onRegisterClicked: () {
              context.push(registration);
            },
            onForgotPasswordClicked: () {
              context.push(recoverPassword);
            },
            onLoginSuccess: () {
              context.go(eventList);
            },
            onLoginError: () {},
            onBackClicked: () {
              context.pop();
            },
          ),
        ),
        GoRoute(
          path: registration,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: registrationConfirmation,
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return RegistrationConfirmationScreen(
              email: email,
              onBackClicked: () {
                context.pop();
              },
            );
          },
        ),
        GoRoute(
          path: changePassword,
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: recoverPassword,
          builder: (context, state) => const RecoverPasswordScreen(),
        ),
        GoRoute(
          path: resetPassword,
          builder: (context, state) {
            final code = state.uri.queryParameters['code'];
            return ResetPasswordScreen(code: code);
          },
        ),
        GoRoute(
          path: eventDetail,
          builder: (context, state) {
            final event = state.extra as Event;
            return BlocProvider(create: (context) => getIt<EventDetailCubit>(param1: context, param2: event), child: EventDetailScreen());
          },
        ),
        GoRoute(
          path: verifyAccount,
          builder: (context, state) {
            final code = state.uri.queryParameters['code'] ?? '';
            return BlocProvider(
              create: (ctx) => getIt<VerifyAccountCubit>(param1: ctx, param2: code),
              child: VerifyAccountScreen(
                onAccountVerified: () {
                  context.go(eventList);
                },
              ),
            );
          },
        ),
        ShellRoute(
          builder: (context, state, child) => HomeScreen(child: child),
          routes: [
            GoRoute(
              path: eventList,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: EventListScreen(
                  onDetailsClicked: (event) {
                    context.push(AppRoutes.eventDetail, extra: event);
                  },
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            GoRoute(
              path: myEvents,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: MyEventsScreen(
                  onDetailsClicked: (event) {
                    context.push(AppRoutes.eventDetail, extra: event);
                  },
                  onSignInClicked: () {
                    context.push(login);
                  },
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            GoRoute(
              path: profile,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: ProfileScreen(
                  onNavigateToLogin: () {
                    context.push(login);
                  },
                  onNavigateToChangePassword: () {
                    context.push(changePassword);
                  },
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
