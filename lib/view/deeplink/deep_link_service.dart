import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  final GoRouter _router;
  late final AppLinks _appLinks;
  StreamSubscription<Uri?>? _sub;
  bool _initialized = false;
  String? _lastCode; // dedup

  DeepLinkService(this._router);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    // app_links doesn't support web. Skip initialization there.
    if (kIsWeb) {
      if (kDebugMode) debugPrint('[DeepLinkService] running on web - app links disabled');
      return;
    }
    _appLinks = AppLinks();

    // Listen for incoming deep links while the app is running.
    try {
      _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
        if (kDebugMode) debugPrint('[DeepLinkService] stream uri: $uri');
        if (uri != null) _handleUri(uri);
      }, onError: (err) {
        if (kDebugMode) debugPrint('[DeepLinkService] stream error: $err');
      });
    } catch (e) {
      if (kDebugMode) debugPrint('[DeepLinkService] Error subscribing to uriLinkStream: $e');
    }
  }

  void _handleUri(Uri uri) {
    final code = uri.queryParameters['forgotPasswordCode'];
    if (kDebugMode) debugPrint('[DeepLinkService] handling uri=$uri, code=$code, lastCode=$_lastCode');
    if (code != null && code.isNotEmpty && code != _lastCode) {
      _lastCode = code;
      if (kDebugMode) debugPrint('[DeepLinkService] navigating to reset-password with code=$code');
      _router.go('/reset-password?code=$code');
    }
  }

  void dispose() {
    // Cancel subscription and allow re-initialization if needed.
    _sub?.cancel();
    _sub = null;
    _initialized = false;
  }
}
