import 'package:flutter/material.dart';
import 'data/flow_repository.dart';
import 'models/domain_models.dart';
import 'layout/layout_engine.dart';
import 'view/flow_diagram_screen.dart';

void main() {
  runApp(const FlowVisualizerApp());
}

class FlowVisualizerApp extends StatelessWidget {
  const FlowVisualizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Esmorga Flow Visualizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const FlowLoaderScreen(),
    );
  }
}

class FlowLoaderScreen extends StatelessWidget {
  const FlowLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FlowData>(
      future: FlowRepository().loadFlowData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final layout = LayoutEngine().calculateLayout(data);
          return FlowDiagramScreen(data: data, layout: layout);
        }
        return const Scaffold(body: Center(child: Text('No Data')));
      },
    );
  }
}
