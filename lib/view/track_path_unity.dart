import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Defines the parametric path geometry across the 3 combined images
class TrackPathUtility {
  /// Builds a normalized Path (0.0 to 1.0 in both X and Y dimensions)
  /// matching the visual road flow:
  /// - Starts mid-left on the START track
  /// - Glides smoothly across the middle landscape section
  /// - Exits smoothly into the END section finish line
  static Path getNormalizedPath() {
    final path = Path();
    path.moveTo(0.02, 0.68); // Start Line

    // Curve through start section into middle track
    path.cubicTo(
      0.15, 0.68,
      0.22, 0.42,
      0.35, 0.45,
    );

    // Dynamic S-curve traversing the middle (6 hours) section
    path.cubicTo(
      0.48, 0.48,
      0.55, 0.70,
      0.70, 0.58,
    );

    // Final stretch approaching the finish section
    path.cubicTo(
      0.82, 0.48,
      0.90, 0.52,
      0.98, 0.50, // Finish Line
    );

    return path;
  }

  /// Calculates actual pixel position and orientation angle (radians) for a given progress (0.0 to 1.0)
  static (Offset, double) calculatePositionAndAngle(double progress, Size canvasSize) {
    final normalizedPath = getNormalizedPath();
    final matrix = Matrix4.identity()..scale(canvasSize.width, canvasSize.height);
    final scaledPath = normalizedPath.transform(matrix.storage);

    final pathMetrics = scaledPath.computeMetrics().toList();
    if (pathMetrics.isEmpty) {
      return (Offset.zero, 0.0);
    }

    final metric = pathMetrics.first;
    final targetDistance = metric.length * progress.clamp(0.0, 1.0);
    final tangent = metric.getTangentForOffset(targetDistance);

    if (tangent == null) {
      return (Offset.zero, 0.0);
    }

    // tangent.vector gives dx, dy -> calculate rotation angle
    final angle = math.atan2(tangent.vector.dy, tangent.vector.dx);
    return (tangent.position, angle);
  }
}

class ContinuousTrackLayout extends StatelessWidget {
  final Widget child;

  const ContinuousTrackLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // 3-Segment Image Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Start Section (25% screen width)
                Expanded(
                  flex: 25,
                  child: Image.asset(
                    'assets/images/start_track.png',
                    fit: BoxFit.fill,
                    errorBuilder: (context, _, __) => _buildPlaceholderSegment('START TRACK', Colors.indigo.shade900),
                  ),
                ),
                // Middle Section (50% screen width)
                Expanded(
                  flex: 50,
                  child: Image.asset(
                    'assets/images/6_hours_track.png',
                    fit: BoxFit.fill,
                    errorBuilder: (context, _, __) => _buildPlaceholderSegment('MIDDLE TRACK (6H)', Colors.blueGrey.shade900),
                  ),
                ),
                // End Section (25% screen width)
                Expanded(
                  flex: 25,
                  child: Image.asset(
                    'assets/images/end_track.png',
                    fit: BoxFit.fill,
                    errorBuilder: (context, _, __) => _buildPlaceholderSegment('END TRACK', Colors.deepPurple.shade900),
                  ),
                ),
              ],
            ),

            // Subtle road visualizer for verification & high-res polish
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _TrackGuidelinePainter(),
            ),

            // Player & Marker Layer
            child,
          ],
        );
      },
    );
  }

  Widget _buildPlaceholderSegment(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white12, width: 0.5),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white24,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _TrackGuidelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final matrix = Matrix4.identity()..scale(size.width, size.height);
    final path = TrackPathUtility.getNormalizedPath().transform(matrix.storage);

    // Glowing track center line
    final roadLinePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, roadLinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}