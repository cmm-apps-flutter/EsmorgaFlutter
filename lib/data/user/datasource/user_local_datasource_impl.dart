import 'package:esmorga_flutter/data/user/datasource/user_datasource.dart';
import 'package:esmorga_flutter/data/user/model/user_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserLocalDatasourceImpl implements UserDatasource {
  final SharedPreferences sharedPreferences;
  static const String userKey = 'user_data';

  UserLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<UserDataModel> login(String email, String password) async {
    throw UnimplementedError('Local datasource does not support login');
  }

  @override
  Future<void> register(String name, String lastName, String email, String password) async {
    throw UnimplementedError('Local datasource does not support register');
  }

  @override
  Future<UserDataModel> getUser() async {
    final userJson = sharedPreferences.getString(userKey);
    if (userJson == null) {
      throw Exception('No user found in local storage');
    }
    return UserDataModel.fromJson(json.decode(userJson));
  }

  @override
  Future<void> saveUser(UserDataModel user) async {
    await sharedPreferences.setString(userKey, json.encode(user.toJson()));
  }

  @override
  Future<void> deleteUserSession() async {
    await sharedPreferences.remove(userKey);
  }

  @override
  Future<void> emailVerification(String email) async {
    throw UnimplementedError('Local datasource does not support emailVerification');
  }

  @override
  Future<void> recoverPassword(String email) async {
    throw UnimplementedError('Local datasource does not support recoverPassword');
  }

  @override
  Future<UserDataModel> activateAccount(String verificationCode) async {
    throw UnimplementedError('Local datasource does not support activateAccount');
  }

  @override
  Future<void> resetPassword(String code, String password) async {
    throw UnimplementedError('Local datasource does not support resetPassword');
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    throw UnimplementedError('Local datasource does not support changePassword');
  }
}

