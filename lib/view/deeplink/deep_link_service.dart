import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:esmorga_flutter/view/navigation/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class DeepLinkService {
  final GoRouter _router;
  late final AppLinks _appLinks;
  StreamSubscription<Uri?>? _sub;
  bool _initialized = false;

  DeepLinkService(this._router);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    if (kIsWeb) {
      return;
    }
    _appLinks = AppLinks();

    try {
      _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
        if (uri != null) _handleUri(uri);
      }, onError: (err) {});
    } catch (e) {}
  }

  void _handleUri(Uri uri) {
    final code = uri.queryParameters['forgotPasswordCode'];
    final verificationCode = uri.queryParameters['verificationCode'];
    if (verificationCode != null && verificationCode.isNotEmpty) {
      final encoded = Uri.encodeComponent(verificationCode);
      _safeNavigate(AppRoutes.eventList);
      Future.delayed(const Duration(milliseconds: 100), () {
        _safeNavigate('${AppRoutes.verifyAccount}?code=$encoded', usePush: true);
      });
      return;
    }
    if (code != null && code.isNotEmpty) {
      final encoded = Uri.encodeComponent(code);
      _safeNavigate(AppRoutes.eventList);
      Future.delayed(const Duration(milliseconds: 100), () {
        _safeNavigate('${AppRoutes.resetPassword}?code=$encoded', usePush: true);
      });
    }
  }

  void _safeNavigate(String location, {int attempt = 0, bool usePush = false}) {
    try {
      Future.delayed(const Duration(milliseconds: 50), () async {
        try {
          if (usePush) {
            _router.push(location);
          } else {
            _router.go(location);
          }
        } catch (e) {
          // Do nothing
        }
      });
    } catch (e) {
      if (attempt < 5) {
        final delay = Duration(milliseconds: 200 * (attempt + 1));
        Future.delayed(delay, () {
          if (!_initialized) return;
          _safeNavigate(location, attempt: attempt + 1, usePush: usePush);
        });
      } else {}
    }
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _initialized = false;
  }
}
