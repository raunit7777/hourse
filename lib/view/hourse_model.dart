import 'dart:ui';

class HorseModel {
  final int id;
  final String name;
  final Color color;
  final String gifPath; // Alag GIF path
  final double speedFactor;
  double progress;
  int? rank;

  HorseModel({
    required this.id,
    required this.name,
    required this.color,
    required this.gifPath,
    required this.speedFactor,
    this.progress = 0.0,
    this.rank,
  });
}