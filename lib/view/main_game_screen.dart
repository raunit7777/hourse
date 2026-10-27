//
//
//
// import 'dart:async';
// import 'dart:math' as math;
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:hours_riding/view/sound_contoler.dart';
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
//   bool _isSoundMuted = false;
//   int _walletBalance = 10090;
//   // Sound loop double-trigger protection
//   bool _isGallopStarted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _viewModel = HorseRacingViewModel();
//
//     // 1. Audio engine ensure initialize aur flag reset taaki har race me sound baje
//     _isGallopStarted = false;
//     SoundController.instance.ensureInitialized();
//
//     _gallopController = AnimationController(
//       vsync: this,
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
//     // 5 seconds countdown loader start
//     _startInitialLoader();
//   }
//
//   void _startInitialLoader() {
//     _loadingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted) return;
//
//       if (_loadingSecondsLeft > 1) {
//         setState(() {
//           _loadingSecondsLeft--;
//         });
//       } else {
//         _loadingTimer?.cancel();
//         setState(() {
//           _isLoading = false;
//         });
//
//         // 1. Gate 500ms baad gayab
//         _gateTimer?.cancel();
//         _gateTimer = Timer(const Duration(milliseconds: 500), () {
//           if (mounted) setState(() => _showGate = false);
//         });
//
//         // 2. Start Sound (Horse Neigh)
//         SoundController.instance.playRaceStart();
//
//         // 3. Gallop controller & Game engine start
//         _gallopController.repeat();
//         _viewModel.startOrResume();
//
//         // 🎯 4. RUNNING / GALLOP SOUND (Yeh line miss ho gayi thi):
//         Timer(const Duration(milliseconds: 600), () {
//           if (mounted && _viewModel.status == RaceStatus.running) {
//             _isGallopStarted = true;
//             SoundController.instance.startGallopLoop();
//           }
//         });
//       }
//     });
//   }
//
//   void _onViewModelChanged() {
//     // 🛑 NOTICE: Yahan se startGallopLoop bilkul hata diya gaya hai!
//     // Listener sirf Stop aur Finish ko handle karega.
//     if (_viewModel.status == RaceStatus.paused) {
//       _gallopController.stop();
//       SoundController.instance.stopGallopLoop();
//     } else if (_viewModel.status == RaceStatus.completed) {
//       _triggerFinishInstant();
//     } else if (_viewModel.status == RaceStatus.initial) {
//       _gallopController.stop();
//       _photoFinishController.reset();
//       _hasTriggeredPhoto = false;
//       SoundController.instance.stopAll();
//     }
//   }
//
//   void _triggerFinishInstant() {
//     if (_hasTriggeredPhoto) return;
//     _hasTriggeredPhoto = true;
//
//     _gallopController.stop();
//
//     SoundController.instance.playWinSound();
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
//
//
//
//
//
//
//
//
//
//
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
//   // void _onViewModelChanged() {
//   //   if (_viewModel.status == RaceStatus.running && !_isLoading) {
//   //     if (!_gallopController.isAnimating) {
//   //       _gallopController.repeat();
//   //     }
//   //     // Single time sound check (Baar-baar trigger hone se bachega)
//   //     if (!_isGallopStarted) {
//   //       _isGallopStarted = true;
//   //       SoundController.instance.startGallopLoop();
//   //     }
//   //
//   //     if (_showGate && _gateTimer == null) {
//   //       _gateTimer = Timer(const Duration(milliseconds: 500), () {
//   //         if (mounted) setState(() => _showGate = false);
//   //       });
//   //     }
//   //   } else if (_viewModel.status == RaceStatus.paused) {
//   //     _gallopController.stop();
//   //     _isGallopStarted = false;
//   //     SoundController.instance.stopGallopLoop();
//   //   } else if (_viewModel.status == RaceStatus.completed) {
//   //     if (!_hasTriggeredPhoto) {
//   //       _triggerFinishInstant();
//   //     }
//   //   } else if (_viewModel.status == RaceStatus.initial) {
//   //     _gallopController.stop();
//   //     _photoFinishController.reset();
//   //     _hasTriggeredPhoto = false;
//   //     _capturedFinishImageBytes = null;
//   //     _currentJockeyOrder.clear();
//   //     _gateTimer?.cancel();
//   //     _gateTimer = null;
//   //     _isGallopStarted = false;
//   //     SoundController.instance.stopGallopLoop();
//   //     if (!_showGate) setState(() => _showGate = true);
//   //   }
//   // }
//   //
//   // void _triggerFinishInstant() {
//   //   if (_hasTriggeredPhoto) return;
//   //   _hasTriggeredPhoto = true;
//   //
//   //   _gallopController.stop();
//   //
//   //   // Running loop turant band karo aur Win sound bajao
//   //   _isGallopStarted = false;
//   //   SoundController.instance.stopGallopLoop();
//   //
//   //   // ================= SOUND 3: WIN / FINISH POPUP EXACT INSTANT =================
//   //   SoundController.instance.playWinSound();
//   //
//   //   if (mounted) {
//   //     _photoFinishController.forward();
//   //   }
//   //
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     _captureRaceFinishFrame();
//   //   });
//   //
//   //   _autoBackTimer?.cancel();
//   //   _autoBackTimer = Timer(const Duration(seconds: 5), () {
//   //     if (mounted) Navigator.of(context).pop();
//   //   });
//   // }
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
//
//     _isGallopStarted = false;
//     SoundController.instance.stopAll();
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
//     final waveA = math.sin(racePhase + (index * 1.85)) * 16.0;
//     final waveB = math.cos((racePhase * 0.6) + (index * 2.7)) * 9.0;
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
//               return TweenAnimationBuilder<double>(
//                 tween: Tween<double>(end: leadProgress),
//                 duration: const Duration(milliseconds: 220),
//                 curve: Curves.easeOutSine,
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
//                             if (_showGate)
//                               Positioned(
//                                 left: 0,
//                                 top: 0,
//                                 bottom: 60,
//                                 width: screenWidth * 0.14,
//                                 child: IgnorePointer(
//                                   child: AnimatedOpacity(
//                                     opacity: _showGate ? 1.0 : 0.0,
//                                     duration: const Duration(milliseconds: 400),
//                                     curve: Curves.easeOut,
//                                     child: Image.asset(
//                                       'assets/sprites/GATE.png',
//                                       fit: BoxFit.fill,
//                                       gaplessPlayback: true,
//                                       errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//                                     ),
//                                   ),
//                                 ),
//                               ),
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
//                                             finishLineScreenX:
//                                             finishLineScreenX,
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
//                       // 4. Top Header Action Bar (HISTORY, WALLET, GUIDE, SOUND)
//                       Positioned(
//                         top: 8,
//                         left: 10,
//                         right: 10,
//                         child: SafeArea(
//                           bottom: false,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Left Side Buttons
//                               Row(
//                                 children: [
//                                   _buildTopActionButton(
//                                     icon: Icons.history,
//                                     label: 'HISTORY',
//                                     onTap: () => _showHistoryDialog(context),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   _buildTopActionButton(
//                                     icon: Icons.account_balance_wallet,
//                                     label: 'WALLET',
//                                     onTap: () => _showWalletDialog(context),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   _buildTopActionButton(
//                                     icon: Icons.help_outline,
//                                     label: 'GUIDE',
//                                     onTap: () => _showGuideDialog(context),
//                                   ),
//                                   const SizedBox(width: 6),
//                                   _buildTopActionButton(
//                                     icon: _isSoundMuted ? Icons.volume_off : Icons.volume_up,
//                                     label: 'SOUND',
//                                     onTap: () {
//                                       setState(() {
//                                         _isSoundMuted = !_isSoundMuted;
//                                         if (_isSoundMuted) {
//                                           SoundController.instance.stopAll();
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//
//                               // Center Live Title Badge
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.75),
//                                   borderRadius: BorderRadius.circular(16),
//                                   border: Border.all(color: Colors.amberAccent, width: 1.2),
//                                 ),
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(Icons.fiber_manual_record, color: Colors.redAccent, size: 10),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       'TURF DERBY 1000M',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w900,
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       '• LIVE TRACK',
//                                       style: TextStyle(
//                                         color: Colors.amberAccent,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//
//                               // Right Side Wallet Display
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF1E293B),
//                                   borderRadius: BorderRadius.circular(6),
//                                   border: Border.all(color: Colors.amber, width: 1.2),
//                                 ),
//                                 child: Text(
//                                   'WALLET: $_walletBalance PTS',
//                                   style: const TextStyle(
//                                     color: Colors.amberAccent,
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w900,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       // 5. Bottom Jockey Ranking Strip
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
//                       // 6. SCREENSHOT FINISH OVERLAY
//                       if (_viewModel.status == RaceStatus.completed ||
//                           _hasTriggeredPhoto)
//                         _buildRaceFinishOverlay(winnerHorse),
//
//                       // 7. INITIAL 5-SECOND GREEN LOADER OVERLAY
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
// // Top Action Button Widget Builder
//   Widget _buildTopActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E293B).withOpacity(0.9),
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(color: Colors.amberAccent.withOpacity(0.6), width: 1),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, color: Colors.amberAccent, size: 13),
//             const SizedBox(width: 4),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 10,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// // Dialog Popups for History, Wallet, and Guide
//   void _showHistoryDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF0F172A),
//         title: const Text('Race History', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
//         content: const Text('Recent Races:\n1. #4 Royal (Won 3x)\n2. #1 Toofan (Won 3x)\n3. #7 Lucky (Lost)', style: TextStyle(color: Colors.white)),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.amberAccent))),
//         ],
//       ),
//     );
//   }
//
//   void _showWalletDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF0F172A),
//         title: const Text('Wallet Details', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
//         content: Text('Current Balance: $_walletBalance PTS\n\nDeposit and Withdrawal options are active.', style: const TextStyle(color: Colors.white)),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.amberAccent))),
//         ],
//       ),
//     );
//   }
//
//   void _showGuideDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF0F172A),
//         title: const Text('Game Guide', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
//         content: const Text('• 12 Horses compete in a 1000m Turf Derby.\n• Place your bets before the race starts.\n• Winning horses pay 3x your placed bet amount.', style: TextStyle(color: Colors.white)),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(color: Colors.amberAccent))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGreenInitialLoader({int totalSeconds = 5}) {
//     final double progress =
//     (_loadingSecondsLeft / totalSeconds).clamp(0.0, 1.0);
//
//     return SizedBox.expand(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           // 1. Full Screen Background Image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/top/full_track_bg.png', // 👈 Apni background image ka exact path dalein
//               fit: BoxFit.fill,
//             ),
//           ),
//
//           // 2. Dim Overlay (taaki beech ka countdown clear dikhe)
//           Positioned.fill(
//             child: Container(
//               color: Colors.black.withOpacity(0.45),
//             ),
//           ),
//
//           // 3. Center Countdown Timer Ring & Number
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               TweenAnimationBuilder<double>(
//                 key: ValueKey(_loadingSecondsLeft),
//                 tween: Tween<double>(
//                   begin: progress + (1 / totalSeconds),
//                   end: progress,
//                 ),
//                 duration: const Duration(milliseconds: 900),
//                 curve: Curves.linear,
//                 builder: (context, value, _) {
//                   return SizedBox(
//                     width: 126,
//                     height: 126,
//                     child: CustomPaint(
//                       painter: CountdownRingPainter(progress: value),
//                     ),
//                   );
//                 },
//               ),
//               TweenAnimationBuilder<double>(
//                 key: ValueKey('scale_$_loadingSecondsLeft'),
//                 tween: Tween<double>(begin: 1.25, end: 1.0),
//                 duration: const Duration(milliseconds: 260),
//                 curve: Curves.easeOutBack,
//                 builder: (context, scale, child) {
//                   return Transform.scale(scale: scale, child: child);
//                 },
//                 child: Container(
//                   width: 105,
//                   height: 105,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: const Color(0xFFFFD000),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFFFFC000).withOpacity(0.85),
//                         blurRadius: 28,
//                         spreadRadius: 6,
//                       ),
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.7),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(4.5),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomLeft,
//                         end: Alignment.topRight,
//                         colors: [
//                           Color(0xFFFFFFFF),
//                           Color(0xFFE5B015),
//                           Color(0xFF5A3602),
//                           Color(0xFF1F1200),
//                         ],
//                         stops: [0.0, 0.35, 0.75, 1.0],
//                       ),
//                     ),
//                     padding: const EdgeInsets.all(6.5),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: const Color(0xFF0F0B05),
//                         border: Border.all(color: Colors.black, width: 1.5),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black87,
//                             blurRadius: 5,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         '$_loadingSecondsLeft',
//                         style: const TextStyle(
//                           color: Color(0xFFFFD000),
//                           fontSize: 44,
//                           fontWeight: FontWeight.w900,
//                           fontFamily: 'sans-serif',
//                           height: 1.0,
//                           shadows: [
//                             Shadow(color: Color(0xFFFF9100), blurRadius: 10),
//                             Shadow(
//                               color: Colors.black,
//                               offset: Offset(1.5, 2),
//                               blurRadius: 3,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
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
//     const double verticalBob = 0.0;
//     const double horizontalShimmy = 0.0;
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
import 'package:hours_riding/view/sound_contoler.dart';

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

  // Sound loop double-trigger protection
  bool _isGallopStarted = false;

  // Wallet & Audio State
  int _walletBalance = 10090;
  bool _isMasterMuted = false;
  double _voiceAlertsVol = 1.0;
  double _coinChipsVol = 0.8;
  double _horsesVol = 0.9;

  @override
  void initState() {
    super.initState();
    _viewModel = HorseRacingViewModel();

    _isGallopStarted = false;
    SoundController.instance.ensureInitialized();

    _gallopController = AnimationController(
      vsync: this,
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

    _startInitialLoader();
  }

  void _startInitialLoader() {
    _loadingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_loadingSecondsLeft > 1) {
        setState(() {
          _loadingSecondsLeft--;
        });
      } else {
        _loadingTimer?.cancel();
        setState(() {
          _isLoading = false;
        });

        // 1. Gate 500ms baad gayab
        _gateTimer?.cancel();
        _gateTimer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _showGate = false);
        });

        // 2. Start Sound
        if (!_isMasterMuted) {
          SoundController.instance.playRaceStart();
        }

        // 3. Gallop controller & Game engine start
        _gallopController.repeat();
        _viewModel.startOrResume();

        // 4. Running gallop sound
        Timer(const Duration(milliseconds: 600), () {
          if (mounted && _viewModel.status == RaceStatus.running) {
            _isGallopStarted = true;
            if (!_isMasterMuted) {
              SoundController.instance.startGallopLoop();
            }
          }
        });
      }
    });
  }

  void _onViewModelChanged() {
    if (_viewModel.status == RaceStatus.paused) {
      _gallopController.stop();
      SoundController.instance.stopGallopLoop();
    } else if (_viewModel.status == RaceStatus.completed) {
      _triggerFinishInstant();
    } else if (_viewModel.status == RaceStatus.initial) {
      _gallopController.stop();
      _photoFinishController.reset();
      _hasTriggeredPhoto = false;
      SoundController.instance.stopAll();
    }
  }

  void _triggerFinishInstant() {
    if (_hasTriggeredPhoto) return;
    _hasTriggeredPhoto = true;

    _gallopController.stop();

    if (!_isMasterMuted) {
      SoundController.instance.playWinSound();
    }

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

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _gallopController.dispose();
    _photoFinishController.dispose();
    _gateTimer?.cancel();
    _autoBackTimer?.cancel();

    _isGallopStarted = false;
    SoundController.instance.stopAll();
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
                            if (_showGate)
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
                                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ),
                            if (!_isLoading)
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
                                            finishLineScreenX:
                                            finishLineScreenX,
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

                      // 4. TOP ACTION BAR (Screenshot 1 Match: History, Wallet, Guide, Sound | Live Track | Wallet)[cite: 1]
                      Positioned(
                        top: 6,
                        left: 8,
                        right: 8,
                        child: SafeArea(
                          bottom: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left Action Buttons[cite: 1]
                              Row(
                                children: [
                                  _buildTopActionButton(
                                    icon: Icons.history,
                                    label: 'HISTORY',
                                    onTap: () => _showHistoryModal(context),
                                  ),
                                  const SizedBox(width: 5),
                                  _buildTopActionButton(
                                    icon: Icons.account_balance_wallet_outlined,
                                    label: 'WALLET',
                                    onTap: () => _showWalletModal(context),
                                  ),
                                  const SizedBox(width: 5),
                                  _buildTopActionButton(
                                    icon: Icons.help_outline,
                                    label: 'GUIDE',
                                    onTap: () => _showGuideModal(context),
                                  ),
                                  const SizedBox(width: 5),
                                  _buildTopActionButton(
                                    icon: _isMasterMuted ? Icons.volume_off : Icons.settings,
                                    label: 'SOUND',
                                    onTap: () => _showSoundSettingsModal(context),
                                  ),
                                ],
                              ),

                              // Center Track Badge[cite: 1]
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.brown.shade700, width: 1.0),
                                ),
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.flag, color: Colors.amber, size: 10),
                                    SizedBox(width: 4),
                                    Text(
                                      'TURF DERBY 1000M',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF7F1D1D),
                                        borderRadius: BorderRadius.all(Radius.circular(3)),
                                      ),
                                      child: const Text(
                                        'LIVE TRACK',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 7.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Right Wallet Badge[cite: 1]
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.tealAccent.shade400, width: 1.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'WALLET: $_walletBalance',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.add_circle, color: Colors.tealAccent, size: 12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 5. Bottom Jockey Ranking Strip
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

                      // 6. SCREENSHOT FINISH OVERLAY
                      if (_viewModel.status == RaceStatus.completed ||
                          _hasTriggeredPhoto)
                        _buildRaceFinishOverlay(winnerHorse),

                      // 7. INITIAL 5-SECOND GREEN LOADER OVERLAY
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

  // Top Action Button Helper[cite: 1]
  Widget _buildTopActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF475569), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.amberAccent, size: 11),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= 1. SOUND SETTINGS MODAL (Screenshot 5 Match)[cite: 5] =================
  void _showSoundSettingsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final soundCtrl = SoundController.instance;

            return Center(
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF120C06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF85501B), width: 1.5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AUDIO & SOUND SETTINGS',
                                style: TextStyle(
                                  color: Color(0xFF34D399),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Adjust volume levels or mute individual sound channels',
                                style: TextStyle(color: Colors.white60, fontSize: 8),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white70, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Master Game Sound
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF221609),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Master Game Sound',
                                  style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  soundCtrl.isMasterMuted ? 'Audio channels are muted' : 'Audio channels are active',
                                  style: const TextStyle(color: Colors.white54, fontSize: 7.5),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                setModalState(() {
                                  soundCtrl.setMasterMute(!soundCtrl.isMasterMuted);
                                });
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: soundCtrl.isMasterMuted ? Colors.redAccent : const Color(0xFF059669),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  soundCtrl.isMasterMuted ? 'UNMUTE ALL' : 'MUTE ALL',
                                  style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 1. Alerts & Photo Click
                      _buildVolumeRow(
                        title: 'Game Voice & Alerts',
                        subtitle: 'Countdown alert, 5s warning, photo finish shutter',
                        value: soundCtrl.alertsVolume,
                        onChanged: (v) {
                          setModalState(() => soundCtrl.setAlertsVolume(v));
                          setState(() {});
                        },
                        onTest: () => soundCtrl.playWinSound(),
                      ),
                      const SizedBox(height: 6),

                      // 2. Chip Clicks
                      _buildVolumeRow(
                        title: 'Coin Voice & Bet Chips',
                        subtitle: 'Coin selection click, tap to bet placement, double/clear',
                        value: soundCtrl.chipsVolume,
                        onChanged: (v) {
                          setModalState(() => soundCtrl.setChipsVolume(v));
                          setState(() {});
                        },
                        onTest: null,
                      ),
                      const SizedBox(height: 6),

                      // 3. Horse Gallop & Neigh
                      _buildVolumeRow(
                        title: 'Horses Voice (Neigh & Gallop)',
                        subtitle: 'Race start horse neigh and galloping sprint sound effects',
                        value: soundCtrl.horsesVolume,
                        onChanged: (v) {
                          setModalState(() => soundCtrl.setHorsesVolume(v));
                          setState(() {});
                        },
                        onTest: () => soundCtrl.playRaceStart(),
                      ),
                      const SizedBox(height: 12),

                      // Footer Buttons
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setModalState(() {
                                soundCtrl.setMasterMute(false);
                                soundCtrl.setAlertsVolume(1.0);
                                soundCtrl.setChipsVolume(0.8);
                                soundCtrl.setHorsesVolume(0.9);
                              });
                              setState(() {});
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Reset\nDefaults',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white60, fontSize: 8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'DONE',
                                  style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVolumeRow({
    required String title,
    required String subtitle,
    required double value,
    required ValueChanged<double> onChanged,
    VoidCallback? onTest,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1309),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 6.5)),
                ],
              ),
              Row(
                children: [
                  Text('${(value * 100).toInt()}%', style: const TextStyle(color: Colors.white70, fontSize: 8)),
                  if (onTest != null) ...[
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: onTest,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.play_arrow, color: Colors.amberAccent, size: 9),
                            SizedBox(width: 2),
                            Text('Test', style: TextStyle(color: Colors.amberAccent, fontSize: 7.5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
              activeTrackColor: Colors.amber,
              inactiveTrackColor: Colors.white12,
              thumbColor: Colors.amberAccent,
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }



  // ================= 2. COIN WALLET & LEDGER MODAL (Screenshot 4 Match)[cite: 4] =================
  void _showWalletModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Center(
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF131A26),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF85501B), width: 1.5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header[cite: 4]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'REAL-TIME CASINO WALLET',
                                style: TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.account_balance_wallet, color: Colors.white, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'Coin Wallet & Ledger',
                                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white70, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Total Accredited Balance Card[cite: 4]
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'TOTAL ACCREDITED BALANCE',
                              style: TextStyle(color: Colors.white60, fontSize: 7.5, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$_walletBalance COINS',
                              style: const TextStyle(
                                color: Color(0xFFFFD000),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 10),
                                SizedBox(width: 3),
                                Text(
                                  '100% Cryptographically Verified In-Memory & REST Ledger',
                                  style: TextStyle(color: Colors.greenAccent, fontSize: 7.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Claim Free Coins[cite: 4]
                      InkWell(
                        onTap: () {
                          setModalState(() => _walletBalance += 10);
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade900.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.tealAccent, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline, color: Colors.tealAccent, size: 12),
                              SizedBox(width: 5),
                              Text(
                                'CLAIM +10 FREE COINS',
                                style: TextStyle(color: Colors.tealAccent, fontSize: 9.5, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Activity History[cite: 4]
                      const Text(
                        'Activity History',
                        style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      _buildLedgerRow(
                        title: '10X Race Winning',
                        subtitle: 'Won 10X on Horse #1 TOOFAN • 12:29',
                        amount: '+100.00',
                        isCredit: true,
                      ),
                      _buildLedgerRow(
                        title: 'Derby Race Bet',
                        subtitle: 'Race Bet (Round #DERBY_1789714730764) • 12:28',
                        amount: '-10.00',
                        isCredit: false,
                      ),
                      _buildLedgerRow(
                        title: 'Wallet Recharge',
                        subtitle: 'Welcome Bonus Credits • 12:28',
                        amount: '+10000.00',
                        isCredit: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLedgerRow({
    required String title,
    required String subtitle,
    required String amount,
    required bool isCredit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit ? Colors.greenAccent : Colors.redAccent,
                size: 13,
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 6.5)),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              color: isCredit ? Colors.greenAccent : Colors.redAccent,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // ================= 3. BET HISTORY MODAL (Screenshot 3 Match)[cite: 3] =================
  void _showHistoryModal(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return Center(
          child: Container(
            width: 480,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF140D24),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF581C87), width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title Header[cite: 3]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.history, color: Colors.amber, size: 16),
                          SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HORSE RACING — RACE & BET RECORDS',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                              ),
                              Text(
                                'Track your bets, match winners, and high-speed photo-finish snapshots',
                                style: TextStyle(color: Colors.white54, fontSize: 7),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white70, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Tab Buttons[cite: 3]
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B0764),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.amber, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: const Text('BET HISTORY (1)', style: TextStyle(color: Colors.amber, fontSize: 8.5, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1B4B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: const Text('GAME MATCHES RESULTS (13)', style: TextStyle(color: Colors.white60, fontSize: 8.5, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Stat Badges[cite: 3]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatBox('TOTAL BETS', '1'),
                      _buildStatBox('WON BETS', '1'),
                      _buildStatBox('WIN RATE', '100%'),
                      _buildStatBox('NET COINS', '+100 PTS', color: Colors.greenAccent),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Record Item[cite: 3]
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1536),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MATCH #1 • 12:29:53', style: TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text('Winner: #1 TOOFAN • Your Pick: #1 TOOFAN • Bet: 10 PTS', style: TextStyle(color: Colors.amberAccent, fontSize: 7.5)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade900,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text('+100 PTS\nVICTORY (10X)', textAlign: TextAlign.center, style: TextStyle(color: Colors.greenAccent, fontSize: 7, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Close Button[cite: 3]
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const Text('CLOSE', style: TextStyle(color: Colors.black, fontSize: 9.5, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatBox(String label, String value, {Color color = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF261942),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 6.5)),
          Text(value, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ================= 4. OFFICIAL GAME GUIDE MODAL (Screenshot 2 Match)[cite: 2] =================
  void _showGuideModal(BuildContext context) {
    int currentStep = 1;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Center(
              child: Container(
                width: 480,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF140D07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF85501B), width: 1.5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header[cite: 2]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                              SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TEZ RAFTER • OFFICIAL GAME GUIDE',
                                    style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    'Complete Step-by-Step Rules & Flow (गेम गाइड और नियम)',
                                    style: TextStyle(color: Colors.white60, fontSize: 7),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white70, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Stepper Tabs[cite: 2]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStepTab(1, 'Coins', currentStep),
                          _buildStepTab(2, 'Horses', currentStep),
                          _buildStepTab(3, 'Timer', currentStep),
                          _buildStepTab(4, 'Race', currentStep),
                          _buildStepTab(5, 'Jackpot', currentStep),
                          _buildStepTab(6, 'Payout', currentStep),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Step 1 Body Details[cite: 2]
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF221609),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade900,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text('STEP 1 • COINS & STAKE', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Select Chip Stake & Wallet Recharge',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              '1. सिक्का (Coin) चुनें और वॉलेट रिचार्ज करें',
                              style: TextStyle(color: Colors.amber, fontSize: 8.5),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Choose your desired coin value (2, 5, 10, 100, 500, 1000) from the bottom wooden plank to set your bet denomination.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70, fontSize: 7.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Navigation Footer[cite: 2]
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$currentStep of 6', style: const TextStyle(color: Colors.white54, fontSize: 8.5)),
                          InkWell(
                            onTap: () {
                              setModalState(() {
                                if (currentStep < 6) currentStep++;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('NEXT STEP >', style: TextStyle(color: Colors.black, fontSize: 8.5, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStepTab(int step, String label, int activeStep) {
    final bool isActive = step == activeStep;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? Colors.amber.shade700 : const Color(0xFF1E150B),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: isActive ? Colors.amber : Colors.white12),
      ),
      child: Column(
        children: [
          Text('$step', style: TextStyle(color: isActive ? Colors.black : Colors.white70, fontSize: 8, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: isActive ? Colors.black : Colors.white54, fontSize: 6.5)),
        ],
      ),
    );
  }

  Widget _buildGreenInitialLoader({int totalSeconds = 5}) {
    final double progress =
    (_loadingSecondsLeft / totalSeconds).clamp(0.0, 1.0);

    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                key: ValueKey(_loadingSecondsLeft),
                tween: Tween<double>(
                  begin: progress + (1 / totalSeconds),
                  end: progress,
                ),
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
                  padding: const EdgeInsets.all(4.5),
                  child: Container(
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
    const double verticalBob = 0.0;
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
                    child: Text(
                      'BALANCE: $_walletBalance PTS',
                      style: const TextStyle(
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