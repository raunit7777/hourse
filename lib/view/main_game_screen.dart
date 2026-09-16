// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hours_riding/view/race_status.dart';
//
// import 'hourse_token.dart';
//
// class GameScreen extends StatefulWidget {
//   const GameScreen({super.key});
//
//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }
//
// class _GameScreenState extends State<GameScreen>
//     with TickerProviderStateMixin {
//   late final HorseRacingViewModel _viewModel;
//
//   // Animation controllers
//   late final AnimationController _gateController;
//   late final AnimationController _gallopController;
//   late final AnimationController _overlayController;
//
//   @override
//   void initState() {
//     super.initState();
//     _viewModel = HorseRacingViewModel();
//
//     // Gate opens when race starts
//     _gateController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//
//     // Continuous gallop/bob cycle
//     _gallopController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 380),
//     )..repeat();
//
//     // Finish overlay fade/scale
//     _overlayController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     _viewModel.addListener(_onViewModelChanged);
//
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   }
//
//   void _onViewModelChanged() {
//     if (_viewModel.status == RaceStatus.running) {
//       if (!_gateController.isCompleted) {
//         _gateController.forward();
//       }
//       if (!_gallopController.isAnimating) {
//         _gallopController.repeat();
//       }
//     } else if (_viewModel.status == RaceStatus.paused) {
//       _gallopController.stop();
//     } else if (_viewModel.status == RaceStatus.completed) {
//       _gallopController.stop();
//       _overlayController.forward();
//       _gateController.reverse();
//     } else if (_viewModel.status == RaceStatus.initial) {
//       _gallopController.stop();
//       _overlayController.reset();
//       _gateController.reverse();
//     }
//   }
//
//   @override
//   void dispose() {
//     _viewModel.removeListener(_onViewModelChanged);
//     _viewModel.dispose();
//     _gateController.dispose();
//     _gallopController.dispose();
//     _overlayController.dispose();
//     super.dispose();
//   }
//
//   String _formatDuration(Duration d) {
//     final h = d.inHours.toString().padLeft(2, '0');
//     final m = (d.inMinutes % 60).toString().padLeft(2, '0');
//     final s = (d.inSeconds % 60).toString().padLeft(2, '0');
//     return '$h:$m:$s';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: AnimatedBuilder(
//         animation:
//         Listenable.merge([_viewModel, _gallopController, _gateController]),
//         builder: (context, _) {
//           return Stack(
//             fit: StackFit.expand,
//             children: [
//               // ========================================================
//               // 1. TRACK BACKGROUND
//               // ========================================================
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Expanded(
//                     flex: 75,
//                     child: Image.asset(
//                       'assets/top/fullimage.png',
//                       fit: BoxFit.fill,
//                       errorBuilder: (_, __, ___) =>
//                           Container(color: const Color(0xFF16213E)),
//                     ),
//                   ),
//                   Expanded(
//                     flex: 25,
//                     child: Image.asset(
//                       'assets/top/MAINFINSHLINE.png',
//                       fit: BoxFit.fill,
//                       errorBuilder: (_, __, ___) =>
//                           Container(color: const Color(0xFF0F3460)),
//                     ),
//                   ),
//                 ],
//               ),
//
//               // ========================================================
//               // 2. STARTING GATE (ANIMATED OPEN/CLOSE)
//               // ========================================================
//               Positioned(
//                 left: 0,
//                 top: 55,
//                 bottom: 8,
//                 width: 100,
//                 child: AnimatedBuilder(
//                   animation: _gateController,
//                   builder: (context, child) {
//                     final t = Curves.easeInOut.transform(_gateController.value);
//                     return Transform.translate(
//                       offset: Offset(-80 * t, 0),
//                       child: Opacity(
//                         opacity: 1.0 - (t * 0.8),
//                         child: child,
//                       ),
//                     );
//                   },
//                   child: Image.asset(
//                     'assets/sprites/GATE.png',
//                     fit: BoxFit.fill,
//                     errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//                   ),
//                 ),
//               ),
//
//               // ========================================================
//               // 3. 6 HORSES (ANIMATED MOVEMENT + GALLOP BOB)
//               // ========================================================
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 30.0, bottom: 15, left: 8.0, right: 16.0),
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       const double compactLaneHeight = 28.0;
//                       final double totalLanesHeight = compactLaneHeight * 6;
//                       final double startY =
//                           (constraints.maxHeight - totalLanesHeight) / 2;
//                       final double trackWidth = constraints.maxWidth - 65;
//
//                       return Stack(
//                         children: [
//                           for (int i = 0; i < _viewModel.horses.length; i++)
//                             _buildHorsePositioned(
//                               horse: _viewModel.horses[i],
//                               index: i,
//                               laneSpacing: compactLaneHeight,
//                               topOffset: startY,
//                               trackWidth: trackWidth,
//                             ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               // ========================================================
//               // 4. TOP HUD
//               // ========================================================
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: SafeArea(bottom: false, child: _buildTopHud()),
//               ),
//
//               // ========================================================
//               // 5. FINISH OVERLAY (ANIMATED)
//               // ========================================================
//               if (_viewModel.status == RaceStatus.completed)
//                 _buildRaceFinishOverlay(),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildHorsePositioned({
//     required HorseModel horse,
//     required int index,
//     required double laneSpacing,
//     required double topOffset,
//     required double trackWidth,
//   }) {
//     final targetX = 25.0 + (trackWidth * horse.progress);
//     final baseY = topOffset + (index * laneSpacing);
//
//     // Gallop bob: different phase per horse so they don't sync
//     final phase = (_gallopController.value + (index * 0.15)) % 1.0;
//     final bob = (phase < 0.5 ? phase : 1.0 - phase) * 6.0;
//     final isRunning = _viewModel.status == RaceStatus.running;
//     final double bobOffset = isRunning ? -bob : 0.0;
//
//     return AnimatedPositioned(
//       duration: const Duration(milliseconds: 220),
//       curve: Curves.easeOut,
//       left: targetX,
//       top: baseY + bobOffset,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           HorseTokenWidget(
//             horseNumber: horse.id,
//             color: horse.color,
//             gifPath: horse.gifPath,
//           ),
//           if (horse.rank != null) ...[
//             const SizedBox(width: 4),
//             TweenAnimationBuilder<double>(
//               key: ValueKey('rank_${horse.id}_${horse.rank}'),
//               tween: Tween(begin: 0.0, end: 1.0),
//               duration: const Duration(milliseconds: 350),
//               curve: Curves.elasticOut,
//               builder: (context, scale, child) {
//                 return Transform.scale(scale: scale, child: child);
//               },
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.amberAccent,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: Text(
//                   '#${horse.rank}',
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTopHud() {
//     final isRunning = _viewModel.status == RaceStatus.running;
//     final isLowTime = _viewModel.remainingDuration.inSeconds < 5 &&
//         _viewModel.status == RaceStatus.running;
//
//     final pulse = isLowTime
//         ? 0.5 + 0.5 * (1 - (_gallopController.value * 2 % 1.0))
//         : 1.0;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white24),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.timer,
//                 color: isLowTime ? Colors.redAccent : Colors.cyanAccent,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               Transform.scale(
//                 scale: pulse,
//                 child: Text(
//                   _formatDuration(_viewModel.remainingDuration),
//                   style: TextStyle(
//                     color: isLowTime ? Colors.redAccent : Colors.white,
//                     fontFamily: 'monospace',
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.orangeAccent.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(color: Colors.orangeAccent),
//                 ),
//                 child: Text(
//                   HorseRacingViewModel.testMode
//                       ? 'TEST MODE (15s)'
//                       : '6 HOURS RUN',
//                   style: const TextStyle(
//                     color: Colors.orangeAccent,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   boxShadow: isRunning
//                       ? [
//                     BoxShadow(
//                       color: Colors.amberAccent.withOpacity(0.5),
//                       blurRadius: 10,
//                       spreadRadius: 1,
//                     ),
//                   ]
//                       : [],
//                 ),
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor:
//                     isRunning ? Colors.amberAccent : Colors.greenAccent,
//                     foregroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 8),
//                   ),
//                   onPressed: () {
//                     if (isRunning) {
//                       _viewModel.pause();
//                     } else {
//                       _viewModel.startOrResume();
//                     }
//                   },
//                   icon: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 250),
//                     transitionBuilder: (child, anim) =>
//                         ScaleTransition(scale: anim, child: child),
//                     child: Icon(
//                       isRunning ? Icons.pause : Icons.play_arrow,
//                       key: ValueKey(isRunning),
//                       size: 18,
//                     ),
//                   ),
//                   label: Text(
//                     isRunning ? 'PAUSE' : 'START RACE',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               OutlinedButton.icon(
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: Colors.redAccent,
//                   side: const BorderSide(color: Colors.redAccent),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 8),
//                 ),
//                 onPressed: () => _viewModel.reset(),
//                 icon: const Icon(Icons.refresh, size: 18),
//                 label: const Text('RESET',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRaceFinishOverlay() {
//     return AnimatedBuilder(
//       animation: _overlayController,
//       builder: (context, child) {
//         final curved =
//         Curves.easeOutBack.transform(_overlayController.value.clamp(0, 1));
//         return Opacity(
//           opacity: _overlayController.value.clamp(0, 1),
//           child: Transform.scale(
//             scale: 0.85 + (0.15 * curved),
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         color: Colors.black87,
//         child: Center(
//           child: Container(
//             width: 320,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E1E2F),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.amberAccent),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.amberAccent.withOpacity(0.4),
//                   blurRadius: 20,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TweenAnimationBuilder<double>(
//                   tween: Tween(begin: 0.0, end: 1.0),
//                   duration: const Duration(milliseconds: 700),
//                   curve: Curves.elasticOut,
//                   builder: (context, v, child) =>
//                       Transform.scale(scale: v, child: child),
//                   child: const Icon(Icons.emoji_events,
//                       color: Colors.amberAccent, size: 48),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'RACE FINISHED!',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Winner: ${_viewModel.horses.firstWhere((h) => h.rank == 1).name}',
//                   style: const TextStyle(
//                     color: Colors.greenAccent,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.cyanAccent,
//                     foregroundColor: Colors.black,
//                   ),
//                   onPressed: () {
//                     _overlayController.reset();
//                     _viewModel.reset();
//                     _viewModel.startOrResume();
//                   },
//                   child: const Text('RACE AGAIN',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hours_riding/view/race_status.dart';

import 'hourse_token.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late final HorseRacingViewModel _viewModel;

  late final AnimationController _gallopController;
  late final AnimationController _overlayController;

  bool _showGate = true;
  Timer? _gateTimer;

  @override
  void initState() {
    super.initState();
    _viewModel = HorseRacingViewModel();

    _gallopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat();

    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _viewModel.addListener(_onViewModelChanged);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _onViewModelChanged() {
    if (_viewModel.status == RaceStatus.running) {
      if (!_gallopController.isAnimating) {
        _gallopController.repeat();
      }
      if (_showGate && _gateTimer == null) {
        _gateTimer = Timer(const Duration(seconds: 1), () {
          if (mounted) setState(() => _showGate = false);
        });
      }
    } else if (_viewModel.status == RaceStatus.paused) {
      _gallopController.stop();
    } else if (_viewModel.status == RaceStatus.completed) {
      _gallopController.stop();
      _overlayController.forward();
    } else if (_viewModel.status == RaceStatus.initial) {
      _gallopController.stop();
      _overlayController.reset();
      _gateTimer?.cancel();
      _gateTimer = null;
      if (!_showGate) setState(() => _showGate = true);
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _gallopController.dispose();
    _overlayController.dispose();
    _gateTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              final leadProgress = _viewModel.horses.isEmpty
                  ? 0.0
                  : _viewModel.horses
                  .map((h) => h.progress)
                  .reduce((a, b) => math.max(a, b));

              // ---------------------------------------------------------
              // TweenAnimationBuilder smoothly interpolates leadProgress
              // between viewmodel ticks. Track AND horses both read this
              // SAME smoothed value → they stay perfectly in sync.
              // ---------------------------------------------------------
              return TweenAnimationBuilder<double>(
                tween: Tween(end: leadProgress),
                duration: const Duration(milliseconds: 80),
                curve: Curves.linear,
                builder: (context, smoothLead, _) {
                  final totalTrackWidth = screenWidth * 3.5;
                  final maxScrollableDistance =
                      totalTrackWidth - screenWidth;
                  final trackScrollOffset =
                  -(maxScrollableDistance * smoothLead);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // ====================================================
                      // 1. SCROLLING TRACK
                      // ====================================================
                      Positioned(
                        left: trackScrollOffset,
                        top: 0,
                        bottom: 0,
                        width: totalTrackWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/top/fullimage.png',
                                fit: BoxFit.fill,
                                repeat: ImageRepeat.repeatX,
                                errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFF0D1B2A)),
                              ),
                            ),
                            SizedBox(
                              width: totalTrackWidth * 0.15,
                              child: Image.asset(
                                'assets/top/MAINFINSHLINE.png',
                                fit: BoxFit.fill,
                                errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFF415A77)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ====================================================
                      // 2. FIXED STARTING GATE
                      // ====================================================
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: screenWidth * 0.14,
                        child: IgnorePointer(
                          child: AnimatedOpacity(
                            opacity: _showGate ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            child: Image.asset(
                              'assets/sprites/GATE.png',
                              fit: BoxFit.fill,
                              errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF1B263B)),
                            ),
                          ),
                        ),
                      ),

                      // ====================================================
                      // 3. HORSES — use smoothLead so they never jitter
                      // ====================================================
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 70,
                            bottom: 0,
                            left: 8.0,
                            right: 16.0,
                          ),
                          child: LayoutBuilder(
                            builder: (context, horseArea) {
                              const double laneHeight = 28.0;
                              final double totalLanes = laneHeight * 6;
                              final double startY =
                                  ((horseArea.maxHeight - totalLanes) / 2) -
                                      40.0;

                              return Stack(
                                children: [
                                  for (int i = 0;
                                  i < _viewModel.horses.length;
                                  i++)
                                    _buildHorsePositioned(
                                      horse: _viewModel.horses[i],
                                      index: i,
                                      laneSpacing: laneHeight,
                                      topOffset: startY,
                                      screenWidth: screenWidth,
                                      smoothLead: smoothLead,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      // ====================================================
                      // 4. TOP HUD
                      // ====================================================
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child:
                        SafeArea(bottom: false, child: _buildTopHud()),
                      ),

                      // ====================================================
                      // 5. FINISH OVERLAY
                      // ====================================================
                      if (_viewModel.status == RaceStatus.completed)
                        _buildRaceFinishOverlay(),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHorsePositioned({
    required HorseModel horse,
    required int index,
    required double laneSpacing,
    required double topOffset,
    required double screenWidth,
    required double smoothLead,
  }) {
    final baseY = topOffset + (index * laneSpacing);

    // Small, smooth jitter for a "galloping pack" look.
    // Only reads _gallopController (which is a repeating animation),
    // so it never fights with the position tween.
    final phase = (_gallopController.value * 2 * math.pi) +
        (index * math.pi / 3);
    final jitter = math.sin(phase) * 8.0;

    double targetX;
    if (smoothLead < 0.10) {
      // Leaving the gate
      final t = (smoothLead / 0.10).clamp(0.0, 1.0);
      targetX = 60.0 + ((screenWidth * 0.38 - 60.0) * t);
    } else if (smoothLead < 0.85) {
      // Running zone — horses cluster around 40% of screen
      final relativeLag =
          (horse.progress - smoothLead) * (screenWidth * 0.5);
      targetX = (screenWidth * 0.40) + relativeLag + jitter;
    } else {
      // Final sprint to the finish line
      final sprintT = ((smoothLead - 0.85) / 0.15).clamp(0.0, 1.0);
      final midX = (screenWidth * 0.40) + jitter;
      final finalCrossX = (screenWidth * 0.82) * horse.progress;
      targetX = (midX * (1.0 - sprintT)) + (finalCrossX * sprintT);
    }

    return Positioned(
      left: targetX.clamp(20.0, screenWidth - 70),
      top: baseY,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HorseTokenWidget(
            horseNumber: horse.id,
            color: horse.color,
            gifPath: horse.gifPath,
          ),
          if (horse.rank != null) ...[
            const SizedBox(width: 4),
            TweenAnimationBuilder<double>(
              key: ValueKey('rank_${horse.id}_${horse.rank}'),
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.elasticOut,
              builder: (context, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${horse.rank}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopHud() {
    final isRunning = _viewModel.status == RaceStatus.running;
    final isLowTime = _viewModel.remainingDuration.inSeconds < 5 &&
        _viewModel.status == RaceStatus.running;

    final pulse = isLowTime
        ? 0.7 + 0.3 * (1 - (_gallopController.value * 2 % 1.0))
        : 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.timer,
                color: isLowTime ? Colors.redAccent : Colors.cyanAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Transform.scale(
                scale: pulse,
                child: Text(
                  _formatDuration(_viewModel.remainingDuration),
                  style: TextStyle(
                    color: isLowTime ? Colors.redAccent : Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orangeAccent),
                ),
                child: Text(
                  HorseRacingViewModel.testMode
                      ? 'TEST MODE (15s)'
                      : '6 HOURS RUN',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isRunning ? Colors.amberAccent : Colors.greenAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                ),
                onPressed: () {
                  if (isRunning) {
                    _viewModel.pause();
                  } else {
                    _viewModel.startOrResume();
                  }
                },
                icon:
                Icon(isRunning ? Icons.pause : Icons.play_arrow, size: 18),
                label: Text(
                  isRunning ? 'PAUSE' : 'START RACE',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                ),
                onPressed: () => _viewModel.reset(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('RESET',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRaceFinishOverlay() {
    return AnimatedBuilder(
      animation: _overlayController,
      builder: (context, child) {
        final curved =
        Curves.easeOutBack.transform(_overlayController.value.clamp(0, 1));
        return Opacity(
          opacity: _overlayController.value.clamp(0, 1),
          child: Transform.scale(
            scale: 0.85 + (0.15 * curved),
            child: child,
          ),
        );
      },
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amberAccent),
              boxShadow: [
                BoxShadow(
                  color: Colors.amberAccent.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.elasticOut,
                  builder: (context, v, child) =>
                      Transform.scale(scale: v, child: child),
                  child: const Icon(Icons.emoji_events,
                      color: Colors.amberAccent, size: 48),
                ),
                const SizedBox(height: 8),
                const Text(
                  'RACE FINISHED!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Winner: ${_viewModel.horses.firstWhere((h) => h.rank == 1).name}',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    _overlayController.reset();
                    _viewModel.reset();
                    _viewModel.startOrResume();
                  },
                  child: const Text('RACE AGAIN',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}