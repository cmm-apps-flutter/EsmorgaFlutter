import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

/// Entry point for the flow generator.
void main() async {
  print('Generating Flow Data...');

  // 1. Define Paths
  final projectRoot = Directory.current.path;
  final routesFile = p.join(projectRoot, 'lib/view/navigation/app_routes.dart');
  final goldensDir = p.join(projectRoot, 'test/metadata/en-US/images/phoneScreenshots');
  final outputPath = p.join(projectRoot, 'tool/flow_visualizer/assets/flow_data.json');

  if (!File(routesFile).existsSync()) {
    print('Error: Routes file not found at $routesFile');
    return;
  }

  // 2. Parse AppRoutes to extract graph data
  final flowData = await _parseRoutes(routesFile);

  // 3. Scan for Golden Images
  _enrichWithGoldens(flowData, goldensDir);

  // 4. Write to JSON
  final encoder = JsonEncoder.withIndent('  ');
  final outputFile = File(outputPath);
  outputFile.createSync(recursive: true);
  outputFile.writeAsStringSync(encoder.convert(flowData));

  print('Flow Data generated at $outputPath');
}

Future<Map<String, dynamic>> _parseRoutes(String routesPath) async {
  final file = File(routesPath);
  final result = parseString(content: file.readAsStringSync());

  final visitor = AppRoutesVisitor();
  result.unit.visitChildren(visitor);

  return {
    'nodes': visitor.nodes,
    'edges': visitor.edges,
  };
}

void _enrichWithGoldens(Map<String, dynamic> data, String goldensDir) {
  final nodes = data['nodes'] as List<dynamic>;

  // Manual Mapping for routes that don't match directory names directly
  final manualMapping = {
    '/home/events': 'home_tab',
    '/feature/event': 'event_detail',
    '/feature/poll': 'poll_detail',
    '/feature/event_attendees/:eventId': 'event_attendees',
    '/auth/registration': 'register',
    '/onboarding/splash': 'splash',
    '/auth/login': 'login',
    '/auth/registration-confirmation': 'registration_confirmation',
    '/auth/change-password': 'change_password',
    '/auth/recover-password': 'recover_password',
    '/auth/reset-password': 'reset_password',
    '/auth/verify-account': 'verify_account',
    '/home/my-events': 'my_events',
    '/home/profile': 'profile',
    // add others if needed
  };

  for (var node in nodes) {
    final routeName = node['id'] as String;

    String cleanName;
    if (manualMapping.containsKey(routeName)) {
      cleanName = manualMapping[routeName]!;
    } else {
      // Default cleaning: remove leading slash, replace hyphens and colons with underscores
      cleanName = routeName.replaceAll('/', '');
      cleanName = cleanName.replaceAll('-', '_');
      cleanName = cleanName.replaceAll(':', '_');

      if (cleanName.isEmpty) cleanName = 'splash'; // Root is usually splash in our app, or handle explicitly
    }

    // Heuristic: Match route name to folder
    // e.g. route '/login' -> 'login' folder or 'login' in filename

    final nodeScreenshots = <String, String>{};

    // 1. Check for directory match in phoneScreenshots
    // e.g. .../phoneScreenshots/login/
    final dirPath = p.join(goldensDir, cleanName);

    if (Directory(dirPath).existsSync()) {
      final files = Directory(dirPath)
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.png') && f.path.contains('android')) // Prefer android for consistency
          .toList();

      for (var f in files) {
        final filename = p.basename(f.path).toLowerCase();
        // derive state
        // e.g. login_filled_android.png
        // remove cleanName, remove _android.png
        var state = filename.replaceAll(cleanName, '').replaceAll('_android.png', '').replaceAll('.png', '');

        if (state.startsWith('_')) state = state.substring(1);
        if (state.isEmpty) state = 'initial';

        // Use relative path from flow_visualizer/assets/
        // Flatten structure: copy to tool/flow_visualizer/assets/goldens/<filename>

        final destDir = p.join(Directory.current.path, 'tool/flow_visualizer/assets/goldens');
        Directory(destDir).createSync(recursive: true);
        final destPath = p.join(destDir, p.basename(f.path));
        f.copySync(destPath);

        nodeScreenshots[state] = 'assets/goldens/${p.basename(f.path)}';
      }
    } else {
      print('Warning: No golden directory found for route: $routeName (looked for: $cleanName)');
    }

    node['screenshots'] = nodeScreenshots;
    node['group'] = _assignGroup(routeName);
  }
}

String _assignGroup(String routeId) {
  if (routeId.startsWith('/onboarding')) return 'Onboarding';
  if (routeId.startsWith('/auth')) return 'Auth';
  if (routeId.startsWith('/home')) return 'Home';
  if (routeId.startsWith('/feature')) return 'Feature';
  return 'Other';
}

class AppRoutesVisitor extends GeneralizingAstVisitor<void> {
  final List<Map<String, dynamic>> nodes = [];
  final List<Map<String, dynamic>> edges = [];
  final Map<String, String> constants = {}; // Map<VariableName, Value>

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    // Extract static consts
    if (node.isStatic) {
      for (var variable in node.fields.variables) {
        if (variable.initializer is StringLiteral) {
          constants[variable.name.lexeme] = (variable.initializer as StringLiteral).stringValue ?? '';
        }
      }
    }
    super.visitFieldDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    print('Visiting Method: ${node.name.lexeme}');
    super.visitMethodDeclaration(node);
  }

  @override
  void visitListLiteral(ListLiteral node) {
    print('Visiting ListLiteral (length ${node.elements.length})');
    super.visitListLiteral(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final name = node.methodName.name;
    print('Visiting MethodInvocation: $name'); // DEBUG
    if (name == 'GoRoute' || name == 'ShellRoute') {
      print('Processing Route from MethodInvocation: $name'); // DEBUG
      _processRouteArguments(node.argumentList, name);
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    // Check for GoRoute or ShellRoute
    final typeName = node.constructorName.type.toSource();
    print('Found InstanceCreation: $typeName'); // DEBUG
    if (typeName == 'GoRoute' || typeName == 'ShellRoute') {
      print('Processing Route from InstanceCreation: $typeName'); // DEBUG
      _processRouteArguments(node.argumentList, typeName);
    }
    super.visitInstanceCreationExpression(node);
  }

  void _processRouteArguments(ArgumentList argumentList, String typeName) {
    String? path;
    String? name;

    // precise argument extraction
    for (var arg in argumentList.arguments) {
      if (arg is NamedExpression) {
        if (arg.name.label.name == 'path') {
          path = _resolveStringExpression(arg.expression);
        } else if (arg.name.label.name == 'name') {
          name = _resolveStringExpression(arg.expression);
        }
      }
    }

    if (typeName == 'ShellRoute') {
      // ShellRoute might not have a path, use a generated ID
      path = path ?? 'shell_${nodes.length}';
    }

    if (path != null) {
      nodes.add({
        'id': path,
        'label': name ?? path,
        'type': typeName,
      });

      NamedExpression? builderArg;
      for (var arg in argumentList.arguments.whereType<NamedExpression>()) {
        final argName = arg.name.label.name;
        if (argName == 'builder' || argName == 'pageBuilder') {
          builderArg = arg;
          break;
        }
      }

      if (builderArg != null) {
        _scanBuilder(path!, builderArg.expression);
      }
    }
  }

  String _resolveStringExpression(Expression expression) {
    if (expression is StringLiteral) {
      return expression.stringValue ?? '';
    } else if (expression is SimpleIdentifier) {
      // Look up in constants
      return constants[expression.name] ?? expression.name;
    } else if (expression is PrefixedIdentifier) {
      // e.g. AppRoutes.login
      return constants[expression.identifier.name] ?? expression.identifier.name;
    }
    return expression.toSource(); // Fallback
  }

  void _scanBuilder(String sourceNodeId, Expression builderExpression) {
    // Visit the function body to find context.go / context.push
    final edgeVisitor = NavigationVisitor(sourceNodeId, this);
    builderExpression.visitChildren(edgeVisitor);
  }
}

class NavigationVisitor extends RecursiveAstVisitor<void> {
  final String sourceNodeId;
  final AppRoutesVisitor parent;

  NavigationVisitor(this.sourceNodeId, this.parent);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final method = node.methodName.name;
    if (method == 'go' || method == 'push') {
      // Check if target is 'context' (simple check)
      if (node.target != null && node.target.toString().contains('context')) {
        if (node.argumentList.arguments.isNotEmpty) {
          final destArg = node.argumentList.arguments.first;
          final destination = parent._resolveStringExpression(destArg);

          if (destination.isNotEmpty) {
            parent.edges.add({
              'from': sourceNodeId,
              'to': destination,
              'label': method, // go or push
            });
          }
        }
      }
    }
    super.visitMethodInvocation(node);
  }
}
