import 'dart:math' as math;
import 'package:flutter/material.dart';

class PlayerTokenWidget extends StatelessWidget {
  final double angle;

  const PlayerTokenWidget({
    super.key,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF0055), Color(0xFFFF5500)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF0055).withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Headlights
            Positioned(
              right: 2,
              child: Container(
                width: 4,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.8),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Windshield / Cabin
            Positioned(
              left: 12,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            // Racing stripe
            Container(
              width: 32,
              height: 2,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}