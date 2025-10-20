import 'package:esmorga_flutter/data/event/event_datasource.dart';
import 'package:esmorga_flutter/data/user/datasource/auth_datasource.dart';
import 'package:esmorga_flutter/data/user/datasource/user_datasource.dart';
import 'package:esmorga_flutter/data/user/mapper/user_mapper.dart';
import 'package:esmorga_flutter/domain/user/model/user.dart';
import 'package:esmorga_flutter/domain/user/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource localDatasource;
  final UserDatasource remoteDatasource;
  final EventDatasource localEventDatasource;
  final AuthDatasource authDatasource;

  UserRepositoryImpl(
    this.localDatasource,
    this.remoteDatasource,
    this.localEventDatasource,
    this.authDatasource,
  );

  @override
  Future<User> login(String email, String password) async {
    final userDataModel = await remoteDatasource.login(email, password);
    await localDatasource.saveUser(userDataModel);
    await localEventDatasource.deleteCacheEvents();

    return userDataModel.toUser();
  }

  @override
  Future<void> register(String name, String lastName, String email, String password) async {
    await remoteDatasource.register(name, lastName, email, password);
  }

  @override
  Future<User> getUser() async {
    final userDataModel = await localDatasource.getUser();
    return userDataModel.toUser();
  }

  @override
  Future<void> emailVerification(String email) async {
    await remoteDatasource.emailVerification(email);
  }

  @override
  Future<void> logout() async {
    try {
      await localDatasource.deleteUserSession();
      await remoteDatasource.deleteUserSession();
      await localEventDatasource.deleteCacheEvents();
    } catch (e) {
      throw Exception('Error logging out: ${e.toString()}');
    }
  }

  @override
  Future<void> recoverPassword(String email) async {
    await remoteDatasource.recoverPassword(email);
  }

  @override
  Future<void> activateAccount(String verificationCode) async {
    final userDataModel = await remoteDatasource.activateAccount(verificationCode);
    await localDatasource.saveUser(userDataModel);
    await localEventDatasource.deleteCacheEvents();
  }

  @override
  Future<void> resetPassword(String code, String password) async {
    await remoteDatasource.resetPassword(code, password);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await remoteDatasource.changePassword(currentPassword, newPassword);
  }
}

