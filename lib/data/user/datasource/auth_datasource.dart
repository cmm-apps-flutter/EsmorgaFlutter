abstract class AuthDatasource {
  String? getAccessToken();
  String? getRefreshToken();
  int getTokenExpirationDate();
  Future<String?> refreshTokens(String refreshToken);
  Future<void> saveTokens(String accessToken, String refreshToken, int expirationDate);
  Future<void> clearTokens();
}

