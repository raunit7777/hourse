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
    // Sirf Horse GIF render hoga, koi # number ya badge nahi aayega
    return Image.asset(
      gifPath,
      height: 70, // Apne screen ke according size adjust kar sakte hain
      fit: BoxFit.contain,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.pets,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}