import 'dart:io';

import 'package:esmorga_flutter/datasource_remote/config/environment_config.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
}

class OneSignalNotificationService implements NotificationService {
  bool _initialized = false;

  OneSignalNotificationService();

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    if (kDebugMode) OneSignal.Debug.setLogLevel(OSLogLevel.warn);
    OneSignal.initialize(EnvironmentConfig.oneSignalAppId);
    OneSignal.Notifications.addForegroundWillDisplayListener(_onForegroundNotification);

    final packageInfo = await PackageInfo.fromPlatform();
    await OneSignal.User.addTags({
      'environment': EnvironmentConfig.current.environment.name,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'version': packageInfo.version,
    });
  }

  @override
  Future<bool> requestPermission() => OneSignal.Notifications.requestPermission(false);

  void _onForegroundNotification(OSNotificationWillDisplayEvent event) {
    _logNotification('foreground', event.notification);
    event.notification.display();
  }

  void _logNotification(String source, OSNotification notification) {
    if (!kDebugMode) return;
    debugPrint('[OneSignal] $source title=${notification.title} '
        'body=${notification.body} data=${notification.additionalData}');
  }
}