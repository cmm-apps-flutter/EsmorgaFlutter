import 'dart:convert';

import 'package:esmorga_flutter/datasource_remote/event/event_remote_model.dart';
import 'package:http/http.dart' as http;

class EsmorgaApi {
  static const String baseUrl = 'https://qa.esmorga.canarte.org/v1/';
  static const String getEventsEndpoint = 'events';


  Future<List<EventRemoteModel>> getEvents() async {
    final result = await http.get(Uri.parse('$baseUrl$getEventsEndpoint'));
    if(result.statusCode == 200){
      final eventListWrapper = EventListWrapperRemoteModel.fromJson(json.decode(result.body));
      return eventListWrapper.remoteEventList;
    } else {
      throw Exception('Failed to load events');
    }
  }
}