import 'dart:math' as math;

import 'package:flutter/material.dart';

class DustCloudPainter extends CustomPainter {
  final double animationValue;
  final int seed;
  final bool isRunning;

  DustCloudPainter({
    required this.animationValue,
    required this.seed,
    this.isRunning = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isRunning) return;

    final rand = math.Random(seed * 9176);

    // ==========================================================
    // 1. KICK-UP DIRT SPECKS  (fast, sharp, low, kicked backward)
    //    Heavy granules that arc out and drop quickly.
    // ==========================================================
    const int speckCount = 7;
    for (int i = 0; i < speckCount; i++) {
      // Each speck has a stable per-particle delay + speed
      final double delay = rand.nextDouble() * 0.6;
      final double p = (animationValue + delay) % 1.0;

      // Horizontal kick — decelerates as it flies back (pow < 1)
      final double speed = 18.0 + rand.nextDouble() * 14.0;
      final double kickX = -math.pow(p, 0.65) * speed;

      // Vertical arc — small gravity pull feels heavier for dirt
      final double arcHeight = 2.0 + rand.nextDouble() * 3.5;
      final double gravityDrop = math.pow(p, 2.2) * arcHeight;
      final double arcY = -math.sin(p * math.pi) * arcHeight + gravityDrop;

      // Ground baseline (slightly randomised per speck)
      final double groundY =
          size.height - 0.5 - rand.nextDouble() * 1.5 + arcY;

      // Particle grows slightly as it flies, then shrinks
      final double lifeGrow = math.sin(p * math.pi);
      final double baseR = 0.7 + rand.nextDouble() * 0.9;
      final double radius = baseR * (0.6 + lifeGrow * 0.7);

      // Opacity fades non-linearly — sharp at start, fades fast
      final double opacity =
          math.pow(1.0 - p, 1.6).clamp(0.0, 1.0) * 0.85;

      // Alternate mud / sand tones for realism
      final Color base = (i % 3 == 0)
          ? const Color(0xFF6D4C41) // dark mud clod
          : (i % 3 == 1)
          ? const Color(0xFF8D6E63) // mid dirt
          : const Color(0xFFBCAAA4); // light sandy dust

      final paint = Paint()..style = PaintingStyle.fill;

      // Soft blurred halo for the smaller/faster specks (motion blur feel)
      if (radius < 1.2) {
        paint.maskFilter =
        const MaskFilter.blur(BlurStyle.normal, 0.6);
      }

      paint.color = base.withOpacity(opacity);
      canvas.drawCircle(Offset(kickX, groundY), radius, paint);
    }

    // ==========================================================
    // 2. FLOATING DUST MOTES  (light, slow, upward drifting)
    //    The fine airborne powder that lingers above the dirt.
    // ==========================================================
    const int moteCount = 6;
    for (int i = 0; i < moteCount; i++) {
      final double delay = rand.nextDouble() * 0.8;
      final double p = (animationValue * 0.6 + delay) % 1.0;

      // Slower, further backward drift (wind + vacuum)
      final double driftX =
          -math.pow(p, 0.9) * (22.0 + rand.nextDouble() * 10.0);

      // Motes rise then slowly settle
      final double riseY =
          -math.sin(p * math.pi * 0.8) * (5.0 + rand.nextDouble() * 3.0);
      final double y = size.height - 1.0 + riseY;

      final double radius = 1.4 + rand.nextDouble() * 1.4;
      final double opacity =
      (math.sin(p * math.pi) * 0.35).clamp(0.0, 0.35);

      final paint = Paint()
        ..color = const Color(0xFFD7CCC8).withOpacity(opacity)
        ..maskFilter =
        const MaskFilter.blur(BlurStyle.normal, 1.4);

      canvas.drawCircle(Offset(driftX, y), radius, paint);
    }

    // ==========================================================
    // 3. GROUND DUST CLOUD  (flat, sliding, breathing oval)
    //    The low-lying brown plume kicked up right at the hooves.
    // ==========================================================
    final double cloudP = (animationValue + seed * 0.17) % 1.0;

    // Slides back fast, then lingers
    final double cloudX = -math.pow(cloudP, 0.7) * 26.0;

    // Grows outward as it slides, then dissipates
    final double grow = math.sin(cloudP * math.pi * 0.9);
    final double cloudW = 12.0 + grow * 22.0;
    final double cloudH = 3.0 + grow * 2.2;

    final double cloudOpacity =
    (math.pow(1.0 - cloudP, 1.4) * 0.5).clamp(0.0, 0.5);

    final cloudPaint = Paint()
      ..color = const Color(0xFFA1887F).withOpacity(cloudOpacity)
      ..maskFilter =
      const MaskFilter.blur(BlurStyle.normal, 1.8);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cloudX, size.height - 0.8),
        width: cloudW,
        height: cloudH,
      ),
      cloudPaint,
    );

    // ==========================================================
    // 4. EXTRA GROUND BURST  (short-lived puff right at hooves)
    // ==========================================================
    final double burstP =
        (animationValue * 1.4 + seed * 0.31) % 1.0;
    final double burstX = -burstP * 10.0;
    final double burstOpacity =
    (math.pow(1.0 - burstP, 2.0) * 0.55).clamp(0.0, 0.55);
    final double burstSize = 3.0 + burstP * 6.0;

    final burstPaint = Paint()
      ..color = const Color(0xFF8D6E63).withOpacity(burstOpacity)
      ..maskFilter =
      const MaskFilter.blur(BlurStyle.normal, 2.0);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(burstX, size.height - 1.2),
        width: burstSize,
        height: burstSize * 0.45,
      ),
      burstPaint,
    );
  }

  @override
  bool shouldRepaint(covariant DustCloudPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue ||
          oldDelegate.seed != seed ||
          oldDelegate.isRunning != isRunning;
}