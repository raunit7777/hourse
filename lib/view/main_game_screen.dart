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
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'dust_painter.dart';
import 'hourse_model.dart';
import 'hourse_token.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final HorseRacingViewModel _viewModel;

  late final AnimationController _gallopController;
  late final AnimationController _photoFinishController;

  // Real-time track screenshot capture key & bytes
  final GlobalKey _trackScreenshotKey = GlobalKey();
  Uint8List? _capturedFinishImageBytes;

  bool _showGate = true;
  Timer? _gateTimer;
  bool _hasTriggeredPhoto = false;

  @override
  void initState() {
    super.initState();
    _viewModel = HorseRacingViewModel();

    _gallopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..repeat();

    _photoFinishController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _viewModel.addListener(_onViewModelChanged);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  // Cross hone ke exact moment ka screenshot capture
  Future<void> _captureRaceFinishFrame() async {
    try {
      final boundary = _trackScreenshotKey.currentContext?.findRenderObject()
      as RenderRepaintBoundary?;
      if (boundary != null) {
        final ui.Image image = await boundary.toImage(pixelRatio: 1.5);
        final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null && mounted) {
          setState(() {
            _capturedFinishImageBytes = byteData.buffer.asUint8List();
          });
        }
      }
    } catch (e) {
      debugPrint("Photo Finish Capture Error: $e");
    }
  }

  void _onViewModelChanged() {
    if (_viewModel.status == RaceStatus.running) {
      if (!_gallopController.isAnimating) {
        _gallopController.repeat();
      }
      if (_showGate && _gateTimer == null) {
        _gateTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _showGate = false);
        });
      }
    } else if (_viewModel.status == RaceStatus.paused) {
      _gallopController.stop();
    } else if (_viewModel.status == RaceStatus.completed) {
      if (!_hasTriggeredPhoto) {
        _triggerFinishWithDelay();
      }
    } else if (_viewModel.status == RaceStatus.initial) {
      _gallopController.stop();
      _photoFinishController.reset();
      _hasTriggeredPhoto = false;
      _capturedFinishImageBytes = null;
      _gateTimer?.cancel();
      _gateTimer = null;
      if (!_showGate) setState(() => _showGate = true);
    }
  }

  void _triggerFinishWithDelay() {
    if (_hasTriggeredPhoto) return;
    _hasTriggeredPhoto = true;

    Future.delayed(const Duration(milliseconds: 160), () async {
      await _captureRaceFinishFrame();
      _gallopController.stop();
      if (mounted) _photoFinishController.forward();
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _gallopController.dispose();
    _photoFinishController.dispose();
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

              final winnerHorse = _viewModel.horses.isEmpty
                  ? null
                  : _viewModel.horses
                  .reduce((a, b) => a.progress > b.progress ? a : b);

              if (winnerHorse != null &&
                  winnerHorse.progress >= 0.98 &&
                  !_hasTriggeredPhoto &&
                  _viewModel.status == RaceStatus.running) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _triggerFinishWithDelay();
                });
              }

              return TweenAnimationBuilder<double>(
                tween: Tween<double>(end: leadProgress),
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
                builder: (context, smoothLead, _) {
                  final double finishLineWidth = 120.0;
                  final double totalTrackWidth = screenWidth * 9;
                  final double mainTrackWidth = totalTrackWidth - finishLineWidth;

                  final double maxScrollableDistance = totalTrackWidth - screenWidth;
                  final double trackScrollOffset =
                  -(maxScrollableDistance * smoothLead.clamp(0.0, 1.0));

                  return Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      // ====================================================
                      // CAPTURE AREA: TRACK + EQUAL SIZED HORSES
                      // ====================================================
                      RepaintBoundary(
                        key: _trackScreenshotKey,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            // 1. TRACK
                            Positioned(
                              left: trackScrollOffset,
                              top: 0,
                              bottom: 0,
                              width: totalTrackWidth,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    width: mainTrackWidth,
                                    child: Image.asset(
                                      'assets/top/fullimage.png',
                                      fit: BoxFit.fill,
                                      repeat: ImageRepeat.repeatX,
                                      gaplessPlayback: true,
                                      errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFF0D1B2A)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: finishLineWidth,
                                    child: Image.asset(
                                      'assets/top/MAINFINSHLINE.png',
                                      fit: BoxFit.fill,
                                      gaplessPlayback: true,
                                      errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFF415A77)),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 2. STARTING GATE
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 60,
                              width: screenWidth * 0.14,
                              child: IgnorePointer(
                                child: AnimatedOpacity(
                                  opacity: _showGate ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                  child: Image.asset(
                                    'assets/sprites/GATE.png',
                                    fit: BoxFit.fill,
                                    gaplessPlayback: true,
                                    errorBuilder: (_, __, ___) => Container(
                                        color: const Color(0xFF1B263B)),
                                  ),
                                ),
                              ),
                            ),

                            // 3. 12 HORSES LAYER (SAME SIZE FOR ALL)
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 65,
                                  left: 8.0,
                                  right: 16.0,
                                ),
                                child: LayoutBuilder(
                                  builder: (context, horseArea) {
                                    const double laneHeight = 11;
                                    final double totalLanes = laneHeight * 12;
                                    final double startY = math.max(0.0,
                                        (horseArea.maxHeight - totalLanes) / 2);

                                    return Stack(
                                      clipBehavior: Clip.none,
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
                                            finishLineScreenX:
                                            screenWidth - finishLineWidth + 20,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 4. TOP HUD
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          bottom: false,
                          child: _buildTopHud(),
                        ),
                      ),

                      // 5. BOTTOM JOCKEY RANKING STRIP
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: _buildBottomJockeyBar(),
                        ),
                      ),

                      // 6. SCREENSHOT OVERLAY
                      if (_viewModel.status == RaceStatus.completed ||
                          _hasTriggeredPhoto)
                        _buildRaceFinishOverlay(winnerHorse),
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
    required double finishLineScreenX,
  }) {
    final baseY = topOffset + (index * laneSpacing);

    // 1. Gallop Bobbing (Har ghode ke daudne ka rhythm alag)
    final phase = (_gallopController.value * 2 * math.pi) + (index * 1.57);
    final verticalBob = math.sin(phase) * 0.25;

    // 2. Heavy Natural Stagger & Pack Drift (Aage-Peeche ka gap)
    // Har horse ka apna fixed lane offset taaki ek line me na lagein
    final double naturalStagger = ((index % 4) * 22.0) - ((index % 3) * 18.0) - (index * 4.0);

    final racePhase = smoothLead.clamp(0.0, 1.0) * 10.0 * math.pi;
    // Waves ko thoda bada kiya taaki race me ghode aage-peeche drift hote rahein
    final waveA = math.sin(racePhase + (index * 1.85)) * 38.0;
    final waveB = math.cos((racePhase * 0.6) + (index * 2.7)) * 22.0;

    // Real progress gap ko amplify kiya (0.35 -> 0.70)
    final relativeLeadOffset = (horse.progress - smoothLead) * (screenWidth * 0.70);

    // Smooth wave envelope jo mid-race me maximum spread deta hai
    final smoothEnvelope = math.sin(smoothLead.clamp(0.0, 1.0) * math.pi);
    final dynamicOffset = ((waveA + waveB + naturalStagger) * smoothEnvelope) + relativeLeadOffset;

    // Winner Identification
    final bool isWinner = horse.rank == 1 ||
        (_viewModel.horses.isNotEmpty &&
            horse ==
                _viewModel.horses
                    .reduce((a, b) => a.progress > b.progress ? a : b));

    // Winner ghoda race ke 40% ke baad dheere-dheere pack se 45px clear aage niklega
    final double winnerLeadProgress = Curves.easeInOut.transform(
      ((smoothLead - 0.25) / 0.45).clamp(0.0, 1.0),
    );
    final double winnerExtraLead = isWinner ? (48.0 * winnerLeadProgress) : 0.0;

    // 3. Start Left -> Staggered Mid Pack -> Finish Line Hit
    const double startX = 40.0;
    final double centerPackX = screenWidth * 0.34;

    double targetX;
    if (smoothLead < 0.15) {
      final enterT =
      Curves.easeOutCubic.transform((smoothLead / 0.15).clamp(0.0, 1.0));
      final currentBaseX = startX + ((centerPackX - startX) * enterT);
      targetX = currentBaseX + (dynamicOffset * enterT) + winnerExtraLead;
    } else if (smoothLead <= 0.85) {
      // Pure mid-race me ghode wide cluster me aage-peeche dikhenge
      targetX = centerPackX + dynamicOffset + winnerExtraLead;
    } else {
      // Sprint to finish: Winner aage niklega aur baki ghode piche spread rahenge
      final sprintT = Curves.easeInQuad
          .transform(((smoothLead - 0.85) / 0.15).clamp(0.0, 1.0));

      // Winner finish line cross karega, baki runners apne progress ke according piche rahenge
      final double trailOffset = isWinner ? 35.0 : (-40.0 - (index * 6.0));
      final double endTargetX = finishLineScreenX + trailOffset;

      targetX = (centerPackX * (1.0 - sprintT)) +
          (endTargetX * sprintT) +
          (dynamicOffset * (1.0 - sprintT));
    }

    final isRunning = _viewModel.status == RaceStatus.running;

    return Positioned(
      left: targetX,
      top: baseY + verticalBob,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          if (isRunning && horse.progress < 1.1)
            Positioned(
              left: 4,
              bottom: 1,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _gallopController,
                  builder: (context, _) {
                    return CustomPaint(
                      size: const Size(20, 6),
                      painter: DustCloudPainter(
                        animationValue: _gallopController.value,
                        seed: index,
                      ),
                    );
                  },
                ),
              ),
            ),
          HorseTokenWidget(
            horseNumber: horse.id,
            color: horse.color,
            gifPath: horse.gifPath,
          ),
        ],
      ),
    );
  }

  Widget _buildRaceFinishOverlay([HorseModel? currentLead]) {
    final winner = _viewModel.winnerSnapshot?.horse ??
        currentLead ??
        _viewModel.horses.firstWhere(
              (h) => h.rank == 1,
          orElse: () => _viewModel.horses.first,
        );
    final finishTime = _viewModel.winnerSnapshot?.finishTime ?? "20.00s";

    return AnimatedBuilder(
      animation: _photoFinishController,
      builder: (context, child) {
        final curved = Curves.easeOutBack
            .transform(_photoFinishController.value.clamp(0.0, 1.0));
        return Opacity(
          opacity: _photoFinishController.value.clamp(0.0, 1.0),
          child: Container(
            color: Colors.black.withOpacity(0.85),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: 0.85 + (0.15 * curved),
              child: child,
            ),
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LIVE CROPPED REAL PHOTO FINISH
          Transform.rotate(
            angle: -0.05,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 145,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: _capturedFinishImageBytes != null
                              ? Image.memory(
                            _capturedFinishImageBytes!,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                          )
                              : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.amberAccent,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          color: const Color(0xFF0284C7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '1000m',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(
                                winner.name.toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.yellowAccent,
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          color: Colors.black87,
                          child: const Text(
                            'HORSE RACING\nPHOTO FINISH',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                                height: 1.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildShareIcon(Icons.facebook, const Color(0xFF1877F2)),
                      const SizedBox(width: 4),
                      _buildShareIcon(Icons.close, Colors.black),
                      const SizedBox(width: 4),
                      _buildShareIcon(Icons.share, const Color(0xFFEA4335)),
                      const SizedBox(width: 4),
                      _buildShareIcon(Icons.chat_bubble, const Color(0xFF25D366)),
                      const Spacer(),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.share, size: 11, color: Colors.black87),
                          SizedBox(width: 2),
                          Text(
                            'SHARE',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 32),

          // SCOREBOARD
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RACE FINISHED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'RECORD: 1000m ($finishTime)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'NO BET PLACED',
                style: TextStyle(
                  color: Color(0xFFFBBF24),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                  children: [
                    const TextSpan(
                        text: 'WINNER: ',
                        style: TextStyle(color: Colors.white)),
                    TextSpan(
                      text: '#${winner.id} ${winner.name.toUpperCase()} ',
                      style: const TextStyle(color: Color(0xFFFBBF24)),
                    ),
                    const TextSpan(
                      text: '[ 9.6/10 ]',
                      style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'YOUR BETS: None',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'AUTO-NEXT IN 5 SECONDS...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '12x RUNNERS • 10x PAYOUT WIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _photoFinishController.reset();
                      _hasTriggeredPhoto = false;
                      _capturedFinishImageBytes = null;
                      _viewModel.reset();
                      _viewModel.startOrResume();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, size: 14, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            'NEXT RACE',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFF34D399)),
                    ),
                    child: const Text(
                      'BALANCE: 10090 PTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomJockeyBar() {
    final sortedHorses = List<HorseModel>.from(_viewModel.horses)
      ..sort((a, b) => b.progress.compareTo(a.progress));

    return Container(
      height: 58,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          Container(
            width: 48,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF7F1D1D),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.fiber_manual_record,
                        color: Colors.redAccent, size: 7),
                    SizedBox(width: 2),
                    Text(
                      'LIVE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Text(
                  '1000M',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 7.5,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'TURF DERBY',
                  style: TextStyle(color: Colors.white54, fontSize: 5.5),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                for (int i = 0; i < sortedHorses.length; i++)
                  Expanded(
                    child: _buildJockeyCard(
                      horse: sortedHorses[i],
                      rankIndex: i + 1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJockeyCard({required HorseModel horse, required int rankIndex}) {
    Color rankBg;
    String rankText;
    Widget? crownIcon;

    if (rankIndex == 1) {
      rankBg = const Color(0xFFB45309);
      rankText = '1ST';
      crownIcon =
      const Icon(Icons.emoji_events, color: Colors.amberAccent, size: 8);
    } else if (rankIndex == 2) {
      rankBg = const Color(0xFF1E3A8A);
      rankText = '2ND';
    } else if (rankIndex == 3) {
      rankBg = const Color(0xFF7C2D12);
      rankText = '3RD';
    } else {
      rankBg = Colors.black45;
      rankText = '${rankIndex}TH';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: rankIndex == 1 ? Colors.amberAccent : Colors.white24,
          width: rankIndex == 1 ? 1.0 : 0.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 0.5),
            color: rankBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (crownIcon != null) ...[
                      crownIcon,
                      const SizedBox(width: 1)
                    ],
                    Text(
                      rankText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 6.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: horse.color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Text(
                    '#${horse.id}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 6.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF1E293B),
              child: Image.asset(
                horse.jockeyImagePath,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.person,
                  color: horse.color,
                  size: 16,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 0.5),
            color: Colors.black87,
            child: Text(
              horse.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 6,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareIcon(IconData icon, Color bg) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(icon, color: Colors.white, size: 11),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                size: 18,
              ),
              const SizedBox(width: 8),
              Transform.scale(
                scale: pulse,
                child: Text(
                  _formatDuration(_viewModel.remainingDuration),
                  style: TextStyle(
                    color: isLowTime ? Colors.redAccent : Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: () {
                  if (isRunning) {
                    _viewModel.pause();
                  } else {
                    _viewModel.startOrResume();
                  }
                },
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, size: 16),
                label: Text(
                  isRunning ? 'PAUSE' : 'START RACE',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
                onPressed: () {
                  _photoFinishController.reset();
                  _hasTriggeredPhoto = false;
                  _capturedFinishImageBytes = null;
                  _viewModel.reset();
                },
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('RESET',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}