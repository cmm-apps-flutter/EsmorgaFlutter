import 'package:esmorga_flutter/data/user/model/user_data_model.dart';
import 'package:esmorga_flutter/datasource_remote/user/model/user_remote_model.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';

class User {
  final String name;
  final String lastName;
  final String email;
  final RoleType role;

  static const String nameRegex = r"^[a-zA-Z '\-]{3,100}$";
  static const String emailRegex = r"^(?!.{101})[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
  static const String passwordRegex = r"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!-/:-@\[-`{-~]).{8,50}$";

  const User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.role,
  });

  factory User.fromRemoteModel(UserRemoteModel remoteModel) {
    return User(
      name: remoteModel.name,
      lastName: remoteModel.lastName,
      email: remoteModel.email,
      role: RoleTypeExtension.fromString(remoteModel.role),
    );
  }

  factory User.fromDataModel(UserDataModel dataModel) {
    return User(
      name: dataModel.dataName,
      lastName: dataModel.dataLastName,
      email: dataModel.dataEmail,
      role: dataModel.dataRole,
    );
  }

  UserDataModel toDataModel() {
    return UserDataModel(
      dataName: name,
      dataLastName: lastName,
      dataEmail: email,
      dataRole: role,
    );
  }
}
