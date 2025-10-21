import 'package:esmorga_flutter/data/user/datasource/auth_datasource.dart';
import 'package:esmorga_flutter/data/user/datasource/user_datasource.dart';
import 'package:esmorga_flutter/data/user/model/user_data_model.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_api.dart';
import 'package:esmorga_flutter/datasource_remote/api/esmorga_auth_api.dart';
import 'package:esmorga_flutter/domain/user/model/role_type.dart';

class UserRemoteDatasourceImpl implements UserDatasource {
  final EsmorgaAuthApi authApi;
  final EsmorgaApi api;
  final AuthDatasource authDatasource;

  UserRemoteDatasourceImpl(this.authApi, this.api, this.authDatasource);

  @override
  Future<UserDataModel> login(String email, String password) async {
    final userRemoteModel = await authApi.login(email, password);

    await authDatasource.saveTokens(
      userRemoteModel.accessToken,
      userRemoteModel.refreshToken,
      userRemoteModel.expirationDate,
    );

    return UserDataModel(
      dataName: userRemoteModel.name,
      dataLastName: userRemoteModel.lastName,
      dataEmail: userRemoteModel.email,
      dataRole: RoleType.user,
    );
  }

  @override
  Future<void> register(String name, String lastName, String email, String password) async {
    await authApi.register(name, lastName, email, password);
  }

  @override
  Future<UserDataModel> getUser() async {
    throw UnimplementedError('Remote datasource does not support getUser');
  }

  @override
  Future<void> saveUser(UserDataModel user) async {}

  @override
  Future<void> deleteUserSession() async {
    await authDatasource.clearTokens();
  }

  @override
  Future<void> emailVerification(String email) async {
    await authApi.emailVerification(email, '');
  }

  @override
  Future<void> recoverPassword(String email) async {
    await authApi.recoverPassword(email);
  }

  @override
  Future<UserDataModel> activateAccount(String verificationCode) async {
    final userRemoteModel = await authApi.accountActivation(verificationCode);

    await authDatasource.saveTokens(
      userRemoteModel.accessToken,
      userRemoteModel.refreshToken,
      userRemoteModel.expirationDate,
    );

    return UserDataModel(
      dataName: userRemoteModel.name,
      dataLastName: userRemoteModel.lastName,
      dataEmail: userRemoteModel.email,
      dataRole: RoleTypeExtension.fromString(userRemoteModel.role),
    );
  }

  @override
  Future<void> resetPassword(String code, String password) async {
    await authApi.resetPassword('', code, password);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await api.changePassword(currentPassword, newPassword);
  }
}
