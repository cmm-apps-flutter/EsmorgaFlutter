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
  String? _lastForgotCode;
  String? _lastVerificationCode;

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
    if (verificationCode != null && verificationCode.isNotEmpty && verificationCode != _lastVerificationCode) {
      _lastVerificationCode = verificationCode;
      final encoded = Uri.encodeComponent(verificationCode);
      _safeNavigate('${AppRoutes.verifyAccount}?code=$encoded');
      return;
    }
    if (code != null && code.isNotEmpty && code != _lastForgotCode) {
      _lastForgotCode = code;
      final encoded = Uri.encodeComponent(code);
      _safeNavigate('${AppRoutes.resetPassword}?code=$encoded');
    }
  }

  void _safeNavigate(String location, {int attempt = 0}) {
    try {
      _router.go(location);

      Future.delayed(const Duration(milliseconds: 50), () async {
        try {
          final navCtx = _router.routerDelegate.navigatorKey.currentContext;
          if (navCtx != null) {
            try {
              GoRouter.of(navCtx).go(location);
              return;
            } catch (e) {
              // Do nothing
            }
          }
          try {
            _router.push(location);
          } catch (e) {
            // Do nothing
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
          _safeNavigate(location, attempt: attempt + 1);
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
