import 'dart:convert';

import 'package:esmorga_flutter/datasource_remote/config/environment_config.dart';
import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';
import 'package:http/http.dart' as http;

class EsmorgaGuestApi {
  final http.Client httpClient;
  String get baseUrl => EnvironmentConfig.currentBaseUrl;

  EsmorgaGuestApi(this.httpClient);

  Future<List<EventRemoteModel>> getEvents() async {
    final result = await httpClient.get(Uri.parse('${baseUrl}events'));
    if (result.statusCode == 200) {
      final eventListWrapper = EventListWrapperRemoteModel.fromJson(json.decode(result.body));
      return eventListWrapper.remoteEventList;
    } else {
      throw Exception('Failed to load events');
    }
  }
}

