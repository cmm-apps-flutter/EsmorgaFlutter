import 'dart:convert';

import 'package:esmorga_flutter/datasource_remote/config/environment_config.dart';
import 'package:esmorga_flutter/datasource_remote/user/model/user_remote_model.dart';
import 'package:http/http.dart' as http;

class EsmorgaAuthApi {
  final http.Client httpClient;

  String get baseUrl => EnvironmentConfig.currentBaseUrl;

  EsmorgaAuthApi(this.httpClient);

  Future<UserRemoteModel> login(String email, String password) async {
    final result = await httpClient.post(
      Uri.parse('${baseUrl}account/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    if (result.statusCode == 200) {
      return UserRemoteModel.fromJson(json.decode(result.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(String name, String lastName, String email, String password) async {
    final result = await httpClient.post(
      Uri.parse('${baseUrl}account/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
    );
    if (result.statusCode != 201) {
      throw Exception('Failed to register');
    }
  }

  Future<UserRemoteModel> refreshAccessToken(String refreshToken) async {
    final result = await httpClient.post(
      Uri.parse('${baseUrl}account/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'refreshToken': refreshToken,
      }),
    );
    if (result.statusCode == 200) {
      return UserRemoteModel.fromJson(json.decode(result.body));
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<void> emailVerification(String email, String code) async {
    final result = await httpClient.post(
      Uri.parse('${baseUrl}account/email/verification'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    if (result.statusCode != 204) {
      throw Exception('Failed to verify email');
    }
  }

  Future<UserRemoteModel> accountActivation(String code) async {
    final result = await httpClient.put(
      Uri.parse('${baseUrl}account/activate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'verificationCode': code,
      }),
    );
    if (result.statusCode == 200) {
      return UserRemoteModel.fromJson(json.decode(result.body));
    } else {
      throw Exception('Failed to activate account');
    }
  }

  Future<void> recoverPassword(String email) async {
    final result = await httpClient.post(
      Uri.parse('${baseUrl}account/password/forgot-init'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
      }),
    );
    if (result.statusCode != 204) {
      throw Exception('Failed to recover password');
    }
  }

  Future<void> resetPassword(String email, String code, String newPassword) async {
    final result = await httpClient.put(
      Uri.parse('${baseUrl}account/password/forgot-update'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'forgotPasswordCode': code,
        'password': newPassword,
      }),
    );
    if (result.statusCode != 204) {
      throw Exception('Failed to reset password');
    }
  }
}
