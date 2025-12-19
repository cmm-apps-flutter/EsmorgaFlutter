import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/domain_models.dart';
import '../layout/layout_engine.dart';

class FlowDiagramScreen extends StatefulWidget {
  final FlowData data;
  final FlowLayoutResult layout;

  const FlowDiagramScreen({super.key, required this.data, required this.layout});

  @override
  State<FlowDiagramScreen> createState() => _FlowDiagramScreenState();
}

class _FlowDiagramScreenState extends State<FlowDiagramScreen> {
  final TransformationController _transformController = TransformationController();

  void _navigateToScreen(String screenId) {
    // Find target flow screen
    try {
      final targetFs = widget.data.flowScreens.firstWhere(
        (fs) => fs.screenId == screenId && fs.role == 'entry',
        orElse: () => widget.data.flowScreens.firstWhere((fs) => fs.screenId == screenId),
      );

      final pos = widget.layout.nodePositions[targetFs.id];
      if (pos != null) {
        // Animate to pos
        final matrix = Matrix4.identity()
          ..translate(-pos.dx + 200, -pos.dy + 300) // Center roughly
          ..scale(1.0);

        _transformController.value = matrix;
      }
    } catch (e) {
      debugPrint('Target not found for navigation: $screenId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esmorga Flow Visualizer')),
      body: InteractiveViewer(
        transformationController: _transformController,
        boundaryMargin: const EdgeInsets.all(1000),
        minScale: 0.1,
        maxScale: 2.0,
        constrained: false,
        child: SizedBox(
          width: widget.layout.totalSize.width + 1000,
          height: widget.layout.totalSize.height + 1000,
          child: Stack(
            children: [
              // 1. Swimlane Backgrounds & Titles
              ...widget.data.flows.map((flow) {
                final bounds = widget.layout.flowBounds[flow.id]!;
                return Positioned.fromRect(
                  rect: bounds,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                        right: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                          ),
                          child: Text(
                            flow.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // 2. Connections (Arrows)
              CustomPaint(
                size: Size(widget.layout.totalSize.width, widget.layout.totalSize.height),
                painter: ConnectionPainter(data: widget.data, layout: widget.layout),
              ),

              // 3. Nodes
              ...widget.data.flowScreens.map((fs) {
                final pos = widget.layout.nodePositions[fs.id];
                if (pos == null) return const SizedBox.shrink();

                final screenDef = widget.data.screens.firstWhere(
                  (s) => s.id == fs.screenId,
                  orElse: () => ScreenDefinition(id: '?', name: 'Unknown'),
                );

                final isEntry = fs.role == 'entry';

                return Positioned(
                  left: pos.dx,
                  top: pos.dy,
                  width: LayoutConstants.nodeWidth,
                  height: LayoutConstants.nodeHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: isEntry
                          ? Border.all(color: Colors.green, width: 3)
                          : Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (screenDef.screenshot != null)
                          Image.asset(
                            screenDef.screenshot!,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.medium,
                            errorBuilder: (ctx, err, stack) => Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.broken_image, color: Colors.grey),
                                  Text(
                                    screenDef.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                screenDef.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: isEntry ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                        // Label Overlay
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.6),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              screenDef.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // 4. Proxy Nodes (Buttons)
              ...widget.layout.proxyTargets.entries.map((entry) {
                final proxyId = entry.key;
                final targetScreenId = entry.value;
                final pos = widget.layout.nodePositions[proxyId];

                if (pos == null) return const SizedBox.shrink();

                final targetScreen = widget.data.screens.firstWhere(
                  (s) => s.id == targetScreenId,
                  orElse: () => ScreenDefinition(id: targetScreenId, name: targetScreenId),
                );

                return Positioned(
                  left: pos.dx,
                  top: pos.dy,
                  width: LayoutConstants.nodeWidth,
                  height: 60, // Smaller height like a button card
                  child: Material(
                    color: Colors.blue.shade50,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue.shade200, width: 1),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _navigateToScreen(targetScreenId),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.logout, size: 20, color: Colors.blue), // 'Jump' icon
                              const SizedBox(height: 4),
                              Text(
                                "Go to\n${targetScreen.name}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ConnectionPainter extends CustomPainter {
  final FlowData data;
  final FlowLayoutResult layout;

  ConnectionPainter({required this.data, required this.layout});

  @override
  void paint(Canvas canvas, Size size) {
    final mainPathPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final secondaryPaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final proxyLinkPaint = Paint()
      ..color = Colors.blue.shade300
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke; // Dashed is hard without package, solid is fine

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Helper to check if screen is local to flow
    bool isLocalBox(String screenId, String currentFlowId) {
      return data.flowScreens.any((fs) => fs.flowId == currentFlowId && fs.screenId == screenId);
    }

    // Helper to find position of FlowScreen
    Offset? getScreenPos(String screenId, String currentFlowId) {
      try {
        final localFs = data.flowScreens.firstWhere((fs) => fs.flowId == currentFlowId && fs.screenId == screenId);
        return layout.nodePositions[localFs.id];
      } catch (e) {
        return null;
      }
    }

    // 1. Draw Real Transitions
    for (final flow in data.flows) {
      final flowTransitions = data.transitions.where((t) => t.flowId == flow.id).toList();

      for (final t in flowTransitions) {
        // Skip if Cross-Flow (now handled by proxies)
        if (!isLocalBox(t.toScreenId, flow.id)) continue;

        final fromPos = getScreenPos(t.fromScreenId, flow.id);
        final toPos = getScreenPos(t.toScreenId, flow.id);

        if (fromPos == null || toPos == null) continue;

        // Loop detection
        bool isLoop = (toPos.dx <= fromPos.dx + 1.0);

        final fromRect = Rect.fromLTWH(fromPos.dx, fromPos.dy, LayoutConstants.nodeWidth, LayoutConstants.nodeHeight);
        final toRect = Rect.fromLTWH(toPos.dx, toPos.dy, LayoutConstants.nodeWidth, LayoutConstants.nodeHeight);

        final path = Path();
        Paint paintToUse;

        if (!isLoop) {
          // --- STANDARD (Left -> Right) ---
          paintToUse = mainPathPaint;
          Offset start = fromRect.centerRight;
          Offset end = toRect.centerLeft;

          path.moveTo(start.dx, start.dy);
          final controlDist = (end.dx - start.dx) / 2;
          path.cubicTo(start.dx + controlDist, start.dy, end.dx - controlDist, end.dy, end.dx, end.dy);
        } else {
          // --- LOOP / BACKWARDS (Hug Bottom) ---
          paintToUse = secondaryPaint;
          Offset start = fromRect.bottomCenter;
          Offset end = toRect.bottomCenter;
          double loopY = math.max(start.dy, end.dy) + 30.0;

          path.moveTo(start.dx, start.dy);
          path.lineTo(start.dx, loopY);
          path.lineTo(end.dx, loopY);
          path.lineTo(end.dx, end.dy);
        }

        canvas.drawPath(path, paintToUse);
        _drawArrowHead(canvas, path, paintToUse.color);

        if (t.label.isNotEmpty) {
          _drawLabel(canvas, path, t.label, textPainter, isLoop);
        }
      }

      // 2. Draw Proxy Connections for this flow
      for (final t in flowTransitions) {
        if (isLocalBox(t.toScreenId, flow.id)) continue; // Handled above, looking for non-local

        final proxyId = 'proxy_${t.fromScreenId}_${t.toScreenId}';
        final proxyPos = layout.nodePositions[proxyId];
        final fromPos = getScreenPos(t.fromScreenId, flow.id);

        if (proxyPos == null || fromPos == null) continue;

        final fromRect = Rect.fromLTWH(fromPos.dx, fromPos.dy, LayoutConstants.nodeWidth, LayoutConstants.nodeHeight);
        // Proxy rect - assume height 60
        final toRect = Rect.fromLTWH(proxyPos.dx, proxyPos.dy, LayoutConstants.nodeWidth, 60.0);

        final path = Path();
        // Standard Left -> Right
        Offset start = fromRect.centerRight;
        Offset end = toRect.centerLeft;

        path.moveTo(start.dx, start.dy);
        final controlDist = (end.dx - start.dx) / 2;
        path.cubicTo(start.dx + controlDist, start.dy, end.dx - controlDist, end.dy, end.dx, end.dy);

        canvas.drawPath(path, proxyLinkPaint);
        _drawArrowHead(canvas, path, proxyLinkPaint.color);
      }
    }
  }

  void _drawArrowHead(Canvas canvas, Path path, Color color) {
    final metrics = path.computeMetrics().lastOrNull;
    if (metrics == null || metrics.length < 5) return;
    final endPos = metrics.getTangentForOffset(metrics.length);
    if (endPos == null) return;
    final angle = -endPos.angle;
    final arrowSize = 6.0;
    final arrowPath = Path();
    arrowPath.moveTo(0, 0);
    arrowPath.lineTo(-arrowSize, arrowSize * 0.8);
    arrowPath.lineTo(-arrowSize, -arrowSize * 0.8);
    arrowPath.close();
    canvas.save();
    canvas.translate(endPos.position.dx, endPos.position.dy);
    canvas.rotate(-angle);
    canvas.drawPath(
      arrowPath,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.restore();
  }

  void _drawLabel(Canvas canvas, Path path, String text, TextPainter tp, bool isSecondary) {
    final metrics = path.computeMetrics().firstOrNull;
    if (metrics != null) {
      final offset = metrics.length * 0.5;
      final center = metrics.getTangentForOffset(offset);
      if (center != null) {
        tp.text = TextSpan(
          text: text,
          style: TextStyle(
            color: isSecondary ? Colors.grey.shade700 : Colors.black87,
            fontSize: 10,
            fontWeight: isSecondary ? FontWeight.normal : FontWeight.w600,
          ),
        );
        tp.layout();
        final bgRect = Rect.fromCenter(center: center.position, width: tp.width + 6, height: tp.height + 2);
        canvas.drawRRect(
          RRect.fromRectAndRadius(bgRect, const Radius.circular(2)),
          Paint()
            ..color = Colors.white.withOpacity(0.95)
            ..style = PaintingStyle.fill,
        );
        if (!isSecondary) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(bgRect, const Radius.circular(2)),
            Paint()
              ..color = Colors.grey.withOpacity(0.2)
              ..style = PaintingStyle.stroke,
          );
        }
        tp.paint(canvas, center.position - Offset(tp.width / 2, tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
