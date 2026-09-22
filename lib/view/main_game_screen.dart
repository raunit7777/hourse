// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/services.dart';
// // // // import 'package:hours_riding/view/race_status.dart';
// // // //
// // // // import 'hourse_token.dart';
// // // //
// // // // class GameScreen extends StatefulWidget {
// // // //   const GameScreen({super.key});
// // // //
// // // //   @override
// // // //   State<GameScreen> createState() => _GameScreenState();
// // // // }
// // // //
// // // // class _GameScreenState extends State<GameScreen>
// // // //     with TickerProviderStateMixin {
// // // //   late final HorseRacingViewModel _viewModel;
// // // //
// // // //   // Animation controllers
// // // //   late final AnimationController _gateController;
// // // //   late final AnimationController _gallopController;
// // // //   late final AnimationController _overlayController;
// // // //
// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _viewModel = HorseRacingViewModel();
// // // //
// // // //     // Gate opens when race starts
// // // //     _gateController = AnimationController(
// // // //       vsync: this,
// // // //       duration: const Duration(milliseconds: 700),
// // // //     );
// // // //
// // // //     // Continuous gallop/bob cycle
// // // //     _gallopController = AnimationController(
// // // //       vsync: this,
// // // //       duration: const Duration(milliseconds: 380),
// // // //     )..repeat();
// // // //
// // // //     // Finish overlay fade/scale
// // // //     _overlayController = AnimationController(
// // // //       vsync: this,
// // // //       duration: const Duration(milliseconds: 500),
// // // //     );
// // // //
// // // //     _viewModel.addListener(_onViewModelChanged);
// // // //
// // // //     SystemChrome.setPreferredOrientations([
// // // //       DeviceOrientation.landscapeLeft,
// // // //       DeviceOrientation.landscapeRight,
// // // //     ]);
// // // //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
// // // //   }
// // // //
// // // //   void _onViewModelChanged() {
// // // //     if (_viewModel.status == RaceStatus.running) {
// // // //       if (!_gateController.isCompleted) {
// // // //         _gateController.forward();
// // // //       }
// // // //       if (!_gallopController.isAnimating) {
// // // //         _gallopController.repeat();
// // // //       }
// // // //     } else if (_viewModel.status == RaceStatus.paused) {
// // // //       _gallopController.stop();
// // // //     } else if (_viewModel.status == RaceStatus.completed) {
// // // //       _gallopController.stop();
// // // //       _overlayController.forward();
// // // //       _gateController.reverse();
// // // //     } else if (_viewModel.status == RaceStatus.initial) {
// // // //       _gallopController.stop();
// // // //       _overlayController.reset();
// // // //       _gateController.reverse();
// // // //     }
// // // //   }
// // // //
// // // //   @override
// // // //   void dispose() {
// // // //     _viewModel.removeListener(_onViewModelChanged);
// // // //     _viewModel.dispose();
// // // //     _gateController.dispose();
// // // //     _gallopController.dispose();
// // // //     _overlayController.dispose();
// // // //     super.dispose();
// // // //   }
// // // //
// // // //   String _formatDuration(Duration d) {
// // // //     final h = d.inHours.toString().padLeft(2, '0');
// // // //     final m = (d.inMinutes % 60).toString().padLeft(2, '0');
// // // //     final s = (d.inSeconds % 60).toString().padLeft(2, '0');
// // // //     return '$h:$m:$s';
// // // //   }
// // // //
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: Colors.black,
// // // //       body: AnimatedBuilder(
// // // //         animation:
// // // //         Listenable.merge([_viewModel, _gallopController, _gateController]),
// // // //         builder: (context, _) {
// // // //           return Stack(
// // // //             fit: StackFit.expand,
// // // //             children: [
// // // //               // ========================================================
// // // //               // 1. TRACK BACKGROUND
// // // //               // ========================================================
// // // //               Row(
// // // //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// // // //                 children: [
// // // //                   Expanded(
// // // //                     flex: 75,
// // // //                     child: Image.asset(
// // // //                       'assets/top/fullimage.png',
// // // //                       fit: BoxFit.fill,
// // // //                       errorBuilder: (_, __, ___) =>
// // // //                           Container(color: const Color(0xFF16213E)),
// // // //                     ),
// // // //                   ),
// // // //                   Expanded(
// // // //                     flex: 25,
// // // //                     child: Image.asset(
// // // //                       'assets/top/MAINFINSHLINE.png',
// // // //                       fit: BoxFit.fill,
// // // //                       errorBuilder: (_, __, ___) =>
// // // //                           Container(color: const Color(0xFF0F3460)),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //
// // // //               // ========================================================
// // // //               // 2. STARTING GATE (ANIMATED OPEN/CLOSE)
// // // //               // ========================================================
// // // //               Positioned(
// // // //                 left: 0,
// // // //                 top: 55,
// // // //                 bottom: 8,
// // // //                 width: 100,
// // // //                 child: AnimatedBuilder(
// // // //                   animation: _gateController,
// // // //                   builder: (context, child) {
// // // //                     final t = Curves.easeInOut.transform(_gateController.value);
// // // //                     return Transform.translate(
// // // //                       offset: Offset(-80 * t, 0),
// // // //                       child: Opacity(
// // // //                         opacity: 1.0 - (t * 0.8),
// // // //                         child: child,
// // // //                       ),
// // // //                     );
// // // //                   },
// // // //                   child: Image.asset(
// // // //                     'assets/sprites/GATE.png',
// // // //                     fit: BoxFit.fill,
// // // //                     errorBuilder: (_, __, ___) => const SizedBox.shrink(),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //
// // // //               // ========================================================
// // // //               // 3. 6 HORSES (ANIMATED MOVEMENT + GALLOP BOB)
// // // //               // ========================================================
// // // //               SafeArea(
// // // //                 child: Padding(
// // // //                   padding: const EdgeInsets.only(
// // // //                       top: 30.0, bottom: 15, left: 8.0, right: 16.0),
// // // //                   child: LayoutBuilder(
// // // //                     builder: (context, constraints) {
// // // //                       const double compactLaneHeight = 28.0;
// // // //                       final double totalLanesHeight = compactLaneHeight * 6;
// // // //                       final double startY =
// // // //                           (constraints.maxHeight - totalLanesHeight) / 2;
// // // //                       final double trackWidth = constraints.maxWidth - 65;
// // // //
// // // //                       return Stack(
// // // //                         children: [
// // // //                           for (int i = 0; i < _viewModel.horses.length; i++)
// // // //                             _buildHorsePositioned(
// // // //                               horse: _viewModel.horses[i],
// // // //                               index: i,
// // // //                               laneSpacing: compactLaneHeight,
// // // //                               topOffset: startY,
// // // //                               trackWidth: trackWidth,
// // // //                             ),
// // // //                         ],
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //
// // // //               // ========================================================
// // // //               // 4. TOP HUD
// // // //               // ========================================================
// // // //               Positioned(
// // // //                 top: 0,
// // // //                 left: 0,
// // // //                 right: 0,
// // // //                 child: SafeArea(bottom: false, child: _buildTopHud()),
// // // //               ),
// // // //
// // // //               // ========================================================
// // // //               // 5. FINISH OVERLAY (ANIMATED)
// // // //               // ========================================================
// // // //               if (_viewModel.status == RaceStatus.completed)
// // // //                 _buildRaceFinishOverlay(),
// // // //             ],
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildHorsePositioned({
// // // //     required HorseModel horse,
// // // //     required int index,
// // // //     required double laneSpacing,
// // // //     required double topOffset,
// // // //     required double trackWidth,
// // // //   }) {
// // // //     final targetX = 25.0 + (trackWidth * horse.progress);
// // // //     final baseY = topOffset + (index * laneSpacing);
// // // //
// // // //     // Gallop bob: different phase per horse so they don't sync
// // // //     final phase = (_gallopController.value + (index * 0.15)) % 1.0;
// // // //     final bob = (phase < 0.5 ? phase : 1.0 - phase) * 6.0;
// // // //     final isRunning = _viewModel.status == RaceStatus.running;
// // // //     final double bobOffset = isRunning ? -bob : 0.0;
// // // //
// // // //     return AnimatedPositioned(
// // // //       duration: const Duration(milliseconds: 220),
// // // //       curve: Curves.easeOut,
// // // //       left: targetX,
// // // //       top: baseY + bobOffset,
// // // //       child: Row(
// // // //         mainAxisSize: MainAxisSize.min,
// // // //         children: [
// // // //           HorseTokenWidget(
// // // //             horseNumber: horse.id,
// // // //             color: horse.color,
// // // //             gifPath: horse.gifPath,
// // // //           ),
// // // //           if (horse.rank != null) ...[
// // // //             const SizedBox(width: 4),
// // // //             TweenAnimationBuilder<double>(
// // // //               key: ValueKey('rank_${horse.id}_${horse.rank}'),
// // // //               tween: Tween(begin: 0.0, end: 1.0),
// // // //               duration: const Duration(milliseconds: 350),
// // // //               curve: Curves.elasticOut,
// // // //               builder: (context, scale, child) {
// // // //                 return Transform.scale(scale: scale, child: child);
// // // //               },
// // // //               child: Container(
// // // //                 padding:
// // // //                 const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.amberAccent,
// // // //                   borderRadius: BorderRadius.circular(4),
// // // //                 ),
// // // //                 child: Text(
// // // //                   '#${horse.rank}',
// // // //                   style: const TextStyle(
// // // //                     color: Colors.black,
// // // //                     fontSize: 10,
// // // //                     fontWeight: FontWeight.bold,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildTopHud() {
// // // //     final isRunning = _viewModel.status == RaceStatus.running;
// // // //     final isLowTime = _viewModel.remainingDuration.inSeconds < 5 &&
// // // //         _viewModel.status == RaceStatus.running;
// // // //
// // // //     final pulse = isLowTime
// // // //         ? 0.5 + 0.5 * (1 - (_gallopController.value * 2 % 1.0))
// // // //         : 1.0;
// // // //
// // // //     return Container(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// // // //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.black.withOpacity(0.7),
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: Colors.white24),
// // // //       ),
// // // //       child: Row(
// // // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               Icon(
// // // //                 Icons.timer,
// // // //                 color: isLowTime ? Colors.redAccent : Colors.cyanAccent,
// // // //                 size: 20,
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               Transform.scale(
// // // //                 scale: pulse,
// // // //                 child: Text(
// // // //                   _formatDuration(_viewModel.remainingDuration),
// // // //                   style: TextStyle(
// // // //                     color: isLowTime ? Colors.redAccent : Colors.white,
// // // //                     fontFamily: 'monospace',
// // // //                     fontSize: 16,
// // // //                     fontWeight: FontWeight.bold,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 10),
// // // //               Container(
// // // //                 padding:
// // // //                 const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// // // //                 decoration: BoxDecoration(
// // // //                   color: Colors.orangeAccent.withOpacity(0.2),
// // // //                   borderRadius: BorderRadius.circular(4),
// // // //                   border: Border.all(color: Colors.orangeAccent),
// // // //                 ),
// // // //                 child: Text(
// // // //                   HorseRacingViewModel.testMode
// // // //                       ? 'TEST MODE (15s)'
// // // //                       : '6 HOURS RUN',
// // // //                   style: const TextStyle(
// // // //                     color: Colors.orangeAccent,
// // // //                     fontSize: 10,
// // // //                     fontWeight: FontWeight.bold,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           Row(
// // // //             children: [
// // // //               AnimatedContainer(
// // // //                 duration: const Duration(milliseconds: 250),
// // // //                 decoration: BoxDecoration(
// // // //                   borderRadius: BorderRadius.circular(6),
// // // //                   boxShadow: isRunning
// // // //                       ? [
// // // //                     BoxShadow(
// // // //                       color: Colors.amberAccent.withOpacity(0.5),
// // // //                       blurRadius: 10,
// // // //                       spreadRadius: 1,
// // // //                     ),
// // // //                   ]
// // // //                       : [],
// // // //                 ),
// // // //                 child: ElevatedButton.icon(
// // // //                   style: ElevatedButton.styleFrom(
// // // //                     backgroundColor:
// // // //                     isRunning ? Colors.amberAccent : Colors.greenAccent,
// // // //                     foregroundColor: Colors.black,
// // // //                     padding: const EdgeInsets.symmetric(
// // // //                         horizontal: 14, vertical: 8),
// // // //                   ),
// // // //                   onPressed: () {
// // // //                     if (isRunning) {
// // // //                       _viewModel.pause();
// // // //                     } else {
// // // //                       _viewModel.startOrResume();
// // // //                     }
// // // //                   },
// // // //                   icon: AnimatedSwitcher(
// // // //                     duration: const Duration(milliseconds: 250),
// // // //                     transitionBuilder: (child, anim) =>
// // // //                         ScaleTransition(scale: anim, child: child),
// // // //                     child: Icon(
// // // //                       isRunning ? Icons.pause : Icons.play_arrow,
// // // //                       key: ValueKey(isRunning),
// // // //                       size: 18,
// // // //                     ),
// // // //                   ),
// // // //                   label: Text(
// // // //                     isRunning ? 'PAUSE' : 'START RACE',
// // // //                     style: const TextStyle(fontWeight: FontWeight.bold),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 8),
// // // //               OutlinedButton.icon(
// // // //                 style: OutlinedButton.styleFrom(
// // // //                   foregroundColor: Colors.redAccent,
// // // //                   side: const BorderSide(color: Colors.redAccent),
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                       horizontal: 12, vertical: 8),
// // // //                 ),
// // // //                 onPressed: () => _viewModel.reset(),
// // // //                 icon: const Icon(Icons.refresh, size: 18),
// // // //                 label: const Text('RESET',
// // // //                     style: TextStyle(fontWeight: FontWeight.bold)),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // //
// // // //   Widget _buildRaceFinishOverlay() {
// // // //     return AnimatedBuilder(
// // // //       animation: _overlayController,
// // // //       builder: (context, child) {
// // // //         final curved =
// // // //         Curves.easeOutBack.transform(_overlayController.value.clamp(0, 1));
// // // //         return Opacity(
// // // //           opacity: _overlayController.value.clamp(0, 1),
// // // //           child: Transform.scale(
// // // //             scale: 0.85 + (0.15 * curved),
// // // //             child: child,
// // // //           ),
// // // //         );
// // // //       },
// // // //       child: Container(
// // // //         color: Colors.black87,
// // // //         child: Center(
// // // //           child: Container(
// // // //             width: 320,
// // // //             padding: const EdgeInsets.all(20),
// // // //             decoration: BoxDecoration(
// // // //               color: const Color(0xFF1E1E2F),
// // // //               borderRadius: BorderRadius.circular(16),
// // // //               border: Border.all(color: Colors.amberAccent),
// // // //               boxShadow: [
// // // //                 BoxShadow(
// // // //                   color: Colors.amberAccent.withOpacity(0.4),
// // // //                   blurRadius: 20,
// // // //                   spreadRadius: 2,
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             child: Column(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 TweenAnimationBuilder<double>(
// // // //                   tween: Tween(begin: 0.0, end: 1.0),
// // // //                   duration: const Duration(milliseconds: 700),
// // // //                   curve: Curves.elasticOut,
// // // //                   builder: (context, v, child) =>
// // // //                       Transform.scale(scale: v, child: child),
// // // //                   child: const Icon(Icons.emoji_events,
// // // //                       color: Colors.amberAccent, size: 48),
// // // //                 ),
// // // //                 const SizedBox(height: 8),
// // // //                 const Text(
// // // //                   'RACE FINISHED!',
// // // //                   style: TextStyle(
// // // //                     color: Colors.white,
// // // //                     fontSize: 20,
// // // //                     fontWeight: FontWeight.bold,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 12),
// // // //                 Text(
// // // //                   'Winner: ${_viewModel.horses.firstWhere((h) => h.rank == 1).name}',
// // // //                   style: const TextStyle(
// // // //                     color: Colors.greenAccent,
// // // //                     fontSize: 16,
// // // //                     fontWeight: FontWeight.w600,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 16),
// // // //                 ElevatedButton(
// // // //                   style: ElevatedButton.styleFrom(
// // // //                     backgroundColor: Colors.cyanAccent,
// // // //                     foregroundColor: Colors.black,
// // // //                   ),
// // // //                   onPressed: () {
// // // //                     _overlayController.reset();
// // // //                     _viewModel.reset();
// // // //                     _viewModel.startOrResume();
// // // //                   },
// // // //                   child: const Text('RACE AGAIN',
// // // //                       style: TextStyle(fontWeight: FontWeight.bold)),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // //
// // // import 'dart:async';
// // // import 'dart:math' as math;
// // // import 'dart:typed_data';
// // // import 'dart:ui' as ui;
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/rendering.dart';
// // // import 'package:flutter/services.dart';
// // //
// // // import 'dust_painter.dart';
// // // import 'hourse_model.dart';
// // // import 'hourse_token.dart';
// // //
// // // class GameScreen extends StatefulWidget {
// // //   // HorseRacingScreen se aayi hui bets: {horseId: betAmount}
// // //   final Map<int, int> placedBets;
// // //
// // //   const GameScreen({super.key, this.placedBets = const {}});
// // //
// // //   @override
// // //   State<GameScreen> createState() => _GameScreenState();
// // // }
// // //
// // // class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
// // //   late final HorseRacingViewModel _viewModel;
// // //
// // //   late final AnimationController _gallopController;
// // //   late final AnimationController _photoFinishController;
// // //
// // //   // Real-time track screenshot capture key & bytes
// // //   final GlobalKey _trackScreenshotKey = GlobalKey();
// // //   Uint8List? _capturedFinishImageBytes;
// // //
// // //   bool _showGate = true;
// // //   Timer? _gateTimer;
// // //   bool _hasTriggeredPhoto = false;
// // //
// // //   // Race khatam hone ke kuch der baad khud HorseRacingScreen pe wapas jao
// // //   Timer? _autoBackTimer;
// // //
// // //   // Persistent visual ranks for bottom bar (Jitter-free Hysteresis tracking)
// // //   List<int> _currentJockeyOrder = [];
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _viewModel = HorseRacingViewModel();
// // //
// // //     _gallopController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 380),
// // //     )..repeat();
// // //
// // //     _photoFinishController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 600),
// // //     );
// // //
// // //     _viewModel.addListener(_onViewModelChanged);
// // //
// // //     SystemChrome.setPreferredOrientations([
// // //       DeviceOrientation.landscapeLeft,
// // //       DeviceOrientation.landscapeRight,
// // //     ]);
// // //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
// // //
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       _viewModel.startOrResume();
// // //     });
// // //   }
// // //
// // //   Future<void> _captureRaceFinishFrame() async {
// // //     try {
// // //       final boundary = _trackScreenshotKey.currentContext?.findRenderObject()
// // //       as RenderRepaintBoundary?;
// // //       if (boundary != null) {
// // //         final ui.Image image = await boundary.toImage(pixelRatio: 1.5);
// // //         final ByteData? byteData =
// // //         await image.toByteData(format: ui.ImageByteFormat.png);
// // //         if (byteData != null && mounted) {
// // //           setState(() {
// // //             _capturedFinishImageBytes = byteData.buffer.asUint8List();
// // //           });
// // //         }
// // //       }
// // //     } catch (e) {
// // //       debugPrint("Photo Finish Capture Error: $e");
// // //     }
// // //   }
// // //
// // //   void _onViewModelChanged() {
// // //     if (_viewModel.status == RaceStatus.running) {
// // //       if (!_gallopController.isAnimating) {
// // //         _gallopController.repeat();
// // //       }
// // //       if (_showGate && _gateTimer == null) {
// // //         _gateTimer = Timer(const Duration(milliseconds: 500), () {
// // //           if (mounted) setState(() => _showGate = false);
// // //         });
// // //       }
// // //     } else if (_viewModel.status == RaceStatus.paused) {
// // //       _gallopController.stop();
// // //     } else if (_viewModel.status == RaceStatus.completed) {
// // //       if (!_hasTriggeredPhoto) {
// // //         _triggerFinishWithDelay();
// // //       }
// // //     } else if (_viewModel.status == RaceStatus.initial) {
// // //       _gallopController.stop();
// // //       _photoFinishController.reset();
// // //       _hasTriggeredPhoto = false;
// // //       _capturedFinishImageBytes = null;
// // //       _currentJockeyOrder.clear();
// // //       _gateTimer?.cancel();
// // //       _gateTimer = null;
// // //       if (!_showGate) setState(() => _showGate = true);
// // //     }
// // //   }
// // //
// // //   void _triggerFinishWithDelay() {
// // //     if (_hasTriggeredPhoto) return;
// // //     _hasTriggeredPhoto = true;
// // //
// // //     Future.delayed(const Duration(milliseconds: 160), () async {
// // //       await _captureRaceFinishFrame();
// // //       _gallopController.stop();
// // //       if (mounted) _photoFinishController.forward();
// // //
// // //       _autoBackTimer?.cancel();
// // //       _autoBackTimer = Timer(const Duration(seconds: 5), () {
// // //         if (mounted) Navigator.of(context).pop();
// // //       });
// // //     });
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _viewModel.removeListener(_onViewModelChanged);
// // //     _viewModel.dispose();
// // //     _gallopController.dispose();
// // //     _photoFinishController.dispose();
// // //     _gateTimer?.cancel();
// // //     _autoBackTimer?.cancel();
// // //     super.dispose();
// // //   }
// // //
// // //   String _formatDuration(Duration d) {
// // //     final h = d.inHours.toString().padLeft(2, '0');
// // //     final m = (d.inMinutes % 60).toString().padLeft(2, '0');
// // //     final s = (d.inSeconds % 60).toString().padLeft(2, '0');
// // //     return '$h:$m:$s';
// // //   }
// // //
// // //   double _calculateHorseScreenX({
// // //     required HorseModel horse,
// // //     required int index,
// // //     required double screenWidth,
// // //     required double smoothLead,
// // //     required double finishLineScreenX,
// // //   }) {
// // //     final double naturalStagger =
// // //         ((index % 4) * 22.0) - ((index % 3) * 18.0) - (index * 4.0);
// // //
// // //     final racePhase = smoothLead.clamp(0.0, 1.0) * 10.0 * math.pi;
// // //     final waveA = math.sin(racePhase + (index * 1.85)) * 38.0;
// // //     final waveB = math.cos((racePhase * 0.6) + (index * 2.7)) * 22.0;
// // //
// // //     final relativeLeadOffset =
// // //         (horse.progress - smoothLead) * (screenWidth * 0.70);
// // //
// // //     final smoothEnvelope = math.sin(smoothLead.clamp(0.0, 1.0) * math.pi);
// // //     final dynamicOffset =
// // //         ((waveA + waveB + naturalStagger) * smoothEnvelope) + relativeLeadOffset;
// // //
// // //     final bool isWinner = horse.rank == 1 ||
// // //         (_viewModel.horses.isNotEmpty &&
// // //             horse ==
// // //                 _viewModel.horses
// // //                     .reduce((a, b) => a.progress > b.progress ? a : b));
// // //
// // //     final double winnerLeadProgress = Curves.easeInOut.transform(
// // //       ((smoothLead - 0.25) / 0.45).clamp(0.0, 1.0),
// // //     );
// // //     final double winnerExtraLead = isWinner ? (48.0 * winnerLeadProgress) : 0.0;
// // //
// // //     const double startX = 40.0;
// // //     final double centerPackX = screenWidth * 0.34;
// // //
// // //     if (smoothLead < 0.15) {
// // //       final enterT =
// // //       Curves.easeOutCubic.transform((smoothLead / 0.15).clamp(0.0, 1.0));
// // //       final currentBaseX = startX + ((centerPackX - startX) * enterT);
// // //       return currentBaseX + (dynamicOffset * enterT) + winnerExtraLead;
// // //     } else if (smoothLead <= 0.85) {
// // //       return centerPackX + dynamicOffset + winnerExtraLead;
// // //     } else {
// // //       final sprintT = Curves.easeInQuad
// // //           .transform(((smoothLead - 0.85) / 0.15).clamp(0.0, 1.0));
// // //
// // //       final double trailOffset = isWinner ? 35.0 : (-40.0 - (index * 6.0));
// // //       final double endTargetX = finishLineScreenX + trailOffset;
// // //
// // //       return (centerPackX * (1.0 - sprintT)) +
// // //           (endTargetX * sprintT) +
// // //           (dynamicOffset * (1.0 - sprintT));
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.black,
// // //       body: AnimatedBuilder(
// // //         animation: _viewModel,
// // //         builder: (context, _) {
// // //           return LayoutBuilder(
// // //             builder: (context, constraints) {
// // //               final screenWidth = constraints.maxWidth;
// // //
// // //               final leadProgress = _viewModel.horses.isEmpty
// // //                   ? 0.0
// // //                   : _viewModel.horses
// // //                   .map((h) => h.progress)
// // //                   .reduce((a, b) => math.max(a, b));
// // //
// // //               final winnerHorse = _viewModel.horses.isEmpty
// // //                   ? null
// // //                   : _viewModel.horses
// // //                   .reduce((a, b) => a.progress > b.progress ? a : b);
// // //
// // //               if (winnerHorse != null &&
// // //                   winnerHorse.progress >= 0.98 &&
// // //                   !_hasTriggeredPhoto &&
// // //                   _viewModel.status == RaceStatus.running) {
// // //                 WidgetsBinding.instance.addPostFrameCallback((_) {
// // //                   _triggerFinishWithDelay();
// // //                 });
// // //               }
// // //
// // //               return TweenAnimationBuilder<double>(
// // //                 tween: Tween<double>(end: leadProgress),
// // //                 duration: const Duration(milliseconds: 100),
// // //                 curve: Curves.linear,
// // //                 builder: (context, smoothLead, _) {
// // //                   final double finishLineWidth = 120.0;
// // //                   final double totalTrackWidth = screenWidth * 9;
// // //                   final double mainTrackWidth =
// // //                       totalTrackWidth - finishLineWidth;
// // //
// // //                   final double maxScrollableDistance =
// // //                       totalTrackWidth - screenWidth;
// // //                   final double trackScrollOffset =
// // //                   -(maxScrollableDistance * smoothLead.clamp(0.0, 1.0));
// // //
// // //                   final double finishLineScreenX =
// // //                       screenWidth - finishLineWidth + 20;
// // //
// // //                   return Stack(
// // //                     clipBehavior: Clip.none,
// // //                     fit: StackFit.expand,
// // //                     children: [
// // //                       RepaintBoundary(
// // //                         key: _trackScreenshotKey,
// // //                         child: Stack(
// // //                           clipBehavior: Clip.none,
// // //                           fit: StackFit.expand,
// // //                           children: [
// // //                             Positioned(
// // //                               left: trackScrollOffset,
// // //                               top: 0,
// // //                               bottom: 0,
// // //                               width: totalTrackWidth,
// // //                               child: Row(
// // //                                 crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                                 children: [
// // //                                   SizedBox(
// // //                                     width: mainTrackWidth,
// // //                                     child: Image.asset(
// // //                                       'assets/top/fullimage.png',
// // //                                       fit: BoxFit.fitHeight,
// // //                                       repeat: ImageRepeat.repeatX,
// // //                                       gaplessPlayback: true,
// // //                                       errorBuilder: (_, __, ___) => Container(
// // //                                           color: const Color(0xFF0D1B2A)),
// // //                                     ),
// // //                                   ),
// // //                                   SizedBox(
// // //                                     width: finishLineWidth,
// // //                                     child: Image.asset(
// // //                                       'assets/top/MAINFINSHLINE.png',
// // //                                       fit: BoxFit.fill,
// // //                                       gaplessPlayback: true,
// // //                                       errorBuilder: (_, __, ___) => Container(
// // //                                           color: const Color(0xFF415A77)),
// // //                                     ),
// // //                                   ),
// // //                                 ],
// // //                               ),
// // //                             ),
// // //
// // //                             Positioned(
// // //                               left: 0,
// // //                               top: 0,
// // //                               bottom: 60,
// // //                               width: screenWidth * 0.14,
// // //                               child: IgnorePointer(
// // //                                 child: AnimatedOpacity(
// // //                                   opacity: _showGate ? 1.0 : 0.0,
// // //                                   duration: const Duration(milliseconds: 400),
// // //                                   curve: Curves.easeOut,
// // //                                   child: Image.asset(
// // //                                     'assets/sprites/GATE.png',
// // //                                     fit: BoxFit.fill,
// // //                                     gaplessPlayback: true,
// // //                                     errorBuilder: (_, __, ___) => Container(
// // //                                         color: const Color(0xFF1B263B)),
// // //                                   ),
// // //                                 ),
// // //                               ),
// // //                             ),
// // //
// // //                             SafeArea(
// // //                               child: Padding(
// // //                                 padding: const EdgeInsets.only(
// // //                                   top: 0,
// // //                                   bottom: 65,
// // //                                   left: 8.0,
// // //                                   right: 16.0,
// // //                                 ),
// // //                                 child: LayoutBuilder(
// // //                                   builder: (context, horseArea) {
// // //                                     const double laneHeight = 11;
// // //                                     final double totalLanes = laneHeight * 12;
// // //                                     final double startY = math.max(
// // //                                         0.0,
// // //                                         (horseArea.maxHeight - totalLanes) / 2);
// // //
// // //                                     return Stack(
// // //                                       clipBehavior: Clip.none,
// // //                                       children: [
// // //                                         for (int i = 0;
// // //                                         i < _viewModel.horses.length;
// // //                                         i++)
// // //                                           _buildHorsePositioned(
// // //                                             horse: _viewModel.horses[i],
// // //                                             index: i,
// // //                                             laneSpacing: laneHeight,
// // //                                             topOffset: startY,
// // //                                             screenWidth: screenWidth,
// // //                                             smoothLead: smoothLead,
// // //                                             finishLineScreenX:
// // //                                             finishLineScreenX,
// // //                                           ),
// // //                                       ],
// // //                                     );
// // //                                   },
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //
// // //                       Positioned(
// // //                         top: 0,
// // //                         left: 0,
// // //                         right: 0,
// // //                         child: SafeArea(
// // //                           bottom: false,
// // //                           child: _buildTopHud(),
// // //                         ),
// // //                       ),
// // //
// // //                       // BOTTOM JOCKEY RANKING STRIP (Threshold/Margin Based Shuffle)
// // //                       Positioned(
// // //                         left: 0,
// // //                         right: 0,
// // //                         bottom: 0,
// // //                         child: SafeArea(
// // //                           top: false,
// // //                           child: _buildBottomJockeyBar(
// // //                             screenWidth: screenWidth,
// // //                             smoothLead: smoothLead,
// // //                             finishLineScreenX: finishLineScreenX,
// // //                           ),
// // //                         ),
// // //                       ),
// // //
// // //                       if (_viewModel.status == RaceStatus.completed ||
// // //                           _hasTriggeredPhoto)
// // //                         _buildRaceFinishOverlay(winnerHorse),
// // //                     ],
// // //                   );
// // //                 },
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildHorsePositioned({
// // //     required HorseModel horse,
// // //     required int index,
// // //     required double laneSpacing,
// // //     required double topOffset,
// // //     required double screenWidth,
// // //     required double smoothLead,
// // //     required double finishLineScreenX,
// // //   }) {
// // //     final baseY = topOffset + (index * laneSpacing);
// // //
// // //     final phase = (_gallopController.value * 2 * math.pi) + (index * 1.57);
// // //     final verticalBob = math.sin(phase) * 0.25;
// // //
// // //     final double targetX = _calculateHorseScreenX(
// // //       horse: horse,
// // //       index: index,
// // //       screenWidth: screenWidth,
// // //       smoothLead: smoothLead,
// // //       finishLineScreenX: finishLineScreenX,
// // //     );
// // //
// // //     final isRunning = _viewModel.status == RaceStatus.running;
// // //
// // //     return Positioned(
// // //       left: targetX,
// // //       top: baseY + verticalBob,
// // //       child: Stack(
// // //         clipBehavior: Clip.none,
// // //         alignment: Alignment.bottomLeft,
// // //         children: [
// // //           if (isRunning && horse.progress < 1.1) ...[
// // //             Positioned(
// // //               left: -2,
// // //               bottom: -2,
// // //               child: IgnorePointer(
// // //                 child: AnimatedBuilder(
// // //                   animation: _gallopController,
// // //                   builder: (context, _) {
// // //                     return CustomPaint(
// // //                       size: const Size(16, 6),
// // //                       painter: DustCloudPainter(
// // //                         animationValue: _gallopController.value,
// // //                         seed: index * 2,
// // //                       ),
// // //                     );
// // //                   },
// // //                 ),
// // //               ),
// // //             ),
// // //             Positioned(
// // //               left: 24,
// // //               bottom: -2,
// // //               child: IgnorePointer(
// // //                 child: AnimatedBuilder(
// // //                   animation: _gallopController,
// // //                   builder: (context, _) {
// // //                     final frontPhase = (_gallopController.value + 0.35) % 1.0;
// // //                     return CustomPaint(
// // //                       size: const Size(14, 5),
// // //                       painter: DustCloudPainter(
// // //                         animationValue: frontPhase,
// // //                         seed: (index * 2) + 1,
// // //                       ),
// // //                     );
// // //                   },
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //
// // //           HorseTokenWidget(
// // //             horseNumber: horse.id,
// // //             color: horse.color,
// // //             gifPath: horse.gifPath,
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildBottomJockeyBar({
// // //     required double screenWidth,
// // //     required double smoothLead,
// // //     required double finishLineScreenX,
// // //   }) {
// // //     return AnimatedBuilder(
// // //       animation: _gallopController,
// // //       builder: (context, _) {
// // //         final Map<int, double> horseXMap = {};
// // //         for (int i = 0; i < _viewModel.horses.length; i++) {
// // //           final h = _viewModel.horses[i];
// // //           final x = _calculateHorseScreenX(
// // //             horse: h,
// // //             index: i,
// // //             screenWidth: screenWidth,
// // //             smoothLead: smoothLead,
// // //             finishLineScreenX: finishLineScreenX,
// // //           );
// // //           horseXMap[h.id] = x;
// // //         }
// // //
// // //         // Initialize current order once if empty
// // //         if (_currentJockeyOrder.isEmpty ||
// // //             _currentJockeyOrder.length != _viewModel.horses.length) {
// // //           final initialSorted = List<HorseModel>.from(_viewModel.horses)
// // //             ..sort((a, b) =>
// // //                 (horseXMap[b.id] ?? 0).compareTo(horseXMap[a.id] ?? 0));
// // //           _currentJockeyOrder = initialSorted.map((h) => h.id).toList();
// // //         } else {
// // //           // MARGIN/THRESHOLD (HYSTERESIS):
// // //           // Jab tak piche wala ghoda aage wale ghode se at least 15 pixels
// // //           // clear aage na nikal jaye, tab tak rank swap nahi hoga.
// // //           const double overtakeThreshold = 15.0;
// // //
// // //           // Stable bubble pass: swap only when clear margin is crossed
// // //           bool swapped = true;
// // //           int safetyLimit = 0;
// // //           while (swapped && safetyLimit < 12) {
// // //             swapped = false;
// // //             safetyLimit++;
// // //             for (int i = 0; i < _currentJockeyOrder.length - 1; i++) {
// // //               final currentHorseId = _currentJockeyOrder[i];
// // //               final nextHorseId = _currentJockeyOrder[i + 1];
// // //
// // //               final currentX = horseXMap[currentHorseId] ?? 0.0;
// // //               final nextX = horseXMap[nextHorseId] ?? 0.0;
// // //
// // //               // Agar piche wala ghoda threshold se zyada aage nikal gaya:
// // //               if (nextX > currentX + overtakeThreshold) {
// // //                 _currentJockeyOrder[i] = nextHorseId;
// // //                 _currentJockeyOrder[i + 1] = currentHorseId;
// // //                 swapped = true;
// // //               }
// // //             }
// // //           }
// // //         }
// // //
// // //         // Build rank index map
// // //         final Map<int, int> rankMap = {};
// // //         for (int i = 0; i < _currentJockeyOrder.length; i++) {
// // //           rankMap[_currentJockeyOrder[i]] = i;
// // //         }
// // //
// // //         return Container(
// // //           height: 58,
// // //           color: const Color(0xFF0F172A),
// // //           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
// // //           child: Row(
// // //             children: [
// // //               Container(
// // //                 width: 48,
// // //                 margin: const EdgeInsets.only(right: 4),
// // //                 decoration: BoxDecoration(
// // //                   color: const Color(0xFF7F1D1D),
// // //                   borderRadius: BorderRadius.circular(3),
// // //                   border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
// // //                 ),
// // //                 child: const Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     Row(
// // //                       mainAxisAlignment: MainAxisAlignment.center,
// // //                       children: [
// // //                         Icon(Icons.fiber_manual_record,
// // //                             color: Colors.redAccent, size: 7),
// // //                         SizedBox(width: 2),
// // //                         Text(
// // //                           'LIVE',
// // //                           style: TextStyle(
// // //                               color: Colors.white,
// // //                               fontSize: 8,
// // //                               fontWeight: FontWeight.w900),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     Text(
// // //                       '1000M',
// // //                       style: TextStyle(
// // //                           color: Colors.white,
// // //                           fontSize: 7.5,
// // //                           fontWeight: FontWeight.bold),
// // //                     ),
// // //                     Text(
// // //                       'TURF DERBY',
// // //                       style: TextStyle(color: Colors.white54, fontSize: 5.5),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               Expanded(
// // //                 child: LayoutBuilder(
// // //                   builder: (context, boxConstraints) {
// // //                     final totalAvailableWidth = boxConstraints.maxWidth;
// // //                     final totalHorses = _viewModel.horses.length;
// // //                     if (totalHorses == 0) return const SizedBox.shrink();
// // //
// // //                     final cardWidth = totalAvailableWidth / totalHorses;
// // //
// // //                     return Stack(
// // //                       clipBehavior: Clip.none,
// // //                       children: [
// // //                         for (final horse in _viewModel.horses)
// // //                           AnimatedPositioned(
// // //                             key: ValueKey('jockey_card_${horse.id}'),
// // //                             duration: const Duration(milliseconds: 320),
// // //                             curve: Curves.easeInOutCubic,
// // //                             left: (rankMap[horse.id] ?? 0) * cardWidth,
// // //                             top: 0,
// // //                             bottom: 0,
// // //                             width: cardWidth,
// // //                             child: _buildJockeyCard(
// // //                               horse: horse,
// // //                               rankIndex: (rankMap[horse.id] ?? 0) + 1,
// // //                             ),
// // //                           ),
// // //                       ],
// // //                     );
// // //                   },
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildJockeyCard({required HorseModel horse, required int rankIndex}) {
// // //     Color rankBg;
// // //     String rankText;
// // //     Widget? crownIcon;
// // //
// // //     if (rankIndex == 1) {
// // //       rankBg = const Color(0xFFB45309);
// // //       rankText = '1ST';
// // //       crownIcon =
// // //       const Icon(Icons.emoji_events, color: Colors.amberAccent, size: 8);
// // //     } else if (rankIndex == 2) {
// // //       rankBg = const Color(0xFF1E3A8A);
// // //       rankText = '2ND';
// // //     } else if (rankIndex == 3) {
// // //       rankBg = const Color(0xFF7C2D12);
// // //       rankText = '3RD';
// // //     } else {
// // //       rankBg = Colors.black45;
// // //       rankText = '${rankIndex}TH';
// // //     }
// // //
// // //     final bool hasBet = (widget.placedBets[horse.id] ?? 0) > 0;
// // //
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 1.2),
// // //       decoration: BoxDecoration(
// // //         color: Colors.black.withOpacity(0.6),
// // //         borderRadius: BorderRadius.circular(2),
// // //         border: Border.all(
// // //           color: hasBet
// // //               ? const Color(0xFFFFD000)
// // //               : (rankIndex == 1 ? Colors.amberAccent : Colors.white24),
// // //           width: hasBet ? 1.4 : (rankIndex == 1 ? 1.0 : 0.5),
// // //         ),
// // //       ),
// // //       child: Column(
// // //         children: [
// // //           Container(
// // //             padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 0.5),
// // //             color: rankBg,
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 Row(
// // //                   mainAxisSize: MainAxisSize.min,
// // //                   children: [
// // //                     if (crownIcon != null) ...[
// // //                       crownIcon,
// // //                       const SizedBox(width: 1)
// // //                     ],
// // //                     Text(
// // //                       rankText,
// // //                       style: const TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 6.5,
// // //                         fontWeight: FontWeight.w900,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 2),
// // //                   decoration: BoxDecoration(
// // //                     color: horse.color.withOpacity(0.8),
// // //                     borderRadius: BorderRadius.circular(1),
// // //                   ),
// // //                   child: Text(
// // //                     '#${horse.id}',
// // //                     style: const TextStyle(
// // //                       color: Colors.black,
// // //                       fontSize: 6.5,
// // //                       fontWeight: FontWeight.w900,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           Expanded(
// // //             child: Container(
// // //               width: double.infinity,
// // //               color: const Color(0xFF1E293B),
// // //               child: Image.asset(
// // //                 horse.jockeyImagePath,
// // //                 fit: BoxFit.cover,
// // //                 gaplessPlayback: true,
// // //                 errorBuilder: (_, __, ___) => Icon(
// // //                   Icons.person,
// // //                   color: horse.color,
// // //                   size: 16,
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //           Container(
// // //             width: double.infinity,
// // //             padding: const EdgeInsets.symmetric(vertical: 0.5),
// // //             color: Colors.black87,
// // //             child: Text(
// // //               horse.name,
// // //               textAlign: TextAlign.center,
// // //               maxLines: 1,
// // //               overflow: TextOverflow.ellipsis,
// // //               style: const TextStyle(
// // //                 color: Colors.white,
// // //                 fontSize: 6,
// // //                 fontWeight: FontWeight.w800,
// // //                 letterSpacing: 0.1,
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildRaceFinishOverlay([HorseModel? currentLead]) {
// // //     final winner = _viewModel.winnerSnapshot?.horse ??
// // //         currentLead ??
// // //         _viewModel.horses.firstWhere(
// // //               (h) => h.rank == 1,
// // //           orElse: () => _viewModel.horses.first,
// // //         );
// // //     final finishTime = _viewModel.winnerSnapshot?.finishTime ?? "20.00s";
// // //
// // //     final int winnerBet = widget.placedBets[winner.id] ?? 0;
// // //     final int totalBetAmount =
// // //     widget.placedBets.values.fold(0, (sum, v) => sum + v);
// // //     final bool hasAnyBet = totalBetAmount > 0;
// // //     final int winAmount = winnerBet * 3;
// // //
// // //     return AnimatedBuilder(
// // //       animation: _photoFinishController,
// // //       builder: (context, child) {
// // //         final curved = Curves.easeOutBack
// // //             .transform(_photoFinishController.value.clamp(0.0, 1.0));
// // //         return Opacity(
// // //           opacity: _photoFinishController.value.clamp(0.0, 1.0),
// // //           child: Container(
// // //             color: Colors.black.withOpacity(0.85),
// // //             alignment: Alignment.center,
// // //             child: Transform.scale(
// // //               scale: 0.85 + (0.15 * curved),
// // //               child: child,
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         crossAxisAlignment: CrossAxisAlignment.center,
// // //         children: [
// // //           Transform.rotate(
// // //             angle: -0.05,
// // //             child: Container(
// // //               width: 280,
// // //               padding: const EdgeInsets.all(8),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(4),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: Colors.black.withOpacity(0.6),
// // //                     blurRadius: 18,
// // //                     offset: const Offset(0, 8),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: Column(
// // //                 mainAxisSize: MainAxisSize.min,
// // //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                 children: [
// // //                   Stack(
// // //                     children: [
// // //                       Container(
// // //                         height: 145,
// // //                         width: double.infinity,
// // //                         decoration: BoxDecoration(
// // //                           color: const Color(0xFF1E293B),
// // //                           borderRadius: BorderRadius.circular(2),
// // //                         ),
// // //                         child: ClipRRect(
// // //                           borderRadius: BorderRadius.circular(2),
// // //                           child: _capturedFinishImageBytes != null
// // //                               ? Image.memory(
// // //                             _capturedFinishImageBytes!,
// // //                             fit: BoxFit.cover,
// // //                             alignment: Alignment.centerRight,
// // //                           )
// // //                               : const Center(
// // //                             child: CircularProgressIndicator(
// // //                               color: Colors.amberAccent,
// // //                               strokeWidth: 2,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Positioned(
// // //                         top: 6,
// // //                         right: 6,
// // //                         child: Container(
// // //                           padding: const EdgeInsets.symmetric(
// // //                               horizontal: 6, vertical: 2),
// // //                           color: const Color(0xFF0284C7),
// // //                           child: Column(
// // //                             crossAxisAlignment: CrossAxisAlignment.end,
// // //                             children: [
// // //                               const Text(
// // //                                 '1000m',
// // //                                 style: TextStyle(
// // //                                     color: Colors.white,
// // //                                     fontSize: 10,
// // //                                     fontWeight: FontWeight.w900),
// // //                               ),
// // //                               Text(
// // //                                 winner.name.toUpperCase(),
// // //                                 style: const TextStyle(
// // //                                     color: Colors.yellowAccent,
// // //                                     fontSize: 7,
// // //                                     fontWeight: FontWeight.bold),
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       Positioned(
// // //                         top: 6,
// // //                         left: 6,
// // //                         child: Container(
// // //                           padding: const EdgeInsets.symmetric(
// // //                               horizontal: 4, vertical: 2),
// // //                           color: Colors.black87,
// // //                           child: const Text(
// // //                             'HORSE RACING\nPHOTO FINISH',
// // //                             style: TextStyle(
// // //                                 color: Colors.white,
// // //                                 fontSize: 7,
// // //                                 fontWeight: FontWeight.bold,
// // //                                 height: 1.1),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   const SizedBox(height: 6),
// // //                   Row(
// // //                     children: [
// // //                       _buildShareIcon(Icons.facebook, const Color(0xFF1877F2)),
// // //                       const SizedBox(width: 4),
// // //                       _buildShareIcon(Icons.close, Colors.black),
// // //                       const SizedBox(width: 4),
// // //                       _buildShareIcon(Icons.share, const Color(0xFFEA4335)),
// // //                       const SizedBox(width: 4),
// // //                       _buildShareIcon(Icons.chat_bubble, const Color(0xFF25D366)),
// // //                       const Spacer(),
// // //                       const Row(
// // //                         mainAxisSize: MainAxisSize.min,
// // //                         children: [
// // //                           Icon(Icons.share, size: 11, color: Colors.black87),
// // //                           SizedBox(width: 2),
// // //                           Text(
// // //                             'SHARE',
// // //                             style: TextStyle(
// // //                                 color: Colors.black87,
// // //                                 fontSize: 10,
// // //                                 fontWeight: FontWeight.bold),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //           const SizedBox(width: 32),
// // //           Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               const Text(
// // //                 'RACE FINISHED',
// // //                 style: TextStyle(
// // //                   color: Colors.white,
// // //                   fontSize: 26,
// // //                   fontWeight: FontWeight.w900,
// // //                   letterSpacing: 1.1,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 4),
// // //               Text(
// // //                 'RECORD: 1000m ($finishTime)',
// // //                 style: const TextStyle(
// // //                   color: Colors.white,
// // //                   fontSize: 13,
// // //                   fontWeight: FontWeight.w800,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 6),
// // //               Text(
// // //                 hasAnyBet
// // //                     ? (winnerBet > 0 ? 'YOU WON!' : 'BETTER LUCK NEXT TIME')
// // //                     : 'NO BET PLACED',
// // //                 style: TextStyle(
// // //                   color: hasAnyBet && winnerBet > 0
// // //                       ? const Color(0xFF34D399)
// // //                       : const Color(0xFFFBBF24),
// // //                   fontSize: 14,
// // //                   fontWeight: FontWeight.w900,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 6),
// // //               RichText(
// // //                 text: TextSpan(
// // //                   style:
// // //                   const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
// // //                   children: [
// // //                     const TextSpan(
// // //                         text: 'WINNER: ',
// // //                         style: TextStyle(color: Colors.white)),
// // //                     TextSpan(
// // //                       text: '#${winner.id} ${winner.name.toUpperCase()} ',
// // //                       style: const TextStyle(color: Color(0xFFFBBF24)),
// // //                     ),
// // //                     const TextSpan(
// // //                       text: '[ 9.6/10 ]',
// // //                       style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 4),
// // //               Text(
// // //                 hasAnyBet
// // //                     ? 'YOUR BETS: ${widget.placedBets.entries.map((e) => '#${e.key}:${e.value}').join(', ')}'
// // //                     : 'YOUR BETS: None',
// // //                 style: const TextStyle(
// // //                   color: Colors.white,
// // //                   fontSize: 13,
// // //                   fontWeight: FontWeight.w800,
// // //                 ),
// // //               ),
// // //               if (winnerBet > 0) ...[
// // //                 const SizedBox(height: 4),
// // //                 Text(
// // //                   'YOU WIN: $winAmount PTS',
// // //                   style: const TextStyle(
// // //                     color: Color(0xFF34D399),
// // //                     fontSize: 13,
// // //                     fontWeight: FontWeight.w900,
// // //                   ),
// // //                 ),
// // //               ],
// // //               const SizedBox(height: 4),
// // //               const Text(
// // //                 'GOING BACK IN 5 SECONDS...',
// // //                 style: TextStyle(
// // //                   color: Colors.white70,
// // //                   fontSize: 12,
// // //                   fontWeight: FontWeight.w700,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 2),
// // //               const Text(
// // //                 '12x RUNNERS • 3x PAYOUT WIN',
// // //                 style: TextStyle(
// // //                   color: Colors.white,
// // //                   fontSize: 12,
// // //                   fontWeight: FontWeight.w900,
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               Row(
// // //                 children: [
// // //                   InkWell(
// // //                     onTap: () {
// // //                       Navigator.of(context).pop();
// // //                     },
// // //                     child: Container(
// // //                       padding: const EdgeInsets.symmetric(
// // //                           horizontal: 10, vertical: 6),
// // //                       decoration: BoxDecoration(
// // //                         color: Colors.white,
// // //                         borderRadius: BorderRadius.circular(4),
// // //                       ),
// // //                       child: const Row(
// // //                         mainAxisSize: MainAxisSize.min,
// // //                         children: [
// // //                           Icon(Icons.refresh, size: 14, color: Colors.black),
// // //                           SizedBox(width: 4),
// // //                           Text(
// // //                             'NEXT RACE',
// // //                             style: TextStyle(
// // //                               color: Colors.black,
// // //                               fontSize: 11,
// // //                               fontWeight: FontWeight.w900,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 10),
// // //                   Container(
// // //                     padding: const EdgeInsets.symmetric(
// // //                         horizontal: 10, vertical: 6),
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xFF059669),
// // //                       borderRadius: BorderRadius.circular(4),
// // //                       border: Border.all(color: const Color(0xFF34D399)),
// // //                     ),
// // //                     child: const Text(
// // //                       'BALANCE: 10090 PTS',
// // //                       style: TextStyle(
// // //                         color: Colors.white,
// // //                         fontSize: 11,
// // //                         fontWeight: FontWeight.w900,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildShareIcon(IconData icon, Color bg) {
// // //     return Container(
// // //       width: 18,
// // //       height: 18,
// // //       decoration: BoxDecoration(
// // //         color: bg,
// // //         borderRadius: BorderRadius.circular(2),
// // //       ),
// // //       child: Icon(icon, color: Colors.white, size: 11),
// // //     );
// // //   }
// // //
// // //   Widget _buildTopHud() {
// // //     final isRunning = _viewModel.status == RaceStatus.running;
// // //     final isLowTime = _viewModel.remainingDuration.inSeconds < 5 &&
// // //         _viewModel.status == RaceStatus.running;
// // //
// // //     final pulse = isLowTime
// // //         ? 0.7 + 0.3 * (1 - (_gallopController.value * 2 % 1.0))
// // //         : 1.0;
// // //
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// // //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// // //       decoration: BoxDecoration(
// // //         color: Colors.black.withOpacity(0.7),
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.white24),
// // //       ),
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Icon(
// // //                 Icons.timer,
// // //                 color: isLowTime ? Colors.redAccent : Colors.cyanAccent,
// // //                 size: 18,
// // //               ),
// // //               const SizedBox(width: 8),
// // //               Transform.scale(
// // //                 scale: pulse,
// // //                 child: Text(
// // //                   _formatDuration(_viewModel.remainingDuration),
// // //                   style: TextStyle(
// // //                     color: isLowTime ? Colors.redAccent : Colors.white,
// // //                     fontFamily: 'monospace',
// // //                     fontSize: 15,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 10),
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.orangeAccent.withOpacity(0.2),
// // //                   borderRadius: BorderRadius.circular(4),
// // //                   border: Border.all(color: Colors.orangeAccent),
// // //                 ),
// // //                 child: Text(
// // //                   HorseRacingViewModel.testMode
// // //                       ? 'TEST MODE (15s)'
// // //                       : '6 HOURS RUN',
// // //                   style: const TextStyle(
// // //                     color: Colors.orangeAccent,
// // //                     fontSize: 10,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           Row(
// // //             children: [
// // //               ElevatedButton.icon(
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor:
// // //                   isRunning ? Colors.amberAccent : Colors.greenAccent,
// // //                   foregroundColor: Colors.black,
// // //                   padding:
// // //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// // //                 ),
// // //                 onPressed: () {
// // //                   if (isRunning) {
// // //                     _viewModel.pause();
// // //                   } else {
// // //                     _viewModel.startOrResume();
// // //                   }
// // //                 },
// // //                 icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, size: 16),
// // //                 label: Text(
// // //                   isRunning ? 'PAUSE' : 'START RACE',
// // //                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 8),
// // //               OutlinedButton.icon(
// // //                 style: OutlinedButton.styleFrom(
// // //                   foregroundColor: Colors.redAccent,
// // //                   side: const BorderSide(color: Colors.redAccent),
// // //                   padding:
// // //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// // //                 ),
// // //                 onPressed: () {
// // //                   _photoFinishController.reset();
// // //                   _hasTriggeredPhoto = false;
// // //                   _capturedFinishImageBytes = null;
// // //                   _currentJockeyOrder.clear();
// // //                   _viewModel.reset();
// // //                 },
// // //                 icon: const Icon(Icons.refresh, size: 16),
// // //                 label: const Text('RESET',
// // //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'dart:async';
// // import 'dart:math' as math;
// // import 'dart:typed_data';
// // import 'dart:ui' as ui;
// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// // import 'package:flutter/services.dart';
// //
// // import 'dust_painter.dart';
// // import 'hourse_model.dart';
// // import 'hourse_token.dart';
// //
// // class GameScreen extends StatefulWidget {
// //   final Map<int, int> placedBets;
// //
// //   const GameScreen({super.key, this.placedBets = const {}});
// //
// //   @override
// //   State<GameScreen> createState() => _GameScreenState();
// // }
// //
// // class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
// //   late final HorseRacingViewModel _viewModel;
// //
// //   late final AnimationController _gallopController;
// //   late final AnimationController _photoFinishController;
// //
// //   final GlobalKey _trackScreenshotKey = GlobalKey();
// //   Uint8List? _capturedFinishImageBytes;
// //
// //   bool _showGate = true;
// //   Timer? _gateTimer;
// //   bool _hasTriggeredPhoto = false;
// //
// //   Timer? _autoBackTimer;
// //
// //   // Persistent visual ranks for bottom bar (Jitter-free Hysteresis tracking)
// //   List<int> _currentJockeyOrder = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _viewModel = HorseRacingViewModel();
// //
// //     _gallopController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 380),
// //     )..repeat();
// //
// //     _photoFinishController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 600),
// //     );
// //
// //     _viewModel.addListener(_onViewModelChanged);
// //
// //     SystemChrome.setPreferredOrientations([
// //       DeviceOrientation.landscapeLeft,
// //       DeviceOrientation.landscapeRight,
// //     ]);
// //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
// //
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       _viewModel.startOrResume();
// //     });
// //   }
// //
// //   Future<void> _captureRaceFinishFrame() async {
// //     try {
// //       final boundary = _trackScreenshotKey.currentContext?.findRenderObject()
// //       as RenderRepaintBoundary?;
// //       if (boundary != null) {
// //         final ui.Image image = await boundary.toImage(pixelRatio: 1.5);
// //         final ByteData? byteData =
// //         await image.toByteData(format: ui.ImageByteFormat.png);
// //         if (byteData != null && mounted) {
// //           setState(() {
// //             _capturedFinishImageBytes = byteData.buffer.asUint8List();
// //           });
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint("Photo Finish Capture Error: $e");
// //     }
// //   }
// //
// //   void _onViewModelChanged() {
// //     if (_viewModel.status == RaceStatus.running) {
// //       if (!_gallopController.isAnimating) {
// //         _gallopController.repeat();
// //       }
// //       if (_showGate && _gateTimer == null) {
// //         _gateTimer = Timer(const Duration(milliseconds: 500), () {
// //           if (mounted) setState(() => _showGate = false);
// //         });
// //       }
// //     } else if (_viewModel.status == RaceStatus.paused) {
// //       _gallopController.stop();
// //     } else if (_viewModel.status == RaceStatus.completed) {
// //       if (!_hasTriggeredPhoto) {
// //         _triggerFinishWithDelay();
// //       }
// //     } else if (_viewModel.status == RaceStatus.initial) {
// //       _gallopController.stop();
// //       _photoFinishController.reset();
// //       _hasTriggeredPhoto = false;
// //       _capturedFinishImageBytes = null;
// //       _currentJockeyOrder.clear();
// //       _gateTimer?.cancel();
// //       _gateTimer = null;
// //       if (!_showGate) setState(() => _showGate = true);
// //     }
// //   }
// //
// //   void _triggerFinishWithDelay() {
// //     if (_hasTriggeredPhoto) return;
// //     _hasTriggeredPhoto = true;
// //
// //     Future.delayed(const Duration(milliseconds: 160), () async {
// //       await _captureRaceFinishFrame();
// //       _gallopController.stop();
// //       if (mounted) _photoFinishController.forward();
// //
// //       _autoBackTimer?.cancel();
// //       _autoBackTimer = Timer(const Duration(seconds: 5), () {
// //         if (mounted) Navigator.of(context).pop();
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _viewModel.removeListener(_onViewModelChanged);
// //     _viewModel.dispose();
// //     _gallopController.dispose();
// //     _photoFinishController.dispose();
// //     _gateTimer?.cancel();
// //     _autoBackTimer?.cancel();
// //     super.dispose();
// //   }
// //
// //   String _formatDuration(Duration d) {
// //     final h = d.inHours.toString().padLeft(2, '0');
// //     final m = (d.inMinutes % 60).toString().padLeft(2, '0');
// //     final s = (d.inSeconds % 60).toString().padLeft(2, '0');
// //     return '$h:$m:$s';
// //   }
// //
// //   double _calculateHorseScreenX({
// //     required HorseModel horse,
// //     required int index,
// //     required double screenWidth,
// //     required double smoothLead,
// //     required double finishLineScreenX,
// //   }) {
// //     final double naturalStagger =
// //         ((index % 4) * 22.0) - ((index % 3) * 18.0) - (index * 4.0);
// //
// //     final racePhase = smoothLead.clamp(0.0, 1.0) * 10.0 * math.pi;
// //     final waveA = math.sin(racePhase + (index * 1.85)) * 38.0;
// //     final waveB = math.cos((racePhase * 0.6) + (index * 2.7)) * 22.0;
// //
// //     final relativeLeadOffset =
// //         (horse.progress - smoothLead) * (screenWidth * 0.70);
// //
// //     final smoothEnvelope = math.sin(smoothLead.clamp(0.0, 1.0) * math.pi);
// //     final dynamicOffset =
// //         ((waveA + waveB + naturalStagger) * smoothEnvelope) + relativeLeadOffset;
// //
// //     final bool isWinner = horse.rank == 1 ||
// //         (_viewModel.horses.isNotEmpty &&
// //             horse ==
// //                 _viewModel.horses
// //                     .reduce((a, b) => a.progress > b.progress ? a : b));
// //
// //     final double winnerLeadProgress = Curves.easeInOut.transform(
// //       ((smoothLead - 0.25) / 0.45).clamp(0.0, 1.0),
// //     );
// //     final double winnerExtraLead = isWinner ? (48.0 * winnerLeadProgress) : 0.0;
// //
// //     const double startX = 40.0;
// //     final double centerPackX = screenWidth * 0.34;
// //
// //     if (smoothLead < 0.15) {
// //       final enterT =
// //       Curves.easeOutCubic.transform((smoothLead / 0.15).clamp(0.0, 1.0));
// //       final currentBaseX = startX + ((centerPackX - startX) * enterT);
// //       return currentBaseX + (dynamicOffset * enterT) + winnerExtraLead;
// //     } else if (smoothLead <= 0.85) {
// //       return centerPackX + dynamicOffset + winnerExtraLead;
// //     } else {
// //       final sprintT = Curves.easeInQuad
// //           .transform(((smoothLead - 0.85) / 0.15).clamp(0.0, 1.0));
// //
// //       final double trailOffset = isWinner ? 35.0 : (-40.0 - (index * 6.0));
// //       final double endTargetX = finishLineScreenX + trailOffset;
// //
// //       return (centerPackX * (1.0 - sprintT)) +
// //           (endTargetX * sprintT) +
// //           (dynamicOffset * (1.0 - sprintT));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: AnimatedBuilder(
// //         animation: _viewModel,
// //         builder: (context, _) {
// //           return LayoutBuilder(
// //             builder: (context, constraints) {
// //               final screenWidth = constraints.maxWidth;
// //
// //               final leadProgress = _viewModel.horses.isEmpty
// //                   ? 0.0
// //                   : _viewModel.horses
// //                   .map((h) => h.progress)
// //                   .reduce((a, b) => math.max(a, b));
// //
// //               final winnerHorse = _viewModel.horses.isEmpty
// //                   ? null
// //                   : _viewModel.horses
// //                   .reduce((a, b) => a.progress > b.progress ? a : b);
// //
// //               if (winnerHorse != null &&
// //                   winnerHorse.progress >= 0.98 &&
// //                   !_hasTriggeredPhoto &&
// //                   _viewModel.status == RaceStatus.running) {
// //                 WidgetsBinding.instance.addPostFrameCallback((_) {
// //                   _triggerFinishWithDelay();
// //                 });
// //               }
// //
// //               return TweenAnimationBuilder<double>(
// //                 tween: Tween<double>(end: leadProgress),
// //                 duration: const Duration(milliseconds: 100),
// //                 curve: Curves.linear,
// //                 builder: (context, smoothLead, _) {
// //                   // Track width 8.5 screen rakhte hain
// //                   final double mainTrackWidth = screenWidth * 8.5;
// //                   // Finish line natural width leti hai, scroll offset ke liye comfortable margin
// //                   final double approximateTotalWidth = mainTrackWidth + screenWidth;
// //                   final double maxScrollableDistance =
// //                       approximateTotalWidth - screenWidth;
// //                   final double trackScrollOffset =
// //                   -(maxScrollableDistance * smoothLead.clamp(0.0, 1.0));
// //
// //                   // Screen par finish line aane par horses ka target
// //                   final double finishLineScreenX = screenWidth * 0.72;
// //
// //                   return Stack(
// //                     clipBehavior: Clip.none,
// //                     fit: StackFit.expand,
// //                     children: [
// //                       // ====================================================
// //                       // CAPTURE AREA: TRACK + NATURAL FINISH LINE IMAGE + HORSES
// //                       // ====================================================
// //                       RepaintBoundary(
// //                         key: _trackScreenshotKey,
// //                         child: Stack(
// //                           clipBehavior: Clip.none,
// //                           fit: StackFit.expand,
// //                           children: [
// //                             // 1. TRACK & SEPARATE FINISH LINE
// //                             Positioned(
// //                               left: trackScrollOffset,
// //                               top: 0,
// //                               bottom: 0,
// //                               child: Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                                 children: [
// //                                   // Running loop track
// //                                   SizedBox(
// //                                     width: mainTrackWidth,
// //                                     child: Image.asset(
// //                                       'assets/top/fullimage.png',
// //                                       fit: BoxFit.fitHeight,
// //                                       repeat: ImageRepeat.repeatX,
// //                                       gaplessPlayback: true,
// //                                       errorBuilder: (_, __, ___) => Container(
// //                                           color: const Color(0xFF0D1B2A)),
// //                                     ),
// //                                   ),
// //                                   // Bilkul alag Finish line image: apne natural aspect ratio me
// //                                   // Bina kisi fixed narrow width ke taaki dono side se dabey nahi!
// //                                   Image.asset(
// //                                     'assets/top/MAINFINSHLINE.png',
// //                                     fit: BoxFit.fitHeight,
// //                                     gaplessPlayback: true,
// //                                     errorBuilder: (_, __, ___) => Container(
// //                                       width: 200,
// //                                       color: const Color(0xFF415A77),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //
// //                             // 2. STARTING GATE
// //                             Positioned(
// //                               left: 0,
// //                               top: 0,
// //                               bottom: 60,
// //                               width: screenWidth * 0.14,
// //                               child: IgnorePointer(
// //                                 child: AnimatedOpacity(
// //                                   opacity: _showGate ? 1.0 : 0.0,
// //                                   duration: const Duration(milliseconds: 400),
// //                                   curve: Curves.easeOut,
// //                                   child: Image.asset(
// //                                     'assets/sprites/GATE.png',
// //                                     fit: BoxFit.fill,
// //                                     gaplessPlayback: true,
// //                                     errorBuilder: (_, __, ___) => Container(
// //                                         color: const Color(0xFF1B263B)),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //
// //                             // 3. 12 HORSES LAYER
// //                             SafeArea(
// //                               child: Padding(
// //                                 padding: const EdgeInsets.only(
// //                                   top: 0,
// //                                   bottom: 65,
// //                                   left: 8.0,
// //                                   right: 16.0,
// //                                 ),
// //                                 child: LayoutBuilder(
// //                                   builder: (context, horseArea) {
// //                                     const double laneHeight = 11;
// //                                     final double totalLanes = laneHeight * 12;
// //                                     final double startY = math.max(
// //                                         0.0,
// //                                         (horseArea.maxHeight - totalLanes) / 2);
// //
// //                                     return Stack(
// //                                       clipBehavior: Clip.none,
// //                                       children: [
// //                                         for (int i = 0;
// //                                         i < _viewModel.horses.length;
// //                                         i++)
// //                                           _buildHorsePositioned(
// //                                             horse: _viewModel.horses[i],
// //                                             index: i,
// //                                             laneSpacing: laneHeight,
// //                                             topOffset: startY,
// //                                             screenWidth: screenWidth,
// //                                             smoothLead: smoothLead,
// //                                             finishLineScreenX:
// //                                             finishLineScreenX,
// //                                           ),
// //                                       ],
// //                                     );
// //                                   },
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //
// //                       // 4. TOP HUD
// //                       Positioned(
// //                         top: 0,
// //                         left: 0,
// //                         right: 0,
// //                         child: SafeArea(
// //                           bottom: false,
// //                           child: _buildTopHud(),
// //                         ),
// //                       ),
// //
// //                       // 5. BOTTOM JOCKEY RANKING STRIP (Threshold/Margin Based Live Shuffle)
// //                       Positioned(
// //                         left: 0,
// //                         right: 0,
// //                         bottom: 0,
// //                         child: SafeArea(
// //                           top: false,
// //                           child: _buildBottomJockeyBar(
// //                             screenWidth: screenWidth,
// //                             smoothLead: smoothLead,
// //                             finishLineScreenX: finishLineScreenX,
// //                           ),
// //                         ),
// //                       ),
// //
// //                       // 6. SCREENSHOT OVERLAY
// //                       if (_viewModel.status == RaceStatus.completed ||
// //                           _hasTriggeredPhoto)
// //                         _buildRaceFinishOverlay(winnerHorse),
// //                     ],
// //                   );
// //                 },
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHorsePositioned({
// //     required HorseModel horse,
// //     required int index,
// //     required double laneSpacing,
// //     required double topOffset,
// //     required double screenWidth,
// //     required double smoothLead,
// //     required double finishLineScreenX,
// //   }) {
// //     final baseY = topOffset + (index * laneSpacing);
// //
// //     final phase = (_gallopController.value * 2 * math.pi) + (index * 1.57);
// //     final verticalBob = math.sin(phase) * 0.25;
// //
// //     final double targetX = _calculateHorseScreenX(
// //       horse: horse,
// //       index: index,
// //       screenWidth: screenWidth,
// //       smoothLead: smoothLead,
// //       finishLineScreenX: finishLineScreenX,
// //     );
// //
// //     final isRunning = _viewModel.status == RaceStatus.running;
// //
// //     return Positioned(
// //       left: targetX,
// //       top: baseY + verticalBob,
// //       child: Stack(
// //         clipBehavior: Clip.none,
// //         alignment: Alignment.bottomLeft,
// //         children: [
// //           if (isRunning && horse.progress < 1.1) ...[
// //             Positioned(
// //               left: -2,
// //               bottom: -2,
// //               child: IgnorePointer(
// //                 child: AnimatedBuilder(
// //                   animation: _gallopController,
// //                   builder: (context, _) {
// //                     return CustomPaint(
// //                       size: const Size(16, 6),
// //                       painter: DustCloudPainter(
// //                         animationValue: _gallopController.value,
// //                         seed: index * 2,
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //             Positioned(
// //               left: 24,
// //               bottom: -2,
// //               child: IgnorePointer(
// //                 child: AnimatedBuilder(
// //                   animation: _gallopController,
// //                   builder: (context, _) {
// //                     final frontPhase = (_gallopController.value + 0.35) % 1.0;
// //                     return CustomPaint(
// //                       size: const Size(14, 5),
// //                       painter: DustCloudPainter(
// //                         animationValue: frontPhase,
// //                         seed: (index * 2) + 1,
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ],
// //
// //           HorseTokenWidget(
// //             horseNumber: horse.id,
// //             color: horse.color,
// //             gifPath: horse.gifPath,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBottomJockeyBar({
// //     required double screenWidth,
// //     required double smoothLead,
// //     required double finishLineScreenX,
// //   }) {
// //     return AnimatedBuilder(
// //       animation: _gallopController,
// //       builder: (context, _) {
// //         final Map<int, double> horseXMap = {};
// //         for (int i = 0; i < _viewModel.horses.length; i++) {
// //           final h = _viewModel.horses[i];
// //           final x = _calculateHorseScreenX(
// //             horse: h,
// //             index: i,
// //             screenWidth: screenWidth,
// //             smoothLead: smoothLead,
// //             finishLineScreenX: finishLineScreenX,
// //           );
// //           horseXMap[h.id] = x;
// //         }
// //
// //         if (_currentJockeyOrder.isEmpty ||
// //             _currentJockeyOrder.length != _viewModel.horses.length) {
// //           final initialSorted = List<HorseModel>.from(_viewModel.horses)
// //             ..sort((a, b) =>
// //                 (horseXMap[b.id] ?? 0).compareTo(horseXMap[a.id] ?? 0));
// //           _currentJockeyOrder = initialSorted.map((h) => h.id).toList();
// //         } else {
// //           const double overtakeThreshold = 15.0;
// //
// //           bool swapped = true;
// //           int safetyLimit = 0;
// //           while (swapped && safetyLimit < 12) {
// //             swapped = false;
// //             safetyLimit++;
// //             for (int i = 0; i < _currentJockeyOrder.length - 1; i++) {
// //               final currentHorseId = _currentJockeyOrder[i];
// //               final nextHorseId = _currentJockeyOrder[i + 1];
// //
// //               final currentX = horseXMap[currentHorseId] ?? 0.0;
// //               final nextX = horseXMap[nextHorseId] ?? 0.0;
// //
// //               if (nextX > currentX + overtakeThreshold) {
// //                 _currentJockeyOrder[i] = nextHorseId;
// //                 _currentJockeyOrder[i + 1] = currentHorseId;
// //                 swapped = true;
// //               }
// //             }
// //           }
// //         }
// //
// //         final Map<int, int> rankMap = {};
// //         for (int i = 0; i < _currentJockeyOrder.length; i++) {
// //           rankMap[_currentJockeyOrder[i]] = i;
// //         }
// //
// //         return Container(
// //           height: 58,
// //           color: const Color(0xFF0F172A),
// //           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
// //           child: Row(
// //             children: [
// //               Container(
// //                 width: 48,
// //                 margin: const EdgeInsets.only(right: 4),
// //                 decoration: BoxDecoration(
// //                   color: const Color(0xFF7F1D1D),
// //                   borderRadius: BorderRadius.circular(3),
// //                   border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
// //                 ),
// //                 child: const Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Icon(Icons.fiber_manual_record,
// //                             color: Colors.redAccent, size: 7),
// //                         SizedBox(width: 2),
// //                         Text(
// //                           'LIVE',
// //                           style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 8,
// //                               fontWeight: FontWeight.w900),
// //                         ),
// //                       ],
// //                     ),
// //                     Text(
// //                       '1000M',
// //                       style: TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 7.5,
// //                           fontWeight: FontWeight.bold),
// //                     ),
// //                     Text(
// //                       'TURF DERBY',
// //                       style: TextStyle(color: Colors.white54, fontSize: 5.5),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               Expanded(
// //                 child: LayoutBuilder(
// //                   builder: (context, boxConstraints) {
// //                     final totalAvailableWidth = boxConstraints.maxWidth;
// //                     final totalHorses = _viewModel.horses.length;
// //                     if (totalHorses == 0) return const SizedBox.shrink();
// //
// //                     final cardWidth = totalAvailableWidth / totalHorses;
// //
// //                     return Stack(
// //                       clipBehavior: Clip.none,
// //                       children: [
// //                         for (final horse in _viewModel.horses)
// //                           AnimatedPositioned(
// //                             key: ValueKey('jockey_card_${horse.id}'),
// //                             duration: const Duration(milliseconds: 320),
// //                             curve: Curves.easeInOutCubic,
// //                             left: (rankMap[horse.id] ?? 0) * cardWidth,
// //                             top: 0,
// //                             bottom: 0,
// //                             width: cardWidth,
// //                             child: _buildJockeyCard(
// //                               horse: horse,
// //                               rankIndex: (rankMap[horse.id] ?? 0) + 1,
// //                             ),
// //                           ),
// //                       ],
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildJockeyCard({required HorseModel horse, required int rankIndex}) {
// //     Color rankBg;
// //     String rankText;
// //     Widget? crownIcon;
// //
// //     if (rankIndex == 1) {
// //       rankBg = const Color(0xFFB45309);
// //       rankText = '1ST';
// //       crownIcon =
// //       const Icon(Icons.emoji_events, color: Colors.amberAccent, size: 8);
// //     } else if (rankIndex == 2) {
// //       rankBg = const Color(0xFF1E3A8A);
// //       rankText = '2ND';
// //     } else if (rankIndex == 3) {
// //       rankBg = const Color(0xFF7C2D12);
// //       rankText = '3RD';
// //     } else {
// //       rankBg = Colors.black45;
// //       rankText = '${rankIndex}TH';
// //     }
// //
// //     final bool hasBet = (widget.placedBets[horse.id] ?? 0) > 0;
// //
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 1.2),
// //       decoration: BoxDecoration(
// //         color: Colors.black.withOpacity(0.6),
// //         borderRadius: BorderRadius.circular(2),
// //         border: Border.all(
// //           color: hasBet
// //               ? const Color(0xFFFFD000)
// //               : (rankIndex == 1 ? Colors.amberAccent : Colors.white24),
// //           width: hasBet ? 1.4 : (rankIndex == 1 ? 1.0 : 0.5),
// //         ),
// //       ),
// //       child: Column(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 0.5),
// //             color: rankBg,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Row(
// //                   mainAxisSize: MainAxisSize.min,
// //                   children: [
// //                     if (crownIcon != null) ...[
// //                       crownIcon,
// //                       const SizedBox(width: 1)
// //                     ],
// //                     Text(
// //                       rankText,
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 6.5,
// //                         fontWeight: FontWeight.w900,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 2),
// //                   decoration: BoxDecoration(
// //                     color: horse.color.withOpacity(0.8),
// //                     borderRadius: BorderRadius.circular(1),
// //                   ),
// //                   child: Text(
// //                     '#${horse.id}',
// //                     style: const TextStyle(
// //                       color: Colors.black,
// //                       fontSize: 6.5,
// //                       fontWeight: FontWeight.w900,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Expanded(
// //             child: Container(
// //               width: double.infinity,
// //               color: const Color(0xFF1E293B),
// //               child: Image.asset(
// //                 horse.jockeyImagePath,
// //                 fit: BoxFit.cover,
// //                 gaplessPlayback: true,
// //                 errorBuilder: (_, __, ___) => Icon(
// //                   Icons.person,
// //                   color: horse.color,
// //                   size: 16,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.symmetric(vertical: 0.5),
// //             color: Colors.black87,
// //             child: Text(
// //               horse.name,
// //               textAlign: TextAlign.center,
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 6,
// //                 fontWeight: FontWeight.w800,
// //                 letterSpacing: 0.1,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRaceFinishOverlay([HorseModel? currentLead]) {
// //     final winner = _viewModel.winnerSnapshot?.horse ??
// //         currentLead ??
// //         _viewModel.horses.firstWhere(
// //               (h) => h.rank == 1,
// //           orElse: () => _viewModel.horses.first,
// //         );
// //     final finishTime = _viewModel.winnerSnapshot?.finishTime ?? "20.00s";
// //
// //     final int winnerBet = widget.placedBets[winner.id] ?? 0;
// //     final int totalBetAmount =
// //     widget.placedBets.values.fold(0, (sum, v) => sum + v);
// //     final bool hasAnyBet = totalBetAmount > 0;
// //     final int winAmount = winnerBet * 3;
// //
// //     return AnimatedBuilder(
// //       animation: _photoFinishController,
// //       builder: (context, child) {
// //         final curved = Curves.easeOutBack
// //             .transform(_photoFinishController.value.clamp(0.0, 1.0));
// //         return Opacity(
// //           opacity: _photoFinishController.value.clamp(0.0, 1.0),
// //           child: Container(
// //             color: Colors.black.withOpacity(0.85),
// //             alignment: Alignment.center,
// //             child: Transform.scale(
// //               scale: 0.85 + (0.15 * curved),
// //               child: child,
// //             ),
// //           ),
// //         );
// //       },
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           Transform.rotate(
// //             angle: -0.05,
// //             child: Container(
// //               width: 280,
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(4),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.6),
// //                     blurRadius: 18,
// //                     offset: const Offset(0, 8),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                 children: [
// //                   Stack(
// //                     children: [
// //                       Container(
// //                         height: 145,
// //                         width: double.infinity,
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xFF1E293B),
// //                           borderRadius: BorderRadius.circular(2),
// //                         ),
// //                         child: ClipRRect(
// //                           borderRadius: BorderRadius.circular(2),
// //                           child: _capturedFinishImageBytes != null
// //                               ? Image.memory(
// //                             _capturedFinishImageBytes!,
// //                             fit: BoxFit.cover,
// //                             alignment: Alignment.centerRight,
// //                           )
// //                               : const Center(
// //                             child: CircularProgressIndicator(
// //                               color: Colors.amberAccent,
// //                               strokeWidth: 2,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       Positioned(
// //                         top: 6,
// //                         right: 6,
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 6, vertical: 2),
// //                           color: const Color(0xFF0284C7),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.end,
// //                             children: [
// //                               const Text(
// //                                 '1000m',
// //                                 style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 10,
// //                                     fontWeight: FontWeight.w900),
// //                               ),
// //                               Text(
// //                                 winner.name.toUpperCase(),
// //                                 style: const TextStyle(
// //                                     color: Colors.yellowAccent,
// //                                     fontSize: 7,
// //                                     fontWeight: FontWeight.bold),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                       Positioned(
// //                         top: 6,
// //                         left: 6,
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               horizontal: 4, vertical: 2),
// //                           color: Colors.black87,
// //                           child: const Text(
// //                             'HORSE RACING\nPHOTO FINISH',
// //                             style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 7,
// //                                 fontWeight: FontWeight.bold,
// //                                 height: 1.1),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 6),
// //                   Row(
// //                     children: [
// //                       _buildShareIcon(Icons.facebook, const Color(0xFF1877F2)),
// //                       const SizedBox(width: 4),
// //                       _buildShareIcon(Icons.close, Colors.black),
// //                       const SizedBox(width: 4),
// //                       _buildShareIcon(Icons.share, const Color(0xFFEA4335)),
// //                       const SizedBox(width: 4),
// //                       _buildShareIcon(Icons.chat_bubble, const Color(0xFF25D366)),
// //                       const Spacer(),
// //                       const Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(Icons.share, size: 11, color: Colors.black87),
// //                           SizedBox(width: 2),
// //                           Text(
// //                             'SHARE',
// //                             style: TextStyle(
// //                                 color: Colors.black87,
// //                                 fontSize: 10,
// //                                 fontWeight: FontWeight.bold),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 32),
// //           Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'RACE FINISHED',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 26,
// //                   fontWeight: FontWeight.w900,
// //                   letterSpacing: 1.1,
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 'RECORD: 1000m ($finishTime)',
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w800,
// //                 ),
// //               ),
// //               const SizedBox(height: 6),
// //               Text(
// //                 hasAnyBet
// //                     ? (winnerBet > 0 ? 'YOU WON!' : 'BETTER LUCK NEXT TIME')
// //                     : 'NO BET PLACED',
// //                 style: TextStyle(
// //                   color: hasAnyBet && winnerBet > 0
// //                       ? const Color(0xFF34D399)
// //                       : const Color(0xFFFBBF24),
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w900,
// //                 ),
// //               ),
// //               const SizedBox(height: 6),
// //               RichText(
// //                 text: TextSpan(
// //                   style:
// //                   const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
// //                   children: [
// //                     const TextSpan(
// //                         text: 'WINNER: ',
// //                         style: TextStyle(color: Colors.white)),
// //                     TextSpan(
// //                       text: '#${winner.id} ${winner.name.toUpperCase()} ',
// //                       style: const TextStyle(color: Color(0xFFFBBF24)),
// //                     ),
// //                     const TextSpan(
// //                       text: '[ 9.6/10 ]',
// //                       style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 hasAnyBet
// //                     ? 'YOUR BETS: ${widget.placedBets.entries.map((e) => '#${e.key}:${e.value}').join(', ')}'
// //                     : 'YOUR BETS: None',
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w800,
// //                 ),
// //               ),
// //               if (winnerBet > 0) ...[
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   'YOU WIN: $winAmount PTS',
// //                   style: const TextStyle(
// //                     color: Color(0xFF34D399),
// //                     fontSize: 13,
// //                     fontWeight: FontWeight.w900,
// //                   ),
// //                 ),
// //               ],
// //               const SizedBox(height: 4),
// //               const Text(
// //                 'GOING BACK IN 5 SECONDS...',
// //                 style: TextStyle(
// //                   color: Colors.white70,
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w700,
// //                 ),
// //               ),
// //               const SizedBox(height: 2),
// //               const Text(
// //                 '12x RUNNERS • 3x PAYOUT WIN',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w900,
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               Row(
// //                 children: [
// //                   InkWell(
// //                     onTap: () {
// //                       Navigator.of(context).pop();
// //                     },
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(
// //                           horizontal: 10, vertical: 6),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(4),
// //                       ),
// //                       child: const Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(Icons.refresh, size: 14, color: Colors.black),
// //                           SizedBox(width: 4),
// //                           Text(
// //                             'NEXT RACE',
// //                             style: TextStyle(
// //                               color: Colors.black,
// //                               fontSize: 11,
// //                               fontWeight: FontWeight.w900,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(
// //                         horizontal: 10, vertical: 6),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFF059669),
// //                       borderRadius: BorderRadius.circular(4),
// //                       border: Border.all(color: const Color(0xFF34D399)),
// //                     ),
// //                     child: const Text(
// //                       'BALANCE: 10090 PTS',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 11,
// //                         fontWeight: FontWeight.w900,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildShareIcon(IconData icon, Color bg) {
// //     return Container(
// //       width: 18,
// //       height: 18,
// //       decoration: BoxDecoration(
// //         color: bg,
// //         borderRadius: BorderRadius.circular(2),
// //       ),
// //       child: Icon(icon, color: Colors.white, size: 11),
// //     );
// //   }
// //
// //   Widget _buildTopHud() {
// //     final isRunning = _viewModel.status == RaceStatus.running;
// //     final isLowTime = _viewModel.remainingDuration.inSeconds < 5 &&
// //         _viewModel.status == RaceStatus.running;
// //
// //     final pulse = isLowTime
// //         ? 0.7 + 0.3 * (1 - (_gallopController.value * 2 % 1.0))
// //         : 1.0;
// //
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.black.withOpacity(0.7),
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.white24),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(
// //                 Icons.timer,
// //                 color: isLowTime ? Colors.redAccent : Colors.cyanAccent,
// //                 size: 18,
// //               ),
// //               const SizedBox(width: 8),
// //               Transform.scale(
// //                 scale: pulse,
// //                 child: Text(
// //                   _formatDuration(_viewModel.remainingDuration),
// //                   style: TextStyle(
// //                     color: isLowTime ? Colors.redAccent : Colors.white,
// //                     fontFamily: 'monospace',
// //                     fontSize: 15,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(width: 10),
// //               Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
// //                 decoration: BoxDecoration(
// //                   color: Colors.orangeAccent.withOpacity(0.2),
// //                   borderRadius: BorderRadius.circular(4),
// //                   border: Border.all(color: Colors.orangeAccent),
// //                 ),
// //                 child: Text(
// //                   HorseRacingViewModel.testMode
// //                       ? 'TEST MODE (15s)'
// //                       : '6 HOURS RUN',
// //                   style: const TextStyle(
// //                     color: Colors.orangeAccent,
// //                     fontSize: 10,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           Row(
// //             children: [
// //               ElevatedButton.icon(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor:
// //                   isRunning ? Colors.amberAccent : Colors.greenAccent,
// //                   foregroundColor: Colors.black,
// //                   padding:
// //                   const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                 ),
// //                 onPressed: () {
// //                   if (isRunning) {
// //                     _viewModel.pause();
// //                   } else {
// //                     _viewModel.startOrResume();
// //                   }
// //                 },
// //                 icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, size: 16),
// //                 label: Text(
// //                   isRunning ? 'PAUSE' : 'START RACE',
// //                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               OutlinedButton.icon(
// //                 style: OutlinedButton.styleFrom(
// //                   foregroundColor: Colors.redAccent,
// //                   side: const BorderSide(color: Colors.redAccent),
// //                   padding:
// //                   const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //                 ),
// //                 onPressed: () {
// //                   _photoFinishController.reset();
// //                   _hasTriggeredPhoto = false;
// //                   _capturedFinishImageBytes = null;
// //                   _currentJockeyOrder.clear();
// //                   _viewModel.reset();
// //                 },
// //                 icon: const Icon(Icons.refresh, size: 16),
// //                 label: const Text('RESET',
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:async';
// import 'dart:math' as math;
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
//
// import 'coundown_paint.dart';
// import 'dust_painter.dart';
// import 'hourse_model.dart';
// import 'hourse_token.dart';
//
// class GameScreen extends StatefulWidget {
//   final Map<int, int> placedBets;
//
//   const GameScreen({super.key, this.placedBets = const {}});
//
//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }
//
// class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
//   late final HorseRacingViewModel _viewModel;
//
//   late final AnimationController _gallopController;
//   late final AnimationController _photoFinishController;
//
//   final GlobalKey _trackScreenshotKey = GlobalKey();
//   Uint8List? _capturedFinishImageBytes;
//
//   bool _showGate = true;
//   Timer? _gateTimer;
//   bool _hasTriggeredPhoto = false;
//
//   Timer? _autoBackTimer;
//
//   List<int> _currentJockeyOrder = [];
//
//   // Initial 5-second green loader state
//   bool _isLoading = true;
//   int _loadingSecondsLeft = 5;
//   Timer? _loadingTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _viewModel = HorseRacingViewModel();
//
//     _gallopController = AnimationController(
//       vsync: this,
//       // 380ms se 30% tez -> ~292ms (380 / 1.3). Race speed 30% badhne par
//       // legs bhi usi hisaab se tez move karni chahiye, warna sliding
//       // jaisa dikhega.
//       duration: const Duration(milliseconds: 292),
//     );
//
//     _photoFinishController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 250),
//     );
//
//     _viewModel.addListener(_onViewModelChanged);
//
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//
//     // 5 seconds green loader countdown
//     _startInitialLoader();
//   }
//
//   void _startInitialLoader() {
//     _loadingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         if (_loadingSecondsLeft > 1) {
//           setState(() {
//             _loadingSecondsLeft--;
//           });
//         } else {
//           _loadingTimer?.cancel();
//           setState(() {
//             _isLoading = false;
//           });
//           // 5 seconds poore hone ke baad race aur gallop shuru hogi
//           _gallopController.repeat();
//           _viewModel.startOrResume();
//         }
//       }
//     });
//   }
//
//   Future<void> _captureRaceFinishFrame() async {
//     try {
//       final boundary = _trackScreenshotKey.currentContext?.findRenderObject()
//       as RenderRepaintBoundary?;
//       if (boundary != null) {
//         final ui.Image image = await boundary.toImage(pixelRatio: 1.5);
//         final ByteData? byteData =
//         await image.toByteData(format: ui.ImageByteFormat.png);
//         if (byteData != null && mounted) {
//           setState(() {
//             _capturedFinishImageBytes = byteData.buffer.asUint8List();
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint("Photo Finish Capture Error: $e");
//     }
//   }
//
//   void _onViewModelChanged() {
//     if (_viewModel.status == RaceStatus.running && !_isLoading) {
//       if (!_gallopController.isAnimating) {
//         _gallopController.repeat();
//       }
//       if (_showGate && _gateTimer == null) {
//         _gateTimer = Timer(const Duration(milliseconds: 500), () {
//           if (mounted) setState(() => _showGate = false);
//         });
//       }
//     } else if (_viewModel.status == RaceStatus.paused) {
//       _gallopController.stop();
//     } else if (_viewModel.status == RaceStatus.completed) {
//       if (!_hasTriggeredPhoto) {
//         _triggerFinishInstant();
//       }
//     } else if (_viewModel.status == RaceStatus.initial) {
//       _gallopController.stop();
//       _photoFinishController.reset();
//       _hasTriggeredPhoto = false;
//       _capturedFinishImageBytes = null;
//       _currentJockeyOrder.clear();
//       _gateTimer?.cancel();
//       _gateTimer = null;
//       if (!_showGate) setState(() => _showGate = true);
//     }
//   }
//
//   void _triggerFinishInstant() {
//     if (_hasTriggeredPhoto) return;
//     _hasTriggeredPhoto = true;
//
//     _gallopController.stop();
//
//     if (mounted) {
//       _photoFinishController.forward();
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _captureRaceFinishFrame();
//     });
//
//     _autoBackTimer?.cancel();
//     _autoBackTimer = Timer(const Duration(seconds: 5), () {
//       if (mounted) Navigator.of(context).pop();
//     });
//   }
//
//   @override
//   void dispose() {
//     _loadingTimer?.cancel();
//     _viewModel.removeListener(_onViewModelChanged);
//     _viewModel.dispose();
//     _gallopController.dispose();
//     _photoFinishController.dispose();
//     _gateTimer?.cancel();
//     _autoBackTimer?.cancel();
//     super.dispose();
//   }
//
//   double _calculateHorseScreenX({
//     required HorseModel horse,
//     required int index,
//     required double screenWidth,
//     required double smoothLead,
//     required double finishLineScreenX,
//   }) {
//     final double naturalStagger =
//         ((index % 4) * 22.0) - ((index % 3) * 18.0) - (index * 4.0);
//
//     final racePhase = smoothLead.clamp(0.0, 1.0) * 10.0 * math.pi;
//     final waveA = math.sin(racePhase + (index * 1.85)) * 38.0;
//     final waveB = math.cos((racePhase * 0.6) + (index * 2.7)) * 22.0;
//
//     final relativeLeadOffset =
//         (horse.progress - smoothLead) * (screenWidth * 0.70);
//
//     final smoothEnvelope = math.sin(smoothLead.clamp(0.0, 1.0) * math.pi);
//     final dynamicOffset =
//         ((waveA + waveB + naturalStagger) * smoothEnvelope) + relativeLeadOffset;
//
//     final bool isWinner = horse.rank == 1 ||
//         (_viewModel.horses.isNotEmpty &&
//             horse ==
//                 _viewModel.horses
//                     .reduce((a, b) => a.progress > b.progress ? a : b));
//
//     final double winnerLeadProgress = Curves.easeInOut.transform(
//       ((smoothLead - 0.25) / 0.45).clamp(0.0, 1.0),
//     );
//     final double winnerExtraLead = isWinner ? (48.0 * winnerLeadProgress) : 0.0;
//
//     const double startX = 40.0;
//     final double centerPackX = screenWidth * 0.34;
//
//     if (smoothLead < 0.15) {
//       final enterT =
//       Curves.easeOutCubic.transform((smoothLead / 0.15).clamp(0.0, 1.0));
//       final currentBaseX = startX + ((centerPackX - startX) * enterT);
//       return currentBaseX + (dynamicOffset * enterT) + winnerExtraLead;
//     } else if (smoothLead <= 0.85) {
//       return centerPackX + dynamicOffset + winnerExtraLead;
//     } else {
//       final sprintT = Curves.easeInQuad
//           .transform(((smoothLead - 0.85) / 0.15).clamp(0.0, 1.0));
//
//       final double trailOffset = isWinner ? 35.0 : (-40.0 - (index * 6.0));
//       final double endTargetX = finishLineScreenX + trailOffset;
//
//       return (centerPackX * (1.0 - sprintT)) +
//           (endTargetX * sprintT) +
//           (dynamicOffset * (1.0 - sprintT));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: AnimatedBuilder(
//         animation: _viewModel,
//         builder: (context, _) {
//           return LayoutBuilder(
//             builder: (context, constraints) {
//               final screenWidth = constraints.maxWidth;
//               final screenHeight = constraints.maxHeight;
//
//               final leadProgress = _viewModel.horses.isEmpty
//                   ? 0.0
//                   : _viewModel.horses
//                   .map((h) => h.progress)
//                   .reduce((a, b) => math.max(a, b));
//
//               final winnerHorse = _viewModel.horses.isEmpty
//                   ? null
//                   : _viewModel.horses
//                   .reduce((a, b) => a.progress > b.progress ? a : b);
//
//               if (!_isLoading &&
//                   winnerHorse != null &&
//                   winnerHorse.progress >= 0.999 &&
//                   !_hasTriggeredPhoto) {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   _triggerFinishInstant();
//                 });
//               }
//
//               final double mainTrackWidth = screenWidth * 8.5;
//               final double finishLineWidth = screenHeight * 1.6;
//               final double runoutTrackWidth = screenWidth * 2.0;
//
//               final double totalTrackWidth =
//                   mainTrackWidth + finishLineWidth + runoutTrackWidth;
//
//               final double maxScrollableDistance =
//                   mainTrackWidth + (finishLineWidth * 0.3) - (screenWidth * 0.45);
//
//               final double finishLineScreenX = screenWidth * 0.68;
//
//               // Yahan pehle "final double smoothLead = leadProgress;" seedha
//               // tha, jiski wajah se horse position sirf viewModel ke notify
//               // hone par hi update hoti thi — isse dikhne mein jerky/jump
//               // wali movement lagti thi. Ab TweenAnimationBuilder se
//               // leadProgress ko continuously interpolate karte hain, taaki
//               // har frame par smoothLead thodi-thodi badhta rahe aur horse
//               // glide karke chale, real gallop jaisa smooth feel aaye.
//               return TweenAnimationBuilder<double>(
//                 tween: Tween<double>(end: leadProgress),
//                 duration: const Duration(milliseconds: 140),
//                 curve: Curves.linear,
//                 builder: (context, smoothLead, _) {
//                   final double trackScrollOffset = -(maxScrollableDistance *
//                       smoothLead.clamp(0.0, 1.0));
//
//                   return Stack(
//                     clipBehavior: Clip.none,
//                     fit: StackFit.expand,
//                     children: [
//                       RepaintBoundary(
//                         key: _trackScreenshotKey,
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           fit: StackFit.expand,
//                           children: [
//                             // 1. TRACK & FINISH LINE
//                             Positioned(
//                               left: trackScrollOffset,
//                               top: 0,
//                               bottom: 0,
//                               width: totalTrackWidth,
//                               child: SizedBox(
//                                 height: screenHeight,
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                                   children: [
//                                     SizedBox(
//                                       width: mainTrackWidth,
//                                       height: screenHeight,
//                                       child: Image.asset(
//                                         'assets/top/fullimage.png',
//                                         fit: BoxFit.fitHeight,
//                                         repeat: ImageRepeat.repeatX,
//                                         alignment: Alignment.centerLeft,
//                                         gaplessPlayback: true,
//                                         errorBuilder: (_, __, ___) => Container(
//                                           color: const Color(0xFF0D1B2A),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: finishLineWidth,
//                                       height: screenHeight,
//                                       child: Image.asset(
//                                         'assets/top/MAINFINSHLINE.png',
//                                         fit: BoxFit.fill,
//                                         gaplessPlayback: true,
//                                         errorBuilder: (_, __, ___) => Container(
//                                           color: const Color(0xFF415A77),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: runoutTrackWidth,
//                                       height: screenHeight,
//                                       child: Image.asset(
//                                         'assets/top/fullimage.png',
//                                         fit: BoxFit.fitHeight,
//                                         repeat: ImageRepeat.repeatX,
//                                         alignment: Alignment.centerLeft,
//                                         gaplessPlayback: true,
//                                         errorBuilder: (_, __, ___) => Container(
//                                           color: const Color(0xFF0D1B2A),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             // 2. Starting Gate
//                             Positioned(
//                               left: 0,
//                               top: 0,
//                               bottom: 60,
//                               width: screenWidth * 0.14,
//                               child: IgnorePointer(
//                                 child: AnimatedOpacity(
//                                   opacity: _showGate ? 1.0 : 0.0,
//                                   duration: const Duration(milliseconds: 400),
//                                   curve: Curves.easeOut,
//                                   child: Image.asset(
//                                     'assets/sprites/GATE.png',
//                                     fit: BoxFit.fill,
//                                     gaplessPlayback: true,
//                                     errorBuilder: (_, __, ___) => Container(
//                                       color: const Color(0xFF1B263B),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             // 3. 12 Horses Layer
//                             SafeArea(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 0,
//                                   bottom: 65,
//                                   left: 8.0,
//                                   right: 16.0,
//                                 ),
//                                 child: LayoutBuilder(
//                                   builder: (context, horseArea) {
//                                     const double laneHeight = 11;
//                                     final double totalLanes = laneHeight * 12;
//                                     final double startY = math.max(
//                                       0.0,
//                                       (horseArea.maxHeight - totalLanes) / 2,
//                                     );
//
//                                     return Stack(
//                                       clipBehavior: Clip.none,
//                                       children: [
//                                         for (int i = 0;
//                                         i < _viewModel.horses.length;
//                                         i++)
//                                           _buildHorsePositioned(
//                                             horse: _viewModel.horses[i],
//                                             index: i,
//                                             laneSpacing: laneHeight,
//                                             topOffset: startY,
//                                             screenWidth: screenWidth,
//                                             smoothLead: smoothLead,
//                                             finishLineScreenX: finishLineScreenX,
//                                           ),
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // 4. Bottom Jockey Ranking Strip
//                       Positioned(
//                         left: 0,
//                         right: 0,
//                         bottom: 0,
//                         child: SafeArea(
//                           top: false,
//                           child: _buildBottomJockeyBar(
//                             screenWidth: screenWidth,
//                             smoothLead: smoothLead,
//                             finishLineScreenX: finishLineScreenX,
//                           ),
//                         ),
//                       ),
//
//                       // 5. SCREENSHOT FINISH OVERLAY
//                       if (_viewModel.status == RaceStatus.completed ||
//                           _hasTriggeredPhoto)
//                         _buildRaceFinishOverlay(winnerHorse),
//
//                       // 6. INITIAL 5-SECOND GREEN LOADER OVERLAY
//                       if (_isLoading) _buildGreenInitialLoader(),
//                     ],
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   /// 5-second countdown loader with animated progress ring + pop effect
//   Widget _buildGreenInitialLoader({int totalSeconds = 5}) {
//     final double progress =
//     (_loadingSecondsLeft / totalSeconds).clamp(0.0, 1.0);
//
//     return Container(
//       color: Colors.black.withOpacity(0.55),
//       alignment: Alignment.center,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // 0. Animated countdown ring (shrinks as time runs out)
//           TweenAnimationBuilder<double>(
//             key: ValueKey(_loadingSecondsLeft),
//             tween: Tween<double>(begin: progress + (1 / totalSeconds), end: progress),
//             duration: const Duration(milliseconds: 900),
//             curve: Curves.linear,
//             builder: (context, value, _) {
//               return SizedBox(
//                 width: 126,
//                 height: 126,
//                 child: CustomPaint(
//                   painter: CountdownRingPainter(progress: value),
//                 ),
//               );
//             },
//           ),
//
//           // Number pops/scales in each time it changes
//           TweenAnimationBuilder<double>(
//             key: ValueKey('scale_$_loadingSecondsLeft'),
//             tween: Tween<double>(begin: 1.25, end: 1.0),
//             duration: const Duration(milliseconds: 260),
//             curve: Curves.easeOutBack,
//             builder: (context, scale, child) {
//               return Transform.scale(scale: scale, child: child);
//             },
//             child: Container(
//               width: 105,
//               height: 105,
//               // 1. Outermost Bright Yellow Glow & Rim
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFFFFD000),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFFFC000).withOpacity(0.85),
//                     blurRadius: 28,
//                     spreadRadius: 6,
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.7),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(4.5), // Outer yellow border width
//               child: Container(
//                 // 2. Metallic Beveled Ring
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     begin: Alignment.bottomLeft,
//                     end: Alignment.topRight,
//                     colors: [
//                       Color(0xFFFFFFFF),
//                       Color(0xFFE5B015),
//                       Color(0xFF5A3602),
//                       Color(0xFF1F1200),
//                     ],
//                     stops: [0.0, 0.35, 0.75, 1.0],
//                   ),
//                 ),
//                 padding: const EdgeInsets.all(6.5),
//                 child: Container(
//                   // 3. Deep Black Inner Recessed Core
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color(0xFF0F0B05),
//                     border: Border.all(color: Colors.black, width: 1.5),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black87,
//                         blurRadius: 5,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   alignment: Alignment.center,
//                   // 4. Center Bold Yellow Number
//                   child: Text(
//                     '$_loadingSecondsLeft',
//                     style: const TextStyle(
//                       color: Color(0xFFFFD000),
//                       fontSize: 44,
//                       fontWeight: FontWeight.w900,
//                       fontFamily: 'sans-serif',
//                       height: 1.0,
//                       shadows: [
//                         Shadow(color: Color(0xFFFF9100), blurRadius: 10),
//                         Shadow(
//                           color: Colors.black,
//                           offset: Offset(1.5, 2),
//                           blurRadius: 3,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHorsePositioned({
//     required HorseModel horse,
//     required int index,
//     required double laneSpacing,
//     required double topOffset,
//     required double screenWidth,
//     required double smoothLead,
//     required double finishLineScreenX,
//   }) {
//     final baseY = topOffset + (index * laneSpacing);
//     final phase = (_gallopController.value * 2 * math.pi) + (index * 1.57);
//
//     // Up-down bounce hata diya — ab horse apni lane (baseY) par hi
//     // sidha rehta hai, sirf aage (horizontally) glide karta hai.
//     const double verticalBob = 0.0;
//
//     // Halka horizontal shimmy — legs ke push-off jaisa micro-movement,
//     // isse running "alive" lagti hai, sirf glide nahi.
//     final double horizontalShimmy = math.cos(phase) * 1.1;
//
//     final double targetX = _calculateHorseScreenX(
//       horse: horse,
//       index: index,
//       screenWidth: screenWidth,
//       smoothLead: smoothLead,
//       finishLineScreenX: finishLineScreenX,
//     ) +
//         horizontalShimmy;
//
//     final isRunning =
//         _viewModel.status == RaceStatus.running && !_hasTriggeredPhoto && !_isLoading;
//
//     return Positioned(
//       left: targetX,
//       top: baseY + verticalBob,
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.bottomLeft,
//         children: [
//           if (isRunning && horse.progress < 1.1) ...[
//             Positioned(
//               left: -2,
//               bottom: -2,
//               child: IgnorePointer(
//                 child: AnimatedBuilder(
//                   animation: _gallopController,
//                   builder: (context, _) {
//                     return CustomPaint(
//                       size: const Size(16, 6),
//                       painter: DustCloudPainter(
//                         animationValue: _gallopController.value,
//                         seed: index * 2,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Positioned(
//               left: 24,
//               bottom: -2,
//               child: IgnorePointer(
//                 child: AnimatedBuilder(
//                   animation: _gallopController,
//                   builder: (context, _) {
//                     final frontPhase = (_gallopController.value + 0.35) % 1.0;
//                     return CustomPaint(
//                       size: const Size(14, 5),
//                       painter: DustCloudPainter(
//                         animationValue: frontPhase,
//                         seed: (index * 2) + 1,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//           HorseTokenWidget(
//             horseNumber: horse.id,
//             color: horse.color,
//             gifPath: horse.gifPath,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomJockeyBar({
//     required double screenWidth,
//     required double smoothLead,
//     required double finishLineScreenX,
//   }) {
//     return AnimatedBuilder(
//       animation: _gallopController,
//       builder: (context, _) {
//         final Map<int, double> horseXMap = {};
//         for (int i = 0; i < _viewModel.horses.length; i++) {
//           final h = _viewModel.horses[i];
//           final x = _calculateHorseScreenX(
//             horse: h,
//             index: i,
//             screenWidth: screenWidth,
//             smoothLead: smoothLead,
//             finishLineScreenX: finishLineScreenX,
//           );
//           horseXMap[h.id] = x;
//         }
//
//         if (_currentJockeyOrder.isEmpty ||
//             _currentJockeyOrder.length != _viewModel.horses.length) {
//           final initialSorted = List<HorseModel>.from(_viewModel.horses)
//             ..sort((a, b) =>
//                 (horseXMap[b.id] ?? 0).compareTo(horseXMap[a.id] ?? 0));
//           _currentJockeyOrder = initialSorted.map((h) => h.id).toList();
//         } else {
//           const double overtakeThreshold = 15.0;
//           bool swapped = true;
//           int safetyLimit = 0;
//           while (swapped && safetyLimit < 12) {
//             swapped = false;
//             safetyLimit++;
//             for (int i = 0; i < _currentJockeyOrder.length - 1; i++) {
//               final currentHorseId = _currentJockeyOrder[i];
//               final nextHorseId = _currentJockeyOrder[i + 1];
//
//               final currentX = horseXMap[currentHorseId] ?? 0.0;
//               final nextX = horseXMap[nextHorseId] ?? 0.0;
//
//               if (nextX > currentX + overtakeThreshold) {
//                 _currentJockeyOrder[i] = nextHorseId;
//                 _currentJockeyOrder[i + 1] = currentHorseId;
//                 swapped = true;
//               }
//             }
//           }
//         }
//
//         final Map<int, int> rankMap = {};
//         for (int i = 0; i < _currentJockeyOrder.length; i++) {
//           rankMap[_currentJockeyOrder[i]] = i;
//         }
//
//         return Container(
//           height: 58,
//           color: const Color(0xFF0F172A),
//           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//           child: Row(
//             children: [
//               Container(
//                 width: 48,
//                 margin: const EdgeInsets.only(right: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF7F1D1D),
//                   borderRadius: BorderRadius.circular(3),
//                   border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
//                 ),
//                 child: const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.fiber_manual_record,
//                             color: Colors.redAccent, size: 7),
//                         SizedBox(width: 2),
//                         Text(
//                           'LIVE',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 8,
//                               fontWeight: FontWeight.w900),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       '1000M',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 7.5,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       'TURF DERBY',
//                       style: TextStyle(color: Colors.white54, fontSize: 5.5),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: LayoutBuilder(
//                   builder: (context, boxConstraints) {
//                     final totalAvailableWidth = boxConstraints.maxWidth;
//                     final totalHorses = _viewModel.horses.length;
//                     if (totalHorses == 0) return const SizedBox.shrink();
//
//                     final cardWidth = totalAvailableWidth / totalHorses;
//
//                     return Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         for (final horse in _viewModel.horses)
//                           AnimatedPositioned(
//                             key: ValueKey('jockey_card_${horse.id}'),
//                             duration: const Duration(milliseconds: 320),
//                             curve: Curves.easeInOutCubic,
//                             left: (rankMap[horse.id] ?? 0) * cardWidth,
//                             top: 0,
//                             bottom: 0,
//                             width: cardWidth,
//                             child: _buildJockeyCard(
//                               horse: horse,
//                               rankIndex: (rankMap[horse.id] ?? 0) + 1,
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildJockeyCard({required HorseModel horse, required int rankIndex}) {
//     Color rankBg;
//     String rankText;
//     Widget? crownIcon;
//
//     if (rankIndex == 1) {
//       rankBg = const Color(0xFFB45309);
//       rankText = '1ST';
//       crownIcon =
//       const Icon(Icons.emoji_events, color: Colors.amberAccent, size: 8);
//     } else if (rankIndex == 2) {
//       rankBg = const Color(0xFF1E3A8A);
//       rankText = '2ND';
//     } else if (rankIndex == 3) {
//       rankBg = const Color(0xFF7C2D12);
//       rankText = '3RD';
//     } else {
//       rankBg = Colors.black45;
//       rankText = '${rankIndex}TH';
//     }
//
//     final bool hasBet = (widget.placedBets[horse.id] ?? 0) > 0;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 1.2),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.6),
//         borderRadius: BorderRadius.circular(2),
//         border: Border.all(
//           color: hasBet
//               ? const Color(0xFFFFD000)
//               : (rankIndex == 1 ? Colors.amberAccent : Colors.white24),
//           width: hasBet ? 1.4 : (rankIndex == 1 ? 1.0 : 0.5),
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 0.5),
//             color: rankBg,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (crownIcon != null) ...[
//                       crownIcon,
//                       const SizedBox(width: 1)
//                     ],
//                     Text(
//                       rankText,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 6.5,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   decoration: BoxDecoration(
//                     color: horse.color.withOpacity(0.8),
//                     borderRadius: BorderRadius.circular(1),
//                   ),
//                   child: Text(
//                     '#${horse.id}',
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 6.5,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               color: const Color(0xFF1E293B),
//               child: Image.asset(
//                 horse.jockeyImagePath,
//                 fit: BoxFit.cover,
//                 gaplessPlayback: true,
//                 errorBuilder: (_, __, ___) => Icon(
//                   Icons.person,
//                   color: horse.color,
//                   size: 16,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 0.5),
//             color: Colors.black87,
//             child: Text(
//               horse.name,
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 6,
//                 fontWeight: FontWeight.w800,
//                 letterSpacing: 0.1,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRaceFinishOverlay([HorseModel? currentLead]) {
//     final winner = _viewModel.winnerSnapshot?.horse ??
//         currentLead ??
//         _viewModel.horses.firstWhere(
//               (h) => h.rank == 1,
//           orElse: () => _viewModel.horses.first,
//         );
//     final finishTime = _viewModel.winnerSnapshot?.finishTime ?? "20.00s";
//
//     final int winnerBet = widget.placedBets[winner.id] ?? 0;
//     final int totalBetAmount =
//     widget.placedBets.values.fold(0, (sum, v) => sum + v);
//     final bool hasAnyBet = totalBetAmount > 0;
//     final int winAmount = winnerBet * 3;
//
//     return AnimatedBuilder(
//       animation: _photoFinishController,
//       builder: (context, child) {
//         final curved = Curves.easeOutBack
//             .transform(_photoFinishController.value.clamp(0.0, 1.0));
//         return Opacity(
//           opacity: _photoFinishController.value.clamp(0.0, 1.0),
//           child: Container(
//             color: Colors.black.withOpacity(0.85),
//             alignment: Alignment.center,
//             child: Transform.scale(
//               scale: 0.85 + (0.15 * curved),
//               child: child,
//             ),
//           ),
//         );
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Transform.rotate(
//             angle: -0.05,
//             child: Container(
//               width: 280,
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(4),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.6),
//                     blurRadius: 18,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Stack(
//                     children: [
//                       Container(
//                         height: 145,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF1E293B),
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(2),
//                           child: _capturedFinishImageBytes != null
//                               ? Image.memory(
//                             _capturedFinishImageBytes!,
//                             fit: BoxFit.cover,
//                             alignment: Alignment.centerRight,
//                           )
//                               : const Center(
//                             child: CircularProgressIndicator(
//                               color: Colors.amberAccent,
//                               strokeWidth: 2,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 6, vertical: 2),
//                           color: const Color(0xFF0284C7),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               const Text(
//                                 '1000m',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w900),
//                               ),
//                               Text(
//                                 winner.name.toUpperCase(),
//                                 style: const TextStyle(
//                                     color: Colors.yellowAccent,
//                                     fontSize: 7,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 6,
//                         left: 6,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 4, vertical: 2),
//                           color: Colors.black87,
//                           child: const Text(
//                             'HORSE RACING\nPHOTO FINISH',
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 7,
//                                 fontWeight: FontWeight.bold,
//                                 height: 1.1),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       _buildShareIcon(Icons.facebook, const Color(0xFF1877F2)),
//                       const SizedBox(width: 4),
//                       _buildShareIcon(Icons.close, Colors.black),
//                       const SizedBox(width: 4),
//                       _buildShareIcon(Icons.share, const Color(0xFFEA4335)),
//                       const SizedBox(width: 4),
//                       _buildShareIcon(Icons.chat_bubble, const Color(0xFF25D366)),
//                       const Spacer(),
//                       const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.share, size: 11, color: Colors.black87),
//                           SizedBox(width: 2),
//                           Text(
//                             'SHARE',
//                             style: TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 32),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'RACE FINISHED',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 26,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: 1.1,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'RECORD: 1000m ($finishTime)',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 hasAnyBet
//                     ? (winnerBet > 0 ? 'YOU WON!' : 'BETTER LUCK NEXT TIME')
//                     : 'NO BET PLACED',
//                 style: TextStyle(
//                   color: hasAnyBet && winnerBet > 0
//                       ? const Color(0xFF34D399)
//                       : const Color(0xFFFBBF24),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               RichText(
//                 text: TextSpan(
//                   style:
//                   const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
//                   children: [
//                     const TextSpan(
//                         text: 'WINNER: ',
//                         style: TextStyle(color: Colors.white)),
//                     TextSpan(
//                       text: '#${winner.id} ${winner.name.toUpperCase()} ',
//                       style: const TextStyle(color: Color(0xFFFBBF24)),
//                     ),
//                     const TextSpan(
//                       text: '[ 9.6/10 ]',
//                       style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 hasAnyBet
//                     ? 'YOUR BETS: ${widget.placedBets.entries.map((e) => '#${e.key}:${e.value}').join(', ')}'
//                     : 'YOUR BETS: None',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               if (winnerBet > 0) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   'YOU WIN: $winAmount PTS',
//                   style: const TextStyle(
//                     color: Color(0xFF34D399),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//               ],
//               const SizedBox(height: 4),
//               const Text(
//                 'GOING BACK IN 5 SECONDS...',
//                 style: TextStyle(
//                   color: Colors.white70,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               const Text(
//                 '12x RUNNERS • 3x PAYOUT WIN',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.refresh, size: 14, color: Colors.black),
//                           SizedBox(width: 4),
//                           Text(
//                             'NEXT RACE',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF059669),
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(color: const Color(0xFF34D399)),
//                     ),
//                     child: const Text(
//                       'BALANCE: 10090 PTS',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 11,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildShareIcon(IconData icon, Color bg) {
//     return Container(
//       width: 18,
//       height: 18,
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(2),
//       ),
//       child: Icon(icon, color: Colors.white, size: 11),
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

import 'coundown_paint.dart';
import 'dust_painter.dart';
import 'hourse_model.dart';
import 'hourse_token.dart';

class GameScreen extends StatefulWidget {
  final Map<int, int> placedBets;

  const GameScreen({super.key, this.placedBets = const {}});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final HorseRacingViewModel _viewModel;

  late final AnimationController _gallopController;
  late final AnimationController _photoFinishController;

  final GlobalKey _trackScreenshotKey = GlobalKey();
  Uint8List? _capturedFinishImageBytes;

  bool _showGate = true;
  Timer? _gateTimer;
  bool _hasTriggeredPhoto = false;

  Timer? _autoBackTimer;

  List<int> _currentJockeyOrder = [];

  // Initial 5-second green loader state
  bool _isLoading = true;
  int _loadingSecondsLeft = 5;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _viewModel = HorseRacingViewModel();

    _gallopController = AnimationController(
      vsync: this,
      // 380ms se 30% tez -> ~292ms (380 / 1.3). Race speed 30% badhne par
      // legs bhi usi hisaab se tez move karni chahiye, warna sliding
      // jaisa dikhega.
      duration: const Duration(milliseconds: 292),
    );

    _photoFinishController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _viewModel.addListener(_onViewModelChanged);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // 5 seconds green loader countdown
    _startInitialLoader();
  }

  void _startInitialLoader() {
    _loadingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_loadingSecondsLeft > 1) {
          setState(() {
            _loadingSecondsLeft--;
          });
        } else {
          _loadingTimer?.cancel();
          setState(() {
            _isLoading = false;
          });
          // 5 seconds poore hone ke baad race aur gallop shuru hogi
          _gallopController.repeat();
          _viewModel.startOrResume();
        }
      }
    });
  }

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
    if (_viewModel.status == RaceStatus.running && !_isLoading) {
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
        _triggerFinishInstant();
      }
    } else if (_viewModel.status == RaceStatus.initial) {
      _gallopController.stop();
      _photoFinishController.reset();
      _hasTriggeredPhoto = false;
      _capturedFinishImageBytes = null;
      _currentJockeyOrder.clear();
      _gateTimer?.cancel();
      _gateTimer = null;
      if (!_showGate) setState(() => _showGate = true);
    }
  }

  void _triggerFinishInstant() {
    if (_hasTriggeredPhoto) return;
    _hasTriggeredPhoto = true;

    _gallopController.stop();

    if (mounted) {
      _photoFinishController.forward();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureRaceFinishFrame();
    });

    _autoBackTimer?.cancel();
    _autoBackTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _gallopController.dispose();
    _photoFinishController.dispose();
    _gateTimer?.cancel();
    _autoBackTimer?.cancel();
    super.dispose();
  }

  double _calculateHorseScreenX({
    required HorseModel horse,
    required int index,
    required double screenWidth,
    required double smoothLead,
    required double finishLineScreenX,
  }) {
    final double naturalStagger =
        ((index % 4) * 22.0) - ((index % 3) * 18.0) - (index * 4.0);

    // Pehle wave amplitude (38, 22) bahut zyada thi, isliye horses
    // pack ke beech zig-zag/jerky move karte the. Amplitude kam karke
    // movement ko zyada smooth aur glide-jaisa bana diya.
    final racePhase = smoothLead.clamp(0.0, 1.0) * 10.0 * math.pi;
    final waveA = math.sin(racePhase + (index * 1.85)) * 16.0;
    final waveB = math.cos((racePhase * 0.6) + (index * 2.7)) * 9.0;

    final relativeLeadOffset =
        (horse.progress - smoothLead) * (screenWidth * 0.70);

    final smoothEnvelope = math.sin(smoothLead.clamp(0.0, 1.0) * math.pi);
    final dynamicOffset =
        ((waveA + waveB + naturalStagger) * smoothEnvelope) + relativeLeadOffset;

    final bool isWinner = horse.rank == 1 ||
        (_viewModel.horses.isNotEmpty &&
            horse ==
                _viewModel.horses
                    .reduce((a, b) => a.progress > b.progress ? a : b));

    final double winnerLeadProgress = Curves.easeInOut.transform(
      ((smoothLead - 0.25) / 0.45).clamp(0.0, 1.0),
    );
    final double winnerExtraLead = isWinner ? (48.0 * winnerLeadProgress) : 0.0;

    const double startX = 40.0;
    final double centerPackX = screenWidth * 0.34;

    if (smoothLead < 0.15) {
      final enterT =
      Curves.easeOutCubic.transform((smoothLead / 0.15).clamp(0.0, 1.0));
      final currentBaseX = startX + ((centerPackX - startX) * enterT);
      return currentBaseX + (dynamicOffset * enterT) + winnerExtraLead;
    } else if (smoothLead <= 0.85) {
      return centerPackX + dynamicOffset + winnerExtraLead;
    } else {
      final sprintT = Curves.easeInQuad
          .transform(((smoothLead - 0.85) / 0.15).clamp(0.0, 1.0));

      final double trailOffset = isWinner ? 35.0 : (-40.0 - (index * 6.0));
      final double endTargetX = finishLineScreenX + trailOffset;

      return (centerPackX * (1.0 - sprintT)) +
          (endTargetX * sprintT) +
          (dynamicOffset * (1.0 - sprintT));
    }
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
              final screenHeight = constraints.maxHeight;

              final leadProgress = _viewModel.horses.isEmpty
                  ? 0.0
                  : _viewModel.horses
                  .map((h) => h.progress)
                  .reduce((a, b) => math.max(a, b));

              final winnerHorse = _viewModel.horses.isEmpty
                  ? null
                  : _viewModel.horses
                  .reduce((a, b) => a.progress > b.progress ? a : b);

              if (!_isLoading &&
                  winnerHorse != null &&
                  winnerHorse.progress >= 0.999 &&
                  !_hasTriggeredPhoto) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _triggerFinishInstant();
                });
              }

              final double mainTrackWidth = screenWidth * 8.5;
              final double finishLineWidth = screenHeight * 1.6;
              final double runoutTrackWidth = screenWidth * 2.0;

              final double totalTrackWidth =
                  mainTrackWidth + finishLineWidth + runoutTrackWidth;

              final double maxScrollableDistance =
                  mainTrackWidth + (finishLineWidth * 0.3) - (screenWidth * 0.45);

              final double finishLineScreenX = screenWidth * 0.68;

              // Yahan pehle "final double smoothLead = leadProgress;" seedha
              // tha, jiski wajah se horse position sirf viewModel ke notify
              // hone par hi update hoti thi — isse dikhne mein jerky/jump
              // wali movement lagti thi. Ab TweenAnimationBuilder se
              // leadProgress ko continuously interpolate karte hain, taaki
              // har frame par smoothLead thodi-thodi badhta rahe aur horse
              // glide karke chale, real gallop jaisa smooth feel aaye.
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(end: leadProgress),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutSine,
                builder: (context, smoothLead, _) {
                  final double trackScrollOffset = -(maxScrollableDistance *
                      smoothLead.clamp(0.0, 1.0));

                  return Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      RepaintBoundary(
                        key: _trackScreenshotKey,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            // 1. TRACK & FINISH LINE
                            Positioned(
                              left: trackScrollOffset,
                              top: 0,
                              bottom: 0,
                              width: totalTrackWidth,
                              child: SizedBox(
                                height: screenHeight,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      width: mainTrackWidth,
                                      height: screenHeight,
                                      child: Image.asset(
                                        'assets/top/fullimage.png',
                                        fit: BoxFit.fitHeight,
                                        repeat: ImageRepeat.repeatX,
                                        alignment: Alignment.centerLeft,
                                        gaplessPlayback: true,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFF0D1B2A),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: finishLineWidth,
                                      height: screenHeight,
                                      child: Image.asset(
                                        'assets/top/MAINFINSHLINE.png',
                                        fit: BoxFit.fill,
                                        gaplessPlayback: true,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFF415A77),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: runoutTrackWidth,
                                      height: screenHeight,
                                      child: Image.asset(
                                        'assets/top/fullimage.png',
                                        fit: BoxFit.fitHeight,
                                        repeat: ImageRepeat.repeatX,
                                        alignment: Alignment.centerLeft,
                                        gaplessPlayback: true,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFF0D1B2A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 2. Starting Gate
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
                                      color: const Color(0xFF1B263B),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // 3. 12 Horses Layer
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
                                    final double startY = math.max(
                                      0.0,
                                      (horseArea.maxHeight - totalLanes) / 2,
                                    );

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
                                            finishLineScreenX: finishLineScreenX,
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

                      // 4. Bottom Jockey Ranking Strip
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: _buildBottomJockeyBar(
                            screenWidth: screenWidth,
                            smoothLead: smoothLead,
                            finishLineScreenX: finishLineScreenX,
                          ),
                        ),
                      ),

                      // 5. SCREENSHOT FINISH OVERLAY
                      if (_viewModel.status == RaceStatus.completed ||
                          _hasTriggeredPhoto)
                        _buildRaceFinishOverlay(winnerHorse),

                      // 6. INITIAL 5-SECOND GREEN LOADER OVERLAY
                      if (_isLoading) _buildGreenInitialLoader(),
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

  /// 5-second countdown loader with animated progress ring + pop effect
  Widget _buildGreenInitialLoader({int totalSeconds = 5}) {
    final double progress =
    (_loadingSecondsLeft / totalSeconds).clamp(0.0, 1.0);

    return Container(
      color: Colors.black.withOpacity(0.55),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 0. Animated countdown ring (shrinks as time runs out)
          TweenAnimationBuilder<double>(
            key: ValueKey(_loadingSecondsLeft),
            tween: Tween<double>(begin: progress + (1 / totalSeconds), end: progress),
            duration: const Duration(milliseconds: 900),
            curve: Curves.linear,
            builder: (context, value, _) {
              return SizedBox(
                width: 126,
                height: 126,
                child: CustomPaint(
                  painter: CountdownRingPainter(progress: value),
                ),
              );
            },
          ),

          // Number pops/scales in each time it changes
          TweenAnimationBuilder<double>(
            key: ValueKey('scale_$_loadingSecondsLeft'),
            tween: Tween<double>(begin: 1.25, end: 1.0),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 105,
              height: 105,
              // 1. Outermost Bright Yellow Glow & Rim
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD000),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC000).withOpacity(0.85),
                    blurRadius: 28,
                    spreadRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4.5), // Outer yellow border width
              child: Container(
                // 2. Metallic Beveled Ring
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFE5B015),
                      Color(0xFF5A3602),
                      Color(0xFF1F1200),
                    ],
                    stops: [0.0, 0.35, 0.75, 1.0],
                  ),
                ),
                padding: const EdgeInsets.all(6.5),
                child: Container(
                  // 3. Deep Black Inner Recessed Core
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0F0B05),
                    border: Border.all(color: Colors.black, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black87,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  // 4. Center Bold Yellow Number
                  child: Text(
                    '$_loadingSecondsLeft',
                    style: const TextStyle(
                      color: Color(0xFFFFD000),
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'sans-serif',
                      height: 1.0,
                      shadows: [
                        Shadow(color: Color(0xFFFF9100), blurRadius: 10),
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1.5, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
    final phase = (_gallopController.value * 2 * math.pi) + (index * 1.57);

    // Up-down bounce hata diya — ab horse apni lane (baseY) par hi
    // sidha rehta hai, sirf aage (horizontally) glide karta hai.
    const double verticalBob = 0.0;

    // Shimmy hata diya — extra wobble add kar raha tha, isse movement
    // choppy lagti thi. Ab sirf clean horizontal glide hai.
    const double horizontalShimmy = 0.0;

    final double targetX = _calculateHorseScreenX(
      horse: horse,
      index: index,
      screenWidth: screenWidth,
      smoothLead: smoothLead,
      finishLineScreenX: finishLineScreenX,
    ) +
        horizontalShimmy;

    final isRunning =
        _viewModel.status == RaceStatus.running && !_hasTriggeredPhoto && !_isLoading;

    return Positioned(
      left: targetX,
      top: baseY + verticalBob,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          if (isRunning && horse.progress < 1.1) ...[
            Positioned(
              left: -2,
              bottom: -2,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _gallopController,
                  builder: (context, _) {
                    return CustomPaint(
                      size: const Size(16, 6),
                      painter: DustCloudPainter(
                        animationValue: _gallopController.value,
                        seed: index * 2,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: -2,
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _gallopController,
                  builder: (context, _) {
                    final frontPhase = (_gallopController.value + 0.35) % 1.0;
                    return CustomPaint(
                      size: const Size(14, 5),
                      painter: DustCloudPainter(
                        animationValue: frontPhase,
                        seed: (index * 2) + 1,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          HorseTokenWidget(
            horseNumber: horse.id,
            color: horse.color,
            gifPath: horse.gifPath,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomJockeyBar({
    required double screenWidth,
    required double smoothLead,
    required double finishLineScreenX,
  }) {
    return AnimatedBuilder(
      animation: _gallopController,
      builder: (context, _) {
        final Map<int, double> horseXMap = {};
        for (int i = 0; i < _viewModel.horses.length; i++) {
          final h = _viewModel.horses[i];
          final x = _calculateHorseScreenX(
            horse: h,
            index: i,
            screenWidth: screenWidth,
            smoothLead: smoothLead,
            finishLineScreenX: finishLineScreenX,
          );
          horseXMap[h.id] = x;
        }

        if (_currentJockeyOrder.isEmpty ||
            _currentJockeyOrder.length != _viewModel.horses.length) {
          final initialSorted = List<HorseModel>.from(_viewModel.horses)
            ..sort((a, b) =>
                (horseXMap[b.id] ?? 0).compareTo(horseXMap[a.id] ?? 0));
          _currentJockeyOrder = initialSorted.map((h) => h.id).toList();
        } else {
          const double overtakeThreshold = 15.0;
          bool swapped = true;
          int safetyLimit = 0;
          while (swapped && safetyLimit < 12) {
            swapped = false;
            safetyLimit++;
            for (int i = 0; i < _currentJockeyOrder.length - 1; i++) {
              final currentHorseId = _currentJockeyOrder[i];
              final nextHorseId = _currentJockeyOrder[i + 1];

              final currentX = horseXMap[currentHorseId] ?? 0.0;
              final nextX = horseXMap[nextHorseId] ?? 0.0;

              if (nextX > currentX + overtakeThreshold) {
                _currentJockeyOrder[i] = nextHorseId;
                _currentJockeyOrder[i + 1] = currentHorseId;
                swapped = true;
              }
            }
          }
        }

        final Map<int, int> rankMap = {};
        for (int i = 0; i < _currentJockeyOrder.length; i++) {
          rankMap[_currentJockeyOrder[i]] = i;
        }

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
                child: LayoutBuilder(
                  builder: (context, boxConstraints) {
                    final totalAvailableWidth = boxConstraints.maxWidth;
                    final totalHorses = _viewModel.horses.length;
                    if (totalHorses == 0) return const SizedBox.shrink();

                    final cardWidth = totalAvailableWidth / totalHorses;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (final horse in _viewModel.horses)
                          AnimatedPositioned(
                            key: ValueKey('jockey_card_${horse.id}'),
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeInOutCubic,
                            left: (rankMap[horse.id] ?? 0) * cardWidth,
                            top: 0,
                            bottom: 0,
                            width: cardWidth,
                            child: _buildJockeyCard(
                              horse: horse,
                              rankIndex: (rankMap[horse.id] ?? 0) + 1,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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

    final bool hasBet = (widget.placedBets[horse.id] ?? 0) > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: hasBet
              ? const Color(0xFFFFD000)
              : (rankIndex == 1 ? Colors.amberAccent : Colors.white24),
          width: hasBet ? 1.4 : (rankIndex == 1 ? 1.0 : 0.5),
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

  Widget _buildRaceFinishOverlay([HorseModel? currentLead]) {
    final winner = _viewModel.winnerSnapshot?.horse ??
        currentLead ??
        _viewModel.horses.firstWhere(
              (h) => h.rank == 1,
          orElse: () => _viewModel.horses.first,
        );
    final finishTime = _viewModel.winnerSnapshot?.finishTime ?? "20.00s";

    final int winnerBet = widget.placedBets[winner.id] ?? 0;
    final int totalBetAmount =
    widget.placedBets.values.fold(0, (sum, v) => sum + v);
    final bool hasAnyBet = totalBetAmount > 0;
    final int winAmount = winnerBet * 3;

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
              Text(
                hasAnyBet
                    ? (winnerBet > 0 ? 'YOU WON!' : 'BETTER LUCK NEXT TIME')
                    : 'NO BET PLACED',
                style: TextStyle(
                  color: hasAnyBet && winnerBet > 0
                      ? const Color(0xFF34D399)
                      : const Color(0xFFFBBF24),
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
              Text(
                hasAnyBet
                    ? 'YOUR BETS: ${widget.placedBets.entries.map((e) => '#${e.key}:${e.value}').join(', ')}'
                    : 'YOUR BETS: None',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (winnerBet > 0) ...[
                const SizedBox(height: 4),
                Text(
                  'YOU WIN: $winAmount PTS',
                  style: const TextStyle(
                    color: Color(0xFF34D399),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              const Text(
                'GOING BACK IN 5 SECONDS...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '12x RUNNERS • 3x PAYOUT WIN',
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
                      Navigator.of(context).pop();
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
}