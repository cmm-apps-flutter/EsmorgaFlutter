import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/domain_models.dart';

class FlowRepository {
  Future<FlowData> loadFlowData() async {
    final String jsonString = await rootBundle.loadString('assets/flow_data.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return FlowData.fromJson(jsonMap);
  }
}
