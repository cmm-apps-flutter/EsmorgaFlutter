class FlowDefinition {
  final String id;
  final String name;
  final String entryScreenId;
  final String exitType;
  final List<String> screenIds;

  FlowDefinition({
    required this.id,
    required this.name,
    required this.entryScreenId,
    required this.exitType,
    required this.screenIds,
  });

  factory FlowDefinition.fromJson(Map<String, dynamic> json) {
    return FlowDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      entryScreenId: json['entryScreenId'] as String,
      exitType: json['exitType'] as String,
      screenIds: (json['screenIds'] as List).cast<String>(),
    );
  }
}

class ScreenDefinition {
  final String id;
  final String name;
  final String? screenshot;

  ScreenDefinition({required this.id, required this.name, this.screenshot});

  factory ScreenDefinition.fromJson(Map<String, dynamic> json) {
    return ScreenDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      screenshot: json['screenshot'] as String?,
    );
  }
}

class FlowScreen {
  final String id;
  final String flowId;
  final String screenId;
  final String? role;

  FlowScreen({required this.id, required this.flowId, required this.screenId, this.role});

  factory FlowScreen.fromJson(Map<String, dynamic> json) {
    return FlowScreen(
      id: json['id'] as String,
      flowId: json['flowId'] as String,
      screenId: json['screenId'] as String,
      role: json['role'] as String?,
    );
  }
}

class FlowTransition {
  final String id;
  final String flowId;
  final String fromScreenId;
  final String toScreenId;
  final String label;

  FlowTransition({
    required this.id,
    required this.flowId,
    required this.fromScreenId,
    required this.toScreenId,
    required this.label,
  });

  factory FlowTransition.fromJson(Map<String, dynamic> json) {
    return FlowTransition(
      id: json['id'] as String,
      flowId: json['flowId'] as String,
      fromScreenId: json['fromScreenId'] as String,
      toScreenId: json['toScreenId'] as String,
      label: json['label'] as String,
    );
  }
}

class FlowData {
  final List<FlowDefinition> flows;
  final List<ScreenDefinition> screens;
  final List<FlowScreen> flowScreens;
  final List<FlowTransition> transitions;

  FlowData({required this.flows, required this.screens, required this.flowScreens, required this.transitions});

  factory FlowData.fromJson(Map<String, dynamic> json) {
    return FlowData(
      flows: (json['flows'] as List).map((e) => FlowDefinition.fromJson(e)).toList(),
      screens: (json['screens'] as List).map((e) => ScreenDefinition.fromJson(e)).toList(),
      flowScreens: (json['flowScreens'] as List).map((e) => FlowScreen.fromJson(e)).toList(),
      transitions: (json['transitions'] as List).map((e) => FlowTransition.fromJson(e)).toList(),
    );
  }
}
