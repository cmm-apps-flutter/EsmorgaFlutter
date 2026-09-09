import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:esmorga_flutter/domain/event/model/event.dart';
import 'package:esmorga_flutter/data/user/model/user_session_tokens.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';
import 'package:esmorga_flutter/di.dart';

class NativeNavigation {
  static const channel = MethodChannel('my_app/navigation');

  static void setup(GoRouter router) {
    channel.setMethodCallHandler((call) async {

      switch (call.method) {
        case 'openEvent':
          final data = Map<String, dynamic>.from(call.arguments);
          final event = Event.fromJson(data);
          router.push('/event', extra: event);
          break;
        
        case 'saveUserSessionTokens':
          final data = Map<String, dynamic>.from(call.arguments);
          final user = UserSessionTokens.fromJson(data);
          final authRepository = getIt<UserRepository>();
          await authRepository.saveTokens(user.accessToken, user.refreshToken, user.expirationDate);
          break;
        
        case 'removeUserSessionTokens':
          final authRepository = getIt<UserRepository>();
          await authRepository.logout();
          break;
        }
    });
  }

  static Future<void> openNativeScreen() async {
    await channel.invokeMethod('openNativeScreen');
  }
}