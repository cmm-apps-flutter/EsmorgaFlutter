import 'package:esmorga_flutter/data/user/model/user_data_model.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';

extension UserDataModelMapper on UserDataModel {
  User toUser() {
    return User(
      name: dataName,
      lastName: dataLastName,
      email: dataEmail,
      role: dataRole,
    );
  }
}

