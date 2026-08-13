import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:esmorga_flutter/domain/event/model/event.dart';

class NativeNavigation {
  static const channel = MethodChannel('my_app/navigation');

  static void setup(GoRouter router) {
    channel.setMethodCallHandler((call) async {
      if (call.method == 'openEvent') {
        final data = Map<String, dynamic>.from(call.arguments);

        final event = Event.fromJson(data);

        router.push(
          '/event',
          extra: event,
        );
      }
    });
  }

  static Future<void> openNativeScreen() async {
    await channel.invokeMethod('openNativeScreen');
  }
}