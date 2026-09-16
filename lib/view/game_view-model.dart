import 'dart:async';
import 'package:flutter/foundation.dart';

import 'game_status.dart';


class GameViewModel extends ChangeNotifier {
  // ==========================================
  // CONFIGURATION & TEST MODE
  // ==========================================
  /// When true:  Total journey = 60 seconds (1 sec = 1 min)
  /// When false: Total journey = 3600 seconds (1 hour)
  static const bool testMode = true;

  static const Duration _productionDuration = Duration(hours: 1);
  static const Duration _testDuration = Duration(seconds: 60);

  Duration get totalDuration => testMode ? _testDuration : _productionDuration;

  // State properties
  GameStatus _status = GameStatus.initial;
  GameStatus get status => _status;

  DateTime? _gameStartTime;
  Duration _accumulatedElapsedTime = Duration.zero;
  Timer? _ticker;

  double _progress = 0.0; // 0.0 to 1.0
  double get progress => _progress;

  Duration get remainingDuration {
    final remainingSeconds = (totalDuration.inSeconds * (1.0 - _progress)).ceil();
    return Duration(seconds: remainingSeconds.clamp(0, totalDuration.inSeconds));
  }

  void startOrResume() {
    if (_status == GameStatus.running || _status == GameStatus.completed) return;

    _status = GameStatus.running;
    _gameStartTime = DateTime.now();

    // High frequency ticker (~60fps) for fluid position updates
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 16), _onTick);
    notifyListeners();
  }

  void pause() {
    if (_status != GameStatus.running) return;

    _accumulatedElapsedTime += DateTime.now().difference(_gameStartTime!);
    _status = GameStatus.paused;
    _ticker?.cancel();
    notifyListeners();
  }

  void reset() {
    _ticker?.cancel();
    _status = GameStatus.initial;
    _gameStartTime = null;
    _accumulatedElapsedTime = Duration.zero;
    _progress = 0.0;
    notifyListeners();
  }

  void _onTick(Timer timer) {
    if (_status != GameStatus.running || _gameStartTime == null) return;

    final currentElapsed = _accumulatedElapsedTime + DateTime.now().difference(_gameStartTime!);
    final totalMs = totalDuration.inMilliseconds;
    final elapsedMs = currentElapsed.inMilliseconds;

    _progress = (elapsedMs / totalMs).clamp(0.0, 1.0);

    if (_progress >= 1.0) {
      _progress = 1.0;
      _status = GameStatus.completed;
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