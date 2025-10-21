import 'package:esmorga_flutter/data/user/model/user_data_model.dart';

abstract class UserDatasource {
  Future<UserDataModel> login(String email, String password);
  Future<void> register(String name, String lastName, String email, String password);
  Future<UserDataModel> getUser();
  Future<void> saveUser(UserDataModel user);
  Future<void> deleteUserSession();
  Future<void> emailVerification(String email);
  Future<void> recoverPassword(String email);
  Future<UserDataModel> activateAccount(String verificationCode);
  Future<void> resetPassword(String code, String password);
  Future<void> changePassword(String currentPassword, String newPassword);
}

