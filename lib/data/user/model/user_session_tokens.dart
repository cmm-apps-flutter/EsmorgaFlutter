class UserSessionTokens {
  final String accessToken;
  final String refreshToken;
  final int expirationDate;

  const UserSessionTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expirationDate,
  });

  factory UserSessionTokens.fromJson(Map<String, dynamic> json) {
    return UserSessionTokens(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expirationDate: json['expirationDate'] as int? ?? 0,
    );
  }
}

