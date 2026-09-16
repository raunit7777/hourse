import 'package:flutter/material.dart';

class HorseTokenWidget extends StatelessWidget {
  final int horseNumber;
  final Color color;
  final String gifPath;

  const HorseTokenWidget({
    super.key,
    required this.horseNumber,
    required this.color,
    required this.gifPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 45,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Running Horse GIF
          Image.asset(
            gifPath,
            width: 55,
            height: 40,
            fit: BoxFit.contain,
            // Agar GIF load hone me time le ya path miss ho toh fallback
            errorBuilder: (context, error, stackTrace) => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color, width: 1.5),
              ),
              child: const Text('🐎', style: TextStyle(fontSize: 18)),
            ),
          ),

          // Horse Number Badge
          Positioned(
            top: -2,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                '#$horseNumber',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}