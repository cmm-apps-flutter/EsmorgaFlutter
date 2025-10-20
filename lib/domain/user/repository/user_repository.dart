import 'package:esmorga_flutter/domain/user/model/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<void> register(String name, String lastName, String email, String password);
  Future<User> getUser();
  Future<void> emailVerification(String email);
  Future<void> logout();
  Future<void> recoverPassword(String email);
  Future<void> activateAccount(String verificationCode);
  Future<void> resetPassword(String code, String password);
  Future<void> changePassword(String currentPassword, String newPassword);
}

