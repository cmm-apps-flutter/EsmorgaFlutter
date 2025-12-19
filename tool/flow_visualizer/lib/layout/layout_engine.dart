import 'dart:ui';
import 'dart:math' as math;
import '../models/domain_models.dart';

class LayoutConstants {
  static const double nodeWidth = 180.0;
  static const double nodeHeight = 320.0; // Smartphone aspect ratio
  static const double verticalSpacing = 80.0; // Spacing between stacked flow bands
  static const double horizontalSpacing = 100.0; // Spacing between step columns (Left -> Right)
  static const double branchSpacing = 40.0; // Vertical spacing between concurrent branches within a flow
  static const double headerHeight = 60.0;
}

class FlowLayoutResult {
  final Map<String, Offset> nodePositions; // Key: FlowScreen.id OR proxyId
  final Map<String, Size> flowSizes;
  final Map<String, Rect> flowBounds;
  final Size totalSize;
  final Map<String, String> proxyTargets; // key: proxyId, value: targetScreenId

  FlowLayoutResult({
    required this.nodePositions,
    required this.flowSizes,
    required this.flowBounds,
    required this.totalSize,
    required this.proxyTargets,
  });
}

class LayoutEngine {
  FlowLayoutResult calculateLayout(FlowData data) {
    final Map<String, Offset> allPositions = {};
    final Map<String, Size> flowSizes = {};
    final Map<String, Rect> flowBounds = {};
    final Map<String, String> allProxies = {};

    double currentY = 0.0;
    double maxGlobalWidth = 0.0;

    for (final flow in data.flows) {
      final screens = data.flowScreens.where((s) => s.flowId == flow.id).toList();
      final transitions = data.transitions.where((t) => t.flowId == flow.id).toList();

      final flowLayout = _calculateSingleHorizontalFlow(flow, screens, transitions);

      allProxies.addAll(flowLayout.proxyTargets);

      // Calculate Bounds for this Horizontal Band
      final flowWidth = flowLayout.size.width + 100;
      if (flowWidth > maxGlobalWidth) maxGlobalWidth = flowWidth;

      final flowHeight = flowLayout.size.height + LayoutConstants.headerHeight + 40;

      final flowRect = Rect.fromLTWH(0, currentY, math.max(flowWidth, 2000), flowHeight);

      double startX = 50.0;
      double topPadding = LayoutConstants.headerHeight + 20.0;

      for (final entry in flowLayout.nodePositions.entries) {
        allPositions[entry.key] = entry.value.translate(startX, currentY + topPadding);
      }

      flowSizes[flow.id] = Size(flowWidth, flowHeight);
      flowBounds[flow.id] = flowRect;

      currentY += flowHeight + LayoutConstants.verticalSpacing;
    }

    return FlowLayoutResult(
      nodePositions: allPositions,
      flowSizes: flowSizes,
      flowBounds: flowBounds,
      totalSize: Size(maxGlobalWidth, currentY),
      proxyTargets: allProxies,
    );
  }

  _FlowLayout _calculateSingleHorizontalFlow(
    FlowDefinition flow,
    List<FlowScreen> screens,
    List<FlowTransition> transitions,
  ) {
    if (screens.isEmpty) return _FlowLayout({}, Size.zero, {});

    // 1. Identify Entry Nodes (Roots)
    List<FlowScreen> entryNodes = screens.where((s) => s.role == 'entry').toList();

    // Fallback if no explicit entry
    if (entryNodes.isEmpty) {
      final fallbackDetails = screens.firstWhere((s) => s.screenId == flow.entryScreenId, orElse: () => screens.first);
      entryNodes = [fallbackDetails];
    }

    // Sort to ensure Home is first (if possible) for better visual order
    entryNodes.sort((a, b) {
      if (a.id == 'fs_home') return -1;
      if (b.id == 'fs_home') return 1;
      return a.id.compareTo(b.id);
    });

    // 2. Build Adjacency Table
    // EXCLUDE "Tab" transitions from layout hierarchy.
    // INJECT "Proxy" nodes for cross-flow transitions.
    final Map<String, List<String>> adj = {};
    final Map<String, FlowScreen> screenIdToFlowScreen = {for (var s in screens) s.screenId: s};
    final Map<String, String> localProxyNodes = {}; // proxyId -> targetScreenName

    for (final t in transitions) {
      if (t.label == 'Tab') continue;

      final fromFs = screenIdToFlowScreen[t.fromScreenId];
      if (fromFs == null) continue;

      // Check if target is in this flow
      final toFs = screenIdToFlowScreen[t.toScreenId];

      if (toFs != null) {
        // Local Transition
        adj.putIfAbsent(fromFs.id, () => []).add(toFs.id);
      } else {
        // Cross-Flow Transition
        // Create a unique proxy ID
        final proxyId = 'proxy_${t.fromScreenId}_${t.toScreenId}';

        // Add to adjacency as a child of 'from'
        adj.putIfAbsent(fromFs.id, () => []).add(proxyId);

        // Store target for UI
        localProxyNodes[proxyId] = t.toScreenId;
      }
    }

    // 3. Recursive Layout (Tree-like)
    final positions = <String, Offset>{};
    final visited = <String>{};

    double currentY = 0.0;

    // Process all root entries
    for (final entry in entryNodes) {
      double h = _layoutNodeRecursively(
        entry.id,
        adj,
        positions,
        visited,
        0, // Start at Level 0
        currentY,
      );
      currentY += h;
    }

    // 4. Handle Disconnected Components
    final remaining = screens.where((s) => !visited.contains(s.id)).toList();

    // Sort remaining to be deterministic
    remaining.sort((a, b) => a.id.compareTo(b.id));

    if (remaining.isNotEmpty) {
      currentY += LayoutConstants.branchSpacing;
    }

    for (final rem in remaining) {
      double h = _layoutNodeRecursively(
        rem.id,
        adj,
        positions,
        visited,
        0, // Start disconnected nodes at Level 0
        currentY,
      );
      currentY += h;
    }

    // Calculate bounding box size
    double maxWidth = 0;
    if (positions.isNotEmpty) {
      maxWidth = positions.values.map((p) => p.dx).reduce(math.max) + LayoutConstants.nodeWidth;
    }

    return _FlowLayout(positions, Size(maxWidth, currentY), localProxyNodes);
  }

  // Returns the Height consumed by this node and its children
  double _layoutNodeRecursively(
    String nodeId,
    Map<String, List<String>> adj,
    Map<String, Offset> positions,
    Set<String> visited,
    int level,
    double startY,
  ) {
    if (positions.containsKey(nodeId)) {
      return 0;
    }

    visited.add(nodeId);

    // X Position: strictly level-based
    double x = level * (LayoutConstants.nodeWidth + LayoutConstants.horizontalSpacing);

    positions[nodeId] = Offset(x, startY);

    final children = adj[nodeId] ?? [];

    if (children.isEmpty) {
      return LayoutConstants.nodeHeight + LayoutConstants.branchSpacing;
    }

    double currentChildY = startY;
    bool hasValidChildren = false;

    for (final childId in children) {
      if (!visited.contains(childId)) {
        double childHeight = _layoutNodeRecursively(childId, adj, positions, visited, level + 1, currentChildY);
        currentChildY += childHeight;
        hasValidChildren = true;
      }
    }

    double totalHeight = currentChildY - startY;

    if (!hasValidChildren) {
      return LayoutConstants.nodeHeight + LayoutConstants.branchSpacing;
    }

    return totalHeight;
  }
}

class _FlowLayout {
  final Map<String, Offset> nodePositions;
  final Size size;
  final Map<String, String> proxyTargets;
  _FlowLayout(this.nodePositions, this.size, this.proxyTargets);
}
