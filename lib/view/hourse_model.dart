// import 'dart:async';
// import 'dart:math' as math;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// enum RaceStatus { initial, running, paused, completed }
//
// class HorseModel {
//   final int id;
//   final String name;
//   final Color color;
//   final String gifPath;
//   final double speedFactor;
//   double progress;
//   int? rank;
//
//   HorseModel({
//     required this.id,
//     required this.name,
//     required this.color,
//     required this.gifPath,
//     required this.speedFactor,
//     this.progress = 0.0,
//     this.rank,
//   });
// }
//
// class HorseRacingViewModel extends ChangeNotifier {
//   static const bool testMode = true;
//   static const Duration _prodDuration = Duration(hours: 6);
//   static const Duration _testDuration = Duration(seconds: 15);
//
//   Duration get totalDuration => testMode ? _testDuration : _prodDuration;
//
//   RaceStatus _status = RaceStatus.initial;
//   RaceStatus get status => _status;
//
//   DateTime? _startTime;
//   Duration _accumulatedTime = Duration.zero;
//   Timer? _ticker;
//   int _finishedCount = 0;
//
//   late final List<HorseModel> horses;
//
//   // 12 Distinct Colors
//   final List<Color> _horseColors = const [
//     Colors.redAccent,
//     Colors.amberAccent,
//     Colors.greenAccent,
//     Colors.cyanAccent,
//     Colors.purpleAccent,
//     Colors.orangeAccent,
//     Colors.pinkAccent,
//     Colors.lightGreenAccent,
//     Colors.tealAccent,
//     Colors.deepOrangeAccent,
//     Colors.indigoAccent,
//     Colors.yellowAccent,
//   ];
//
//   final List<String> _horseGifs = const [
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//     'assets/HORSES/horse_no3_1mb.gif',
//   ];
//
//   HorseRacingViewModel() {
//     final rand = math.Random();
//     // 12 Horses generate ho rahe hain
//     horses = List.generate(12, (i) {
//       return HorseModel(
//         id: i + 1,
//         name: 'Horse ${i + 1}',
//         color: _horseColors[i % _horseColors.length],
//         gifPath: _horseGifs[i % _horseGifs.length],
//         speedFactor: 0.96 + (rand.nextDouble() * 0.08),
//       );
//     });
//   }
//
//   Duration get remainingDuration {
//     if (_startTime == null && _accumulatedTime == Duration.zero) {
//       return totalDuration;
//     }
//     final elapsed = _accumulatedTime +
//         (_status == RaceStatus.running
//             ? DateTime.now().difference(_startTime!)
//             : Duration.zero);
//     final rem = totalDuration - elapsed;
//     return rem.isNegative ? Duration.zero : rem;
//   }
//
//   void startOrResume() {
//     if (_status == RaceStatus.running || _status == RaceStatus.completed) {
//       return;
//     }
//     _status = RaceStatus.running;
//     _startTime = DateTime.now();
//
//     _ticker?.cancel();
//     _ticker = Timer.periodic(const Duration(milliseconds: 16), _tick);
//     notifyListeners();
//   }
//
//   void pause() {
//     if (_status != RaceStatus.running) return;
//     _accumulatedTime += DateTime.now().difference(_startTime!);
//     _status = RaceStatus.paused;
//     _ticker?.cancel();
//     notifyListeners();
//   }
//
//   void reset() {
//     _ticker?.cancel();
//     _status = RaceStatus.initial;
//     _startTime = null;
//     _accumulatedTime = Duration.zero;
//     _finishedCount = 0;
//
//     for (var h in horses) {
//       h.progress = 0.0;
//       h.rank = null;
//     }
//     notifyListeners();
//   }
//
//   void _tick(Timer timer) {
//     if (_status != RaceStatus.running || _startTime == null) return;
//
//     final now = DateTime.now();
//     final elapsedMs =
//         (_accumulatedTime + now.difference(_startTime!)).inMilliseconds;
//     final totalMs = totalDuration.inMilliseconds;
//     final baseProgress = (elapsedMs / totalMs).clamp(0.0, 1.0);
//
//     bool allFinished = true;
//
//     for (var horse in horses) {
//       if (horse.progress < 1.0) {
//         horse.progress = (baseProgress * horse.speedFactor).clamp(0.0, 1.0);
//         if (horse.progress >= 1.0) {
//           _finishedCount++;
//           horse.rank = _finishedCount;
//         } else {
//           allFinished = false;
//         }
//       }
//     }
//
//     if (allFinished || baseProgress >= 1.0) {
//       _status = RaceStatus.completed;
//       _ticker?.cancel();
//     }
//
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     _ticker?.cancel();
//     super.dispose();
//   }
// }


import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum RaceStatus { initial, running, paused, completed }

class FinishSnapshot {
  final HorseModel horse;
  final String finishTime;
  final int rank;

  FinishSnapshot({
    required this.horse,
    required this.finishTime,
    required this.rank,
  });
}

class HorseModel {
  final int id;
  final String name;
  final Color color;
  final String gifPath;
  final String jockeyImagePath; // Bottom jockey strip ke liye alag photo
  final double speedFactor;
  double progress;
  int? rank;
  String? finishedAtFormatted;

  HorseModel({
    required this.id,
    required this.name,
    required this.color,
    required this.gifPath,
    required this.jockeyImagePath,
    required this.speedFactor,
    this.progress = 0.0,
    this.rank,
    this.finishedAtFormatted,
  });
}

class HorseRacingViewModel extends ChangeNotifier {
  static const bool testMode = true;
  static const Duration _prodDuration = Duration(hours: 6);
  static const Duration _testDuration = Duration(seconds: 15);

  Duration get totalDuration => testMode ? _testDuration : _prodDuration;

  RaceStatus _status = RaceStatus.initial;
  RaceStatus get status => _status;

  DateTime? _startTime;
  Duration _accumulatedTime = Duration.zero;
  Timer? _ticker;
  int _finishedCount = 0;

  FinishSnapshot? winnerSnapshot;

  late final List<HorseModel> horses;

  // Screenshot ke mutabiq 12 Realistic Names
  final List<String> _horseNames = const [
    'TOOFAN',
    'RANGEELA',
    'ARJUN',
    'ROYAL',
    'TARZAN',
    'CHETAK',
    'LUCKY',
    'BAAZIGAR',
    'JEET',
    'TIGER',
    'BADAL',
    'VICTOR',
  ];

  final List<Color> _horseColors = const [
    Colors.redAccent,
    Colors.amberAccent,
    Colors.greenAccent,
    Colors.cyanAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.pinkAccent,
    Colors.limeAccent,
    Colors.tealAccent,
    Colors.deepOrangeAccent,
    Colors.indigoAccent,
    Colors.yellowAccent,
  ];

  final List<String> _horseGifs = const [
    'assets/HORSES/horse_no1_1mb.gif',
    'assets/HORSES/horse_number_2_1MB.gif',
    'assets/HORSES/horse_no3_1mb.gif',
    'assets/HORSES/horse_4mb_hd.gif',
    'assets/HORSES/horse5_1mb.gif',
    'assets/HORSES/horse_jockey_6mb.gif',
    'assets/HORSES/horse_no7_1mb.gif',
    'assets/HORSES/horse_no8_1mb.gif',
    'assets/HORSES/horse_no_9_1MB.gif',
    'assets/HORSES/horse_number_10_1_1MB.gif',
    'assets/HORSES/horse_number_11_1MB.gif',
    'assets/HORSES/horse_number_12_1_1MB.gif',
  ];

  // 12 Separate Jockey Photos (Apne exact asset paths se verify kar lein)
  final List<String> _jockeyImages = const [
    'assets/Bet_horses/horses1.png',
    'assets/Bet_horses/horses2.png',
    'assets/Bet_horses/horses3.png.png',
    'assets/Bet_horses/horses4.png.png',
    'assets/Bet_horses/horses5.png',
    'assets/Bet_horses/horses6.png',
    'assets/Bet_horses/horses7.png',
    'assets/Bet_horses/horses8.png',
    'assets/Bet_horses/horses9.png',
    'assets/Bet_horses/horses10.png',
    'assets/Bet_horses/horses11.png',
    'assets/Bet_horses/horses12.png',
  ];

  HorseRacingViewModel() {
    final rand = math.Random();
    horses = List.generate(12, (i) {
      return HorseModel(
        id: i + 1,
        name: _horseNames[i % _horseNames.length],
        color: _horseColors[i % _horseColors.length],
        gifPath: _horseGifs[i % _horseGifs.length],
        jockeyImagePath: _jockeyImages[i % _jockeyImages.length],
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
    if (_status == RaceStatus.running || _status == RaceStatus.completed) return;
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
    winnerSnapshot = null;

    for (var h in horses) {
      h.progress = 0.0;
      h.rank = null;
      h.finishedAtFormatted = null;
    }
    notifyListeners();
  }

  void _tick(Timer timer) {
    if (_status != RaceStatus.running || _startTime == null) return;

    final now = DateTime.now();
    final elapsed = _accumulatedTime + now.difference(_startTime!);
    final elapsedMs = elapsed.inMilliseconds;
    final totalMs = totalDuration.inMilliseconds;
    final baseProgress = (elapsedMs / totalMs);

    bool allFinished = true;

    for (var horse in horses) {
      // 1.0 par rukega nahi, 1.4 tak daudkar screen ke paar nikal jayega
      horse.progress = (baseProgress * horse.speedFactor);

      if (horse.progress >= 1.0 && horse.rank == null) {
        _finishedCount++;
        horse.rank = _finishedCount;

        final m = (elapsed.inMinutes % 60).toString().padLeft(2, '0');
        final s = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
        final ms = ((elapsed.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
        horse.finishedAtFormatted = '$m:$s.$ms';

        // Winner ka Photo-finish snapshot turant capture hoga
        if (_finishedCount == 1) {
          winnerSnapshot = FinishSnapshot(
            horse: horse,
            finishTime: horse.finishedAtFormatted!,
            rank: 1,
          );
        }
      }

      if (horse.progress < 1.35) {
        allFinished = false;
      }
    }

    if (allFinished || baseProgress >= 1.4) {
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