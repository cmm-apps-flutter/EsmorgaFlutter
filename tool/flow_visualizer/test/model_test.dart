import 'package:flutter_test/flutter_test.dart';
import 'package:flow_visualizer/models/domain_models.dart';

void main() {
  testWidgets('FlowRepository deserializes JSON correctly', (WidgetTester tester) async {
    // We can't easily mock rootBundle in a unit test without some setup,
    // but we can test the fromJson logic which is the critical part.

    final sampleJson = {
      "flows": [
        {
          "id": "flow_auth",
          "name": "AUTH",
          "entryScreenId": "screen_login",
          "exitType": "close",
          "screenIds": ["screen_login", "screen_register"],
        },
      ],
      "screens": [
        {"id": "screen_login", "name": "Login"},
        {"id": "screen_register", "name": "Register"},
      ],
      "flowScreens": [
        {"id": "fs_1", "flowId": "flow_auth", "screenId": "screen_login", "role": "entry"},
      ],
      "transitions": [
        {
          "id": "t1",
          "flowId": "flow_auth",
          "fromScreenId": "screen_login",
          "toScreenId": "screen_register",
          "label": "Next",
        },
      ],
    };

    final data = FlowData.fromJson(sampleJson);

    expect(data.flows.length, 1);
    expect(data.flows.first.name, "AUTH");
    expect(data.screens.length, 2);
    expect(data.flowScreens.first.role, "entry");
    expect(data.transitions.first.label, "Next");
  });
}
