import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum RaceStatus { initial, running, paused, completed }

class HorseModel {
  final int id;
  final String name;
  final Color color;
  final String gifPath;
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

class HorseRacingViewModel extends ChangeNotifier {
  // Test Mode: true = 15 Seconds, false = 6 Hours
  static const bool testMode = true;
  static const Duration _prodDuration = Duration(hours: 6);
  static const Duration _testDuration = Duration(seconds: 12);

  Duration get totalDuration => testMode ? _testDuration : _prodDuration;

  RaceStatus _status = RaceStatus.initial;
  RaceStatus get status => _status;

  DateTime? _startTime;
  Duration _accumulatedTime = Duration.zero;
  Timer? _ticker;
  int _finishedCount = 0;

  late final List<HorseModel> horses;

  final List<Color> _horseColors = [
    Colors.redAccent,
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
  ];

  final List<String> _horseGifs = [
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_no3_1mb.gif',
  ];

  HorseRacingViewModel() {
    final rand = math.Random();
    horses = List.generate(6, (i) {
      return HorseModel(
        id: i + 1,
        name: 'Horse ${i + 1}',
        color: _horseColors[i % _horseColors.length],
        gifPath: _horseGifs[i % _horseGifs.length],
        speedFactor: 0.96 + (rand.nextDouble() * 0.08),
      );
    });
  }

  Duration get remainingDuration {
    if (_startTime == null && _accumulatedTime == Duration.zero) {
      return totalDuration;
    }
    final elapsed = _accumulatedTime +
        (_status == RaceStatus.running
            ? DateTime.now().difference(_startTime!)
            : Duration.zero);
    final rem = totalDuration - elapsed;
    return rem.isNegative ? Duration.zero : rem;
  }

  void startOrResume() {
    if (_status == RaceStatus.running || _status == RaceStatus.completed) {
      return;
    }
    _status = RaceStatus.running;
    _startTime = DateTime.now();

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 16), _tick);
    notifyListeners();
  }

  void pause() {
    if (_status != RaceStatus.running) return;
    _accumulatedTime += DateTime.now().difference(_startTime!);
    _status = RaceStatus.paused;
    _ticker?.cancel();
    notifyListeners();
  }

  void reset() {
    _ticker?.cancel();
    _status = RaceStatus.initial;
    _startTime = null;
    _accumulatedTime = Duration.zero;
    _finishedCount = 0;

    for (var h in horses) {
      h.progress = 0.0;
      h.rank = null;
    }
    notifyListeners();
  }

  void _tick(Timer timer) {
    if (_status != RaceStatus.running || _startTime == null) return;

    final now = DateTime.now();
    final elapsedMs =
        (_accumulatedTime + now.difference(_startTime!)).inMilliseconds;
    final totalMs = totalDuration.inMilliseconds;
    final baseProgress = (elapsedMs / totalMs).clamp(0.0, 1.0);

    bool allFinished = true;

    for (var horse in horses) {
      if (horse.progress < 1.0) {
        horse.progress = (baseProgress * horse.speedFactor).clamp(0.0, 1.0);
        if (horse.progress >= 1.0) {
          _finishedCount++;
          horse.rank = _finishedCount;
        } else {
          allFinished = false;
        }
      }
    }

    if (allFinished || baseProgress >= 1.0) {
      _status = RaceStatus.completed;
      _ticker?.cancel();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}