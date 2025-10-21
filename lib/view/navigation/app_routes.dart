import 'package:esmorga_flutter/view/change_password/view/change_password_screen.dart';
import 'package:esmorga_flutter/view/events/event_detail/view/event_detail_screen.dart';
import 'package:esmorga_flutter/view/events/event_list/view/event_list_screen.dart';
import 'package:esmorga_flutter/view/events/my_events/view/my_events_screen.dart';
import 'package:esmorga_flutter/view/home/home_screen.dart';
import 'package:esmorga_flutter/view/login/view/login_screen.dart';
import 'package:esmorga_flutter/view/password/recover_password_screen.dart';
import 'package:esmorga_flutter/view/password/reset_password_screen.dart';
import 'package:esmorga_flutter/view/profile/view/profile_screen.dart';
import 'package:esmorga_flutter/view/registration/view/register_screen.dart';
import 'package:esmorga_flutter/view/registration/view/registration_confirmation_screen.dart';
import 'package:esmorga_flutter/view/welcome/welcome_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String welcome = '/';
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

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: welcome,
      routes: [
        GoRoute(
          path: welcome,
          builder: (context, state) => WelcomeScreen(
            onLoginRegisterClicked: () {
              context.push(login);
            },
            onEnterAsGuestClicked: () {
              context.go(eventList);
            },
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
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(welcome);
              }
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
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(welcome);
                }
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
          path: '$eventDetail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EventDetailScreen(eventId: id);
          },
        ),
        ShellRoute(
          builder: (context, state, child) => HomeScreen(child: child),
          routes: [
            GoRoute(
              path: eventList,
              builder: (context, state) => EventListScreen(
                onDetailsClicked: (id) {
                  context.push('${AppRoutes.eventDetail}/$id');
                },
              ),
            ),
            GoRoute(
              path: myEvents,
              builder: (context, state) => const MyEventsScreen(),
            ),
            GoRoute(
              path: profile,
              builder: (context, state) => ProfileScreen(
                onNavigateToLogin: () {
                  context.go(login);
                },
                onNavigateToChangePassword: () {
                  context.push(changePassword);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
