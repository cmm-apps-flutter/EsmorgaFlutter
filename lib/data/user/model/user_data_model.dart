import 'package:esmorga_flutter/domain/user/model/role_type.dart';

class UserDataModel {
  final String dataName;
  final String dataLastName;
  final String dataEmail;
  final RoleType dataRole;

  const UserDataModel({
    required this.dataName,
    required this.dataLastName,
    required this.dataEmail,
    required this.dataRole,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      dataName: json['name'] ?? '',
      dataLastName: json['lastName'] ?? '',
      dataEmail: json['email'] ?? '',
      dataRole: RoleTypeExtension.fromString(json['role'] ?? 'user'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': dataName,
      'lastName': dataLastName,
      'email': dataEmail,
      'role': dataRole.toJson(),
    };
  }
}

