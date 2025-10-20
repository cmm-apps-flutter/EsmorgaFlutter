import 'package:esmorga_flutter/data/user/datasource/auth_datasource.dart';
import 'package:esmorga_flutter/datasource_remote/api/authorization_constants.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAuthDatasource implements AuthDatasource {
  final SharedPreferences _sharedPreferences;
  final EsmorgaAuthApi _authApi;

  SharedPreferencesAuthDatasource(this._sharedPreferences, this._authApi);

  @override
  String? getAccessToken() {
    return _sharedPreferences.getString(AuthorizationConstants.sharedAuthTokenKey);
  }

  @override
  String? getRefreshToken() {
    return _sharedPreferences.getString(AuthorizationConstants.sharedRefreshTokenKey);
  }

  @override
  int getTokenExpirationDate() {
    return _sharedPreferences.getInt(AuthorizationConstants.sharedTokenExpirationDateKey) ?? 0;
  }

  @override
  Future<String?> refreshTokens(String refreshToken) async {
    try {
      final userRemoteModel = await _authApi.refreshAccessToken(refreshToken);
      await saveTokens(
        userRemoteModel.accessToken,
        userRemoteModel.refreshToken,
        userRemoteModel.expirationDate,
      );
      return userRemoteModel.accessToken;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken, int expirationDate) async {
    await _sharedPreferences.setString(AuthorizationConstants.sharedAuthTokenKey, accessToken);
    await _sharedPreferences.setString(AuthorizationConstants.sharedRefreshTokenKey, refreshToken);
    await _sharedPreferences.setInt(AuthorizationConstants.sharedTokenExpirationDateKey, expirationDate);
  }

  @override
  Future<void> clearTokens() async {
    await _sharedPreferences.remove(AuthorizationConstants.sharedAuthTokenKey);
    await _sharedPreferences.remove(AuthorizationConstants.sharedRefreshTokenKey);
    await _sharedPreferences.remove(AuthorizationConstants.sharedTokenExpirationDateKey);
  }
}

