import 'package:equatable/equatable.dart';

class UserRemoteModel extends Equatable {
  final String name;
  final String lastName;
  final String email;
  final String role; // raw role string (e.g. USER / ADMIN)
  final String accessToken;
  final String refreshToken;
  final int expirationDate;

  const UserRemoteModel({
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
    required this.expirationDate,
  });

  factory UserRemoteModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?; // new nested structure
    // Fallback to root-level (backward compatibility) if profile is absent
    final name = (profile != null ? profile['name'] : json['name']) as String? ?? '';
    final lastName = (profile != null ? profile['lastName'] : json['lastName']) as String? ?? '';
    final email = (profile != null ? profile['email'] : json['email']) as String? ?? '';
    final role = profile?['role'] ?? 'USER';

    return UserRemoteModel(
      name: name,
      lastName: lastName,
      email: email,
      role: role,
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expirationDate: json['expirationDate'] is int
          ? json['expirationDate'] as int
          : int.tryParse('${json['expirationDate']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson({bool nestedProfile = true}) {
    if (nestedProfile) {
      return {
        'profile': {
          'name': name,
          'lastName': lastName,
          'email': email,
          'role': role,
        },
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expirationDate': expirationDate,
      };
    }
    // flat legacy form (if ever needed)
    return {
      'name': name,
      'lastName': lastName,
      'email': email,
      'role': role,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expirationDate': expirationDate,
    };
  }

  @override
  List<Object?> get props => [
        name,
        lastName,
        email,
        role,
        accessToken,
        refreshToken,
        expirationDate,
      ];
}
