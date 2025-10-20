import 'package:esmorga_flutter/data/user/datasource/auth_datasource.dart';
import 'package:esmorga_flutter/datasource_remote/api/authorization_constants.dart';
import 'package:http/http.dart' as http;

class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _innerClient;
  final AuthDatasource _authDatasource;

  AuthenticatedHttpClient(this._innerClient, this._authDatasource);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final modifiedRequest = await _addAuthHeader(request);
    final response = await _innerClient.send(modifiedRequest);

    if (response.statusCode == 401) {
      return await _handleUnauthorized(request);
    }

    return response;
  }

  Future<http.BaseRequest> _addAuthHeader(http.BaseRequest request) async {
    var accessToken = _authDatasource.getAccessToken();
    final ttl = _authDatasource.getTokenExpirationDate();

    if (ttl < DateTime.now().millisecondsSinceEpoch) {
      final refreshToken = _authDatasource.getRefreshToken();
      if (refreshToken != null) {
        accessToken = await _authDatasource.refreshTokens(refreshToken);
      }
    }

    if (accessToken != null) {
      final modifiedRequest = _copyRequest(request);
      modifiedRequest.headers[AuthorizationConstants.authorizationHeaderKey] =
          AuthorizationConstants.authorizationHeaderValue.replaceFirst('%s', accessToken);
      return modifiedRequest;
    }

    return request;
  }

  Future<http.StreamedResponse> _handleUnauthorized(http.BaseRequest originalRequest) async {
    final refreshToken = _authDatasource.getRefreshToken();
    if (refreshToken == null) {
      return http.StreamedResponse(
        Stream.value([]),
        401,
        request: originalRequest,
      );
    }

    final newAccessToken = await _authDatasource.refreshTokens(refreshToken);
    if (newAccessToken == null) {
      return http.StreamedResponse(
        Stream.value([]),
        401,
        request: originalRequest,
      );
    }

    final modifiedRequest = _copyRequest(originalRequest);
    modifiedRequest.headers[AuthorizationConstants.authorizationHeaderKey] =
        AuthorizationConstants.authorizationHeaderValue.replaceFirst('%s', newAccessToken);

    return await _innerClient.send(modifiedRequest);
  }

  http.BaseRequest _copyRequest(http.BaseRequest request) {
    http.BaseRequest newRequest;

    if (request is http.Request) {
      newRequest = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is http.MultipartRequest) {
      newRequest = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is http.StreamedRequest) {
      throw Exception('StreamedRequest cannot be copied');
    } else {
      throw Exception('Unknown request type');
    }

    newRequest.headers.addAll(request.headers);
    return newRequest;
  }
}

