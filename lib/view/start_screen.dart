// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
//
// import 'main_game_screen.dart';
//
// class HorseRacingScreen extends StatefulWidget {
//   const HorseRacingScreen({super.key});
//
//   @override
//   State<HorseRacingScreen> createState() => _HorseRacingScreenState();
// }
//
// class _HorseRacingScreenState extends State<HorseRacingScreen> {
//   // ---------- Colors ----------
//   static const Color _gold = Color(0xFFF1AC48);
//   static const Color _brightGold = Color(0xFFFFC533);
//   static const Color _cream = Color(0xFFE9DCC6);
//   static const Color _woodDark = Color(0xFF2E1406);
//   static const Color _woodMid = Color(0xFF5A2D12);
//   static const Color _woodLight = Color(0xFF7A3F19);
//
//   static const List<String> _jockeyImages = [
//     'assets/Bet_horses/horses1.png',
//     'assets/Bet_horses/horses2.png',
//     'assets/Bet_horses/horses3.png.png',
//     'assets/Bet_horses/horses4.png.png',
//     'assets/Bet_horses/horses5.png',
//     'assets/Bet_horses/horses6.png',
//     'assets/Bet_horses/horses7.png',
//     'assets/Bet_horses/horses8.png',
//     'assets/Bet_horses/horses9.png',
//     'assets/Bet_horses/horses10.png',
//     'assets/Bet_horses/horses11.png',
//     'assets/Bet_horses/horses12.png',
//   ];
//
//   // Optional background image (grass / stable / mountains).
//   // Agar asset nahi mila to gradient fallback dikhega.
//   static const String _bgImage = 'assets/Bet_horses/race_bg.png';
//
//   final List<Map<String, dynamic>> _chipList = const [
//     {'val': 2, 'img': 'assets/bet_coins/betcoin2.png', 'color': Color(0xFFC62828)},
//     {'val': 5, 'img': 'assets/bet_coins/betcoin5.png', 'color': Color(0xFF2E7D32)},
//     {'val': 10, 'img': 'assets/bet_coins/betcoin10.png', 'color': Color(0xFF1565C0)},
//     {'val': 100, 'img': 'assets/bet_coins/betcoin100.png', 'color': Color(0xFF212121)},
//     {'val': 200, 'img': 'assets/bet_coins/betcoin200.png', 'color': Color(0xFF6A1B9A)},
//     {'val': 500, 'img': 'assets/bet_coins/betcoin500.png', 'color': Color(0xFFE65100)},
//     {'val': 1000, 'img': 'assets/bet_coins/betcoin1000.png', 'color': Color(0xFFB71C1C)},
//   ];
//
//   int selectedChip = 10;
//   int secondsLeft = 16;
//   Timer? _timer;
//   double _s = 1.0; // scale factor
//
//   late List<Map<String, dynamic>> horses;
//
//   final List<Map<String, dynamic>> _results = const [
//     {'id': 5, 'name': 'TARZAN'},
//     {'id': 6, 'name': 'CHETAK'},
//     {'id': 10, 'name': 'TIGER'},
//     {'id': 1, 'name': 'TOOFAN'},
//     {'id': 1, 'name': 'TOOFAN'},
//     {'id': 1, 'name': 'TOOFAN'},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//
//     // SABHI HORSES KI BET 0 SE SHURU HOTI HAI — koi bhi horse
//     // pre-selected nahi hai. (Pehle Royal/Tiger/Badal ke bet: 10
//     // hardcoded the, isliye wo glow karte the — ab fix.)
//     horses = [
//       {'id': 1, 'name': 'TOOFAN', 'bet': 0, 'img': _jockeyImages[0]},
//       {'id': 2, 'name': 'RANGEELA', 'bet': 0, 'img': _jockeyImages[1]},
//       {'id': 3, 'name': 'ARJUN', 'bet': 0, 'img': _jockeyImages[2]},
//       {'id': 4, 'name': 'ROYAL', 'bet': 0, 'img': _jockeyImages[3]},
//       {'id': 5, 'name': 'TARZAN', 'bet': 0, 'img': _jockeyImages[4]},
//       {'id': 6, 'name': 'CHETAK', 'bet': 0, 'img': _jockeyImages[5]},
//       {'id': 7, 'name': 'LUCKY', 'bet': 0, 'img': _jockeyImages[6]},
//       {'id': 8, 'name': 'BAAZIGAR', 'bet': 0, 'img': _jockeyImages[7]},
//       {'id': 9, 'name': 'JEET', 'bet': 0, 'img': _jockeyImages[8]},
//       {'id': 10, 'name': 'TIGER', 'bet': 0, 'img': _jockeyImages[9]},
//       {'id': 11, 'name': 'BADAL', 'bet': 0, 'img': _jockeyImages[10]},
//       {'id': 12, 'name': 'VICTOR', 'bet': 0, 'img': _jockeyImages[11]},
//     ];
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         if (secondsLeft > 0) {
//           setState(() {
//             secondsLeft--;
//           });
//         } else {
//           // Timer 0 ho gaya — betting band, ab race screen par jao.
//           _timer?.cancel();
//           // _goToRaceScreen();
//         }
//       }
//     });
//   }
//
//   // Betting time khatam hone par GameScreen (race animation) par navigate karo.
//   // Bets ko GameScreen ko de rahe hain taaki wahan bhi use ho sakein
//   // (agar GameScreen abhi bets accept nahi karta, to bhi navigation kaam karega).
//   // void _goToRaceScreen() async {
//   //   final placedBets = <int, int>{
//   //     for (final h in horses)
//   //       if ((h['bet'] as int) > 0) (h['id'] as int): (h['bet'] as int),
//   //   };
//   //
//   //   await Navigator.of(context).push(
//   //     MaterialPageRoute(
//   //       builder: (_) => GameScreen(placedBets: placedBets),
//   //     ),
//   //   );
//   //
//   //   // Race screen se wapas aane par naya round shuru karo, sab bets clear.
//   //   if (mounted) {
//   //     setState(() {
//   //       for (var h in horses) {
//   //         h['bet'] = 0;
//   //       }
//   //       secondsLeft = 20;
//   //     });
//   //     _startTimer();
//   //   }
//   // }
//
//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         if (secondsLeft > 0) {
//           setState(() {
//             secondsLeft--;
//           });
//         } else {
//           _timer?.cancel();
//           // _goToRaceScreen();
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     super.dispose();
//   }
//
//   double get totalPlay =>
//       horses.fold(0.0, (sum, item) => sum + (item['bet'] as int));
//
//   // =====================================================================
//   //                               BUILD
//   // =====================================================================
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     _s = (size.height / 360 < size.width / 780
//         ? size.height / 360
//         : size.width / 780)
//         .clamp(0.6, 1.7);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A0803),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/sprites/image.png'), // <-- Yahan apna asset path dein
//             fit: BoxFit.fill, // Poori screen cover karega bina aspect ratio bigade
//           ),
//         ),
//         child: Row(
//           children: [
//
//             Expanded(
//               child: Column(
//                 children: [
//                   SizedBox(height: 4 * _s),
//                   _buildTopHeader(),
//                   SizedBox(height: 6 * _s),
//                   Expanded(child: _buildPlayArea()),
//                   _buildBottomFooter(),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   // =====================================================================
//   //                            SIDE BARS
//   // =====================================================================
//
//
//
//
//   Widget _buildTopHeader() {
//     return SizedBox(
//       height: 42 * _s,
//       child: Row(
//         children: [
//           _statBox("PLAY", totalPlay.toStringAsFixed(2)),
//           SizedBox(width: 8 * _s),
//           _statBox("WIN", "0.00"),
//           SizedBox(width: 8 * _s),
//           Flexible(
//             flex: 3,
//             child: FittedBox(fit: BoxFit.scaleDown, child: _coinsPill()),
//           ),
//           SizedBox(width: 6 * _s),
//           Flexible(
//             flex: 3,
//             child: FittedBox(fit: BoxFit.scaleDown, child: _gameIdPill()),
//           ),
//           SizedBox(width: 8 * _s),
//           Expanded(flex: 4, child: _titleBanner()),
//           SizedBox(width: 8 * _s),
//           _roundActionBtn(Icons.history),
//           SizedBox(width: 6 * _s),
//           _roundActionBtn(Icons.volume_up),
//           SizedBox(width: 6 * _s),
//           _roundActionBtn(Icons.help_outline),
//         ],
//       ),
//     );
//   }
//
//   Widget _statBox(String title, String value) {
//     return Container(
//       width: 52 * _s,
//       decoration: BoxDecoration(
//         color: const Color(0xFF3A1A0A),
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: _gold, width: 1.5),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(title,
//               style: TextStyle(
//                   color: const Color(0xFFFFE0A3),
//                   fontSize: 8.5 * _s,
//                   fontWeight: FontWeight.w900)),
//           SizedBox(height: 1 * _s),
//           Text(value,
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 11.5 * _s,
//                   fontWeight: FontWeight.w900)),
//         ],
//       ),
//     );
//   }
//
//   Widget _coinsPill() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10 * _s),
//       decoration: BoxDecoration(
//         color: const Color(0xFF2A1206),
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(color: const Color(0xFF9E6325), width: 1.5),
//       ),
//       child: Row(
//         children: [
//           Text("COINS",
//               style: TextStyle(
//                   color: _brightGold,
//                   fontSize: 9.5 * _s,
//                   fontWeight: FontWeight.w900)),
//           SizedBox(width: 5 * _s),
//           Container(
//             width: 17 * _s,
//             height: 17 * _s,
//             decoration: BoxDecoration(
//               color: const Color(0xFF2EB85C),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 1.2),
//             ),
//             child: Icon(Icons.add, color: Colors.white, size: 12 * _s),
//           ),
//           SizedBox(width: 8 * _s),
//           Text("10360.00",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14 * _s,
//                   fontWeight: FontWeight.w900)),
//         ],
//       ),
//     );
//   }
//
//   Widget _gameIdPill() {
//     return Container(
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(horizontal: 10 * _s),
//       height: 24 * _s,
//       decoration: BoxDecoration(
//         color: const Color(0xFF0B2C4A),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFF29A3E0), width: 1.5),
//       ),
//       child: Text(
//         "GAME ID: #20260920004",
//         style: TextStyle(
//             color: Colors.white,
//             fontSize: 9.5 * _s,
//             fontWeight: FontWeight.w800),
//       ),
//     );
//   }
//
//   Widget _titleBanner() {
//     return Container(
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Color(0xFF5A2A0E), Color(0xFF3A1A08)],
//         ),
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: _gold, width: 2),
//       ),
//       child: FittedBox(
//         fit: BoxFit.scaleDown,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.workspace_premium, color: _brightGold, size: 16 * _s),
//             SizedBox(width: 8 * _s),
//             Text(
//               "HORSE RACING",
//               style: TextStyle(
//                 color: const Color(0xFFFFE0A3),
//                 fontFamily: 'serif',
//                 fontWeight: FontWeight.w900,
//                 letterSpacing: 3,
//                 fontSize: 17 * _s,
//                 shadows: const [
//                   Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 3),
//                 ],
//               ),
//             ),
//             SizedBox(width: 8 * _s),
//             Icon(Icons.workspace_premium, color: _brightGold, size: 16 * _s),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _roundActionBtn(IconData icon) {
//     return Container(
//       width: 34 * _s,
//       height: 34 * _s,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: const Color(0xFF3A1A0A),
//         border: Border.all(color: _gold, width: 1.8),
//       ),
//       child: Icon(icon, color: const Color(0xFFFFE0A3), size: 17 * _s),
//     );
//   }
//
//   // =====================================================================
//   //                   PLAY AREA (scenic bg + grid + results)
//   // =====================================================================
//   Widget _buildPlayArea() {
//     return Container(padding: EdgeInsets.symmetric(horizontal: 65),
//       decoration: BoxDecoration(
//
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Scenic background
//           // Image.asset(
//           //   _bgImage,
//           //   fit: BoxFit.cover,
//           //   errorBuilder: (_, __, ___) => Container(
//           //     decoration: const BoxDecoration(
//           //       gradient: LinearGradient(
//           //         begin: Alignment.topCenter,
//           //         end: Alignment.bottomCenter,
//           //         colors: [
//           //           Color(0xFF8FB4C9),
//           //           Color(0xFF6E8A5A),
//           //           Color(0xFF3F6B2A),
//           //           Color(0xFF5B8A3A),
//           //         ],
//           //         stops: [0.0, 0.35, 0.65, 1.0],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           Padding(
//             padding: EdgeInsets.all(5 * _s),
//             child: Row(
//               children: [
//                 Expanded(child: _buildHorsesGrid()),
//                 SizedBox(width: 8 * _s),
//                 _buildResultsSidebar(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // =====================================================================
//   //                          HORSES GRID 6 x 2
//   // =====================================================================
//   Widget _buildHorsesGrid() {
//     return LayoutBuilder(builder: (context, c) {
//       const int cols = 6;
//       const int rows = 2;
//       final double gap = 6 * _s;
//       final double cellW = (c.maxWidth - gap * (cols - 1)) / cols;
//       final double cellH = (c.maxHeight - gap * (rows - 1)) / rows;
//
//       return GridView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.zero,
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: cols,
//           crossAxisSpacing: gap,
//           mainAxisSpacing: gap,
//           childAspectRatio: cellW / cellH,
//         ),
//         itemCount: horses.length,
//         itemBuilder: (context, index) => _buildHorseCard(horses[index]),
//       );
//     });
//   }
//
//   Widget _buildHorseCard(Map<String, dynamic> item) {
//     final bool active = (item['bet'] as int) > 0;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF0C0703),
//         borderRadius: BorderRadius.circular(6),
//         border: Border.all(
//           color: active ? const Color(0xFFFFD21F) : _cream,
//           width: active ? 2.5 : 2,
//         ),
//         boxShadow: active
//             ? const [
//           BoxShadow(color: Color(0xAAFFC000), blurRadius: 8, spreadRadius: 1)
//         ]
//             : const [
//           BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(1, 2))
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(3),
//         child: Column(
//           children: [
//             // Name plate
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 3 * _s),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Color(0xFFF3E9D8), Color(0xFFD9C9AE)],
//                 ),
//               ),
//               child: Text(
//                 item['name'],
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: const Color(0xFF2A1A10),
//                   fontWeight: FontWeight.w900,
//                   fontSize: 11 * _s,
//                   letterSpacing: 0.6,
//                 ),
//               ),
//             ),
//             // Horse picture (number image me already hai)
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 color: const Color(0xFF120A06),
//                 child: Image.asset(
//                   item['img'],
//                   fit: BoxFit.contain,
//                   errorBuilder: (context, error, stackTrace) => Center(
//                     child: Icon(Icons.pets, color: Colors.white24, size: 28 * _s),
//                   ),
//                 ),
//               ),
//             ),
//             // Bottom control
//             Container(
//               padding: EdgeInsets.all(3 * _s),
//               color: const Color(0xFF120A06),
//               child: active ? _betStepper(item) : _tapToBet(item),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _tapToBet(Map<String, dynamic> item) {
//     return InkWell(
//       onTap: () => setState(() => item['bet'] = selectedChip),
//       child: Container(
//         height: 24 * _s,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E1109),
//           border: Border.all(color: const Color(0xFFB88030), width: 1.3),
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.add_circle_outline,
//                   color: const Color(0xFFF0C77E), size: 10 * _s),
//               SizedBox(width: 3 * _s),
//               Text(
//                 "TAP TO BET",
//                 style: TextStyle(
//                   color: const Color(0xFFFFE2A8),
//                   fontSize: 10 * _s,
//                   fontWeight: FontWeight.w900,
//                   letterSpacing: 0.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _betStepper(Map<String, dynamic> item) {
//     return SizedBox(
//       height: 24 * _s,
//       child: Row(
//         children: [
//           // Minus
//           Expanded(
//             flex: 4,
//             child: InkWell(
//               onTap: () => setState(() {
//                 item['bet'] = ((item['bet'] as int) - selectedChip).clamp(0, 99999);
//               }),
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE02B2B),
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(color: const Color(0xFFFFB3B3), width: 1),
//                 ),
//                 child: Icon(Icons.remove, color: Colors.white, size: 15 * _s),
//               ),
//             ),
//           ),
//           SizedBox(width: 3 * _s),
//           // Value
//           Expanded(
//             flex: 5,
//             child: Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1C1610),
//                 borderRadius: BorderRadius.circular(4),
//                 border: Border.all(color: const Color(0xFF6E5B45), width: 1),
//               ),
//               child: FittedBox(
//                 fit: BoxFit.scaleDown,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 11 * _s,
//                       height: 11 * _s,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1E5FD1),
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 1.5),
//                       ),
//                     ),
//                     SizedBox(width: 3 * _s),
//                     Text(
//                       "${item['bet']}",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10.5 * _s,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 3 * _s),
//           // Plus
//           Expanded(
//             flex: 4,
//             child: InkWell(
//               onTap: () => setState(() {
//                 item['bet'] = (item['bet'] as int) + selectedChip;
//               }),
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF2FB344),
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(color: const Color(0xFFB6F2C0), width: 1),
//                 ),
//                 child: Icon(Icons.add, color: Colors.white, size: 15 * _s),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // =====================================================================
//   //                        PREVIOUS RESULTS PANEL
//   // =====================================================================
//   Widget _buildResultsSidebar() {
//     return Container(
//       width: 150 * _s,
//       decoration: BoxDecoration(
//         color: const Color(0xEE2A1208),
//         border: Border.all(color: const Color(0xFF9E6325), width: 2),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 6 * _s),
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Color(0xFF3A1A0A),
//               border: Border(bottom: BorderSide(color: Color(0xFF9E6325))),
//               borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
//             ),
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               child: Text(
//                 "PREVIOUS GAME RESULTS",
//                 style: TextStyle(
//                   color: _brightGold,
//                   fontSize: 9.5 * _s,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.separated(
//               physics: const NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.symmetric(horizontal: 5 * _s, vertical: 3 * _s),
//               itemCount: _results.length,
//               separatorBuilder: (_, __) =>
//               const Divider(height: 1, thickness: 1, color: Color(0xFF5A2D12)),
//               itemBuilder: (context, index) {
//                 final r = _results[index];
//                 return Padding(
//                   padding: EdgeInsets.symmetric(vertical: 5 * _s),
//                   child: Row(
//                     children: [
//                       Container(
//                         constraints: BoxConstraints(minWidth: 20 * _s),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 4 * _s, vertical: 3 * _s),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF3A1A0A),
//                           border: Border.all(color: const Color(0xFFD9B58A)),
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Text(
//                           "${r['id']}",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10 * _s,
//                               fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                       SizedBox(width: 5 * _s),
//                       Icon(Icons.pets, color: _brightGold, size: 12 * _s),
//                       SizedBox(width: 5 * _s),
//                       Expanded(
//                         child: Text(
//                           r['name'],
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10.5 * _s,
//                               fontWeight: FontWeight.w900),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 4 * _s, vertical: 2 * _s),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE04A1F),
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Text("3X",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 9.5 * _s,
//                                 fontWeight: FontWeight.w900)),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // =====================================================================
//   //                               FOOTER
//   // =====================================================================
//   Widget _buildBottomFooter() {
//     final double footerH = 60 * _s;
//     final double chipSize = footerH * 0.78;
//
//     return Container(
//       height: footerH,
//       padding: EdgeInsets.symmetric(horizontal: 6 * _s, vertical: 3 * _s),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: Color(0xFF8A5220), width: 1.5)),
//       ),
//       child: Row(
//         children: [
//           // Chips
//           Expanded(
//             child: FittedBox(
//               fit: BoxFit.scaleDown,
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 children: _chipList.map((chip) {
//                   final int val = chip['val'] as int;
//                   final bool selected = selectedChip == val;
//                   return Padding(
//                     padding: EdgeInsets.only(right: 12 * _s),
//                     child: GestureDetector(
//                       onTap: () => setState(() => selectedChip = val),
//                       child: AnimatedScale(
//                         scale: selected ? 1.18 : 1.0,
//                         duration: const Duration(milliseconds: 150),
//                         child: Container(
//                           width: chipSize,
//                           height: chipSize,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             boxShadow: selected
//                                 ? const [
//                               BoxShadow(
//                                   color: Color(0xFFFFD700),
//                                   blurRadius: 12,
//                                   spreadRadius: 2)
//                             ]
//                                 : const [
//                               BoxShadow(
//                                   color: Colors.black54,
//                                   blurRadius: 3,
//                                   offset: Offset(0, 2))
//                             ],
//                           ),
//                           child: ClipOval(
//                             child: Image.asset(
//                               chip['img'] as String,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) =>
//                                   _chipFallback(val, chip['color'] as Color),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           SizedBox(width: 6 * _s),
//           _actionPlateButton(
//             label: "Clear",
//             onTap: () => setState(() {
//               for (var h in horses) {
//                 h['bet'] = 0;
//               }
//             }),
//           ),
//           SizedBox(width: 8 * _s),
//           _actionPlateButton(
//             label: "Double",
//             onTap: () => setState(() {
//               for (var h in horses) {
//                 h['bet'] = (h['bet'] as int) * 2;
//               }
//             }),
//           ),
//           SizedBox(width: 10 * _s),
//           _timerBox(),
//         ],
//       ),
//     );
//   }
//
//   Widget _chipFallback(int val, Color color) {
//     return Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//         border: Border.all(color: Colors.white, width: 3),
//       ),
//       alignment: Alignment.center,
//       child: Container(
//         margin: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color,
//           border: Border.all(color: _gold, width: 1.5),
//         ),
//         alignment: Alignment.center,
//         child: FittedBox(
//           child: Padding(
//             padding: const EdgeInsets.all(4),
//             child: Text(
//               "$val",
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.w900),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _actionPlateButton({required String label, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         height: 42 * _s,
//         padding: EdgeInsets.symmetric(horizontal: 22 * _s),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: const Color(0xFF2E1408),
//           border: Border.all(color: _brightGold, width: 2),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: const Color(0xFFFFE9B8),
//             fontSize: 14 * _s,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _timerBox() {
//     return Container(
//       height: 46 * _s,
//       padding: EdgeInsets.symmetric(horizontal: 12 * _s),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(color: _brightGold, width: 2.5),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             secondsLeft < 10 ? "0$secondsLeft" : "$secondsLeft",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28 * _s,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           SizedBox(width: 5 * _s),
//           Text(
//             "SEC\nLEFT",
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 8.5 * _s,
//               height: 1.1,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_game_screen.dart';

class HorseRacingScreen extends StatefulWidget {
  const HorseRacingScreen({super.key});

  @override
  State<HorseRacingScreen> createState() => _HorseRacingScreenState();
}

class _HorseRacingScreenState extends State<HorseRacingScreen> {
  static const Color _gold = Color(0xFFF1AC48);
  static const Color _brightGold = Color(0xFFFFC533);
  static const Color _cream = Color(0xFFFFF6DF);

  static const List<String> _jockeyImages = [
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

  final List<Map<String, dynamic>> _chipList = const [
    {'val': 2, 'img': 'assets/bet_coins/betcoin2.png', 'color': Color(0xFF1976D2)},
    {'val': 5, 'img': 'assets/bet_coins/betcoin5.png', 'color': Color(0xFFD32F2F)},
    {'val': 10, 'img': 'assets/bet_coins/betcoin10.png', 'color': Color(0xFFF57C00)},
    {'val': 100, 'img': 'assets/bet_coins/betcoin100.png', 'color': Color(0xFF388E3C)},
    {'val': 500, 'img': 'assets/bet_coins/betcoin500.png', 'color': Color(0xFF7B1FA2)},
    {'val': 1000, 'img': 'assets/bet_coins/betcoin1000.png', 'color': Color(0xFFFFB300)},
  ];

  int selectedChip = 1000;
  int secondsLeft = 33;
  Timer? _timer;
  double _s = 1.0;

  late List<Map<String, dynamic>> horses;

  final List<Map<String, dynamic>> _results = const [
    {'id': 2, 'name': 'RANGEELA', 'img': 'assets/Bet_horses/horses2.png'},
    {'id': 7, 'name': 'LUCKY', 'img': 'assets/Bet_horses/horses7.png'},
    {'id': 4, 'name': 'ROYAL', 'img': 'assets/Bet_horses/horses4.png.png'},
    {'id': 7, 'name': 'LUCKY', 'img': 'assets/Bet_horses/horses7.png'},
    {'id': 12, 'name': 'VICTOR', 'img': 'assets/Bet_horses/horses12.png'},
    {'id': 6, 'name': 'CHETAK', 'img': 'assets/Bet_horses/horses6.png'},
    {'id': 4, 'name': 'ROYAL', 'img': 'assets/Bet_horses/horses4.png.png'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    horses = [
      {'id': 1, 'name': 'TOOFAN', 'bet': 0, 'img': _jockeyImages[0]},
      {'id': 2, 'name': 'RANGEELA', 'bet': 0, 'img': _jockeyImages[1]},
      {'id': 3, 'name': 'ARJUN', 'bet': 0, 'img': _jockeyImages[2]},
      {'id': 4, 'name': 'ROYAL', 'bet': 0, 'img': _jockeyImages[3]},
      {'id': 5, 'name': 'TARZAN', 'bet': 0, 'img': _jockeyImages[4]},
      {'id': 6, 'name': 'CHETAK', 'bet': 0, 'img': _jockeyImages[5]},
      {'id': 7, 'name': 'LUCKY', 'bet': 0, 'img': _jockeyImages[6]},
      {'id': 8, 'name': 'BAAZIGAR', 'bet': 0, 'img': _jockeyImages[7]},
      {'id': 9, 'name': 'JEET', 'bet': 0, 'img': _jockeyImages[8]},
      {'id': 10, 'name': 'TIGER', 'bet': 0, 'img': _jockeyImages[9]},
      {'id': 11, 'name': 'BADAL', 'bet': 0, 'img': _jockeyImages[10]},
      {'id': 12, 'name': 'VICTOR', 'bet': 0, 'img': _jockeyImages[11]},
    ];

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (secondsLeft > 0) {
          setState(() => secondsLeft--);
        } else {
          _timer?.cancel();
          _goToRaceScreen();
        }
      }
    });
  }

  void _goToRaceScreen() async {
    final placedBets = <int, int>{
      for (final h in horses)
        if ((h['bet'] as int) > 0) (h['id'] as int): (h['bet'] as int),
    };

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(placedBets: placedBets),
      ),
    );

    // Race khatam hone par wapas aane ke baad bets reset aur timer restart
    if (mounted) {
      setState(() {
        for (var h in horses) {
          h['bet'] = 0;
        }
        secondsLeft = 33;
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  double get totalPlay =>
      horses.fold(0.0, (sum, item) => sum + (item['bet'] as int));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _s = (size.height / 380 < size.width / 820
        ? size.height / 380
        : size.width / 820)
        .clamp(0.65, 1.6);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sprites/image.png'),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.only(
          left: 70 * _s,
          right: 70 * _s,
          top: 14 * _s,
          bottom: 14 * _s,
        ),
        child: Column(
          children: [
            _buildTopHeader(),
            SizedBox(height: 8 * _s),
            Expanded(child: _buildPlayArea()),
            SizedBox(height: 8 * _s),
            _buildBottomFooter(),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  //                              TOP HEADER
  // =====================================================================
  Widget _buildTopHeader() {
    return SizedBox(
      height: 38 * _s,
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _topStatPill("PLAY", totalPlay.toStringAsFixed(2), width: 56 * _s),
              SizedBox(width: 5 * _s),
              _topStatPill("WIN", "0.00", width: 56 * _s),
              SizedBox(width: 5 * _s),
              _pointsPill("992.00"),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _circleActionBtn(Icons.history),
              SizedBox(width: 6 * _s),
              _circleActionBtn(Icons.settings),
              SizedBox(width: 6 * _s),
              _circleActionBtn(Icons.info_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topStatPill(String title, String val, {required double width}) {
    return Container(
      width: width,
      height: 32 * _s,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(4 * _s),
        border: Border.all(color: const Color(0xFFE2B770), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFFE2B770),
              fontSize: 7.5 * _s,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10 * _s,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointsPill(String val) {
    return Container(
      height: 32 * _s,
      padding: EdgeInsets.symmetric(horizontal: 8 * _s),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(5 * _s),
        border: Border.all(color: const Color(0xFFE2B770), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "POINTS",
                    style: TextStyle(
                      color: const Color(0xFFE2B770),
                      fontSize: 7.5 * _s,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 3 * _s),
                  Container(
                    width: 10 * _s,
                    height: 10 * _s,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C853),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 8 * _s),
                  ),
                ],
              ),
              Text(
                val,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10 * _s,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleActionBtn(IconData icon) {
    return Container(
      width: 28 * _s,
      height: 28 * _s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.75),
        border: Border.all(color: const Color(0xFFE2B770), width: 1.5),
      ),
      child: Icon(icon, color: const Color(0xFFE2B770), size: 16 * _s),
    );
  }

  // =====================================================================
  //                            PLAY AREA
  // =====================================================================
  Widget _buildPlayArea() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 10,
          child: _buildHorsesGrid(),
        ),
        SizedBox(width: 8 * _s),
        Expanded(
          flex: 3,
          child: _buildResultsSidebar(),
        ),
      ],
    );
  }

  Widget _buildHorsesGrid() {
    return LayoutBuilder(builder: (context, c) {
      const int cols = 6;
      const int rows = 2;
      final double gap = 4 * _s;
      final double cellW = (c.maxWidth - (gap * (cols - 1))) / cols;
      final double cellH = (c.maxHeight - (gap * (rows - 1))) / rows;

      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          childAspectRatio: cellW / cellH,
        ),
        itemCount: horses.length,
        itemBuilder: (context, index) => _buildHorseCard(horses[index]),
      );
    });
  }

  Widget _buildHorseCard(Map<String, dynamic> item) {
    final bool active = (item['bet'] as int) > 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C160B),
        borderRadius: BorderRadius.circular(6 * _s),
        border: Border.all(
          color: active ? const Color(0xFFFFD21F) : const Color(0xFF744A29),
          width: active ? 2.5 : 1.5,
        ),
        boxShadow: active
            ? const [
          BoxShadow(
              color: Color(0xAAFFC000), blurRadius: 8, spreadRadius: 1)
        ]
            : const [
          BoxShadow(
              color: Colors.black87, blurRadius: 4, offset: Offset(1, 2))
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2 * _s),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(4.5 * _s)),
            ),
            child: Text(
              item['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF221105),
                fontWeight: FontWeight.w900,
                fontSize: 10 * _s,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF241208),
              padding: EdgeInsets.all(2 * _s),
              child: Image.asset(
                item['img'],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.pets,
                  color: Colors.white24,
                  size: 24 * _s,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.5 * _s),
            color: const Color(0xFF241208),
            child: InkWell(
              onTap: () {
                setState(() {
                  item['bet'] = (item['bet'] as int) + selectedChip;
                });
              },
              child: Container(
                height: 18 * _s,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF9E2A00)
                      : const Color(0xFF1E0E06),
                  borderRadius: BorderRadius.circular(3 * _s),
                  border: Border.all(
                    color: active ? Colors.amber : const Color(0xFF4A2711),
                    width: 1,
                  ),
                ),
                child: Text(
                  active ? "${item['bet']}" : "TAP TO BET",
                  style: TextStyle(
                    color: active ? Colors.white : const Color(0xFFECC28A),
                    fontSize: 8.5 * _s,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  //                      PREVIOUS RESULTS PANEL
  // =====================================================================
  Widget _buildResultsSidebar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xDD2A140B),
        borderRadius: BorderRadius.circular(6 * _s),
        border: Border.all(color: const Color(0xFF6B4226), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4 * _s),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF3B1E10),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(4.5 * _s)),
            ),
            child: Text(
              "PREVIOUS GAME\nRESULTS",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _cream,
                fontSize: 8.5 * _s,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding:
              EdgeInsets.symmetric(horizontal: 6 * _s, vertical: 3 * _s),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final r = _results[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.2 * _s),
                  child: Row(
                    children: [
                      Container(
                        width: 20 * _s,
                        height: 20 * _s,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFB300),
                        ),
                        child: Text(
                          "${r['id']}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11 * _s,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(width: 6 * _s),
                      Container(
                        width: 24 * _s,
                        height: 24 * _s,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white70, width: 1.0),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            r['img'],
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                                Icons.person,
                                size: 14 * _s,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 6 * _s),
                      Expanded(
                        child: Text(
                          r['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.5 * _s,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6 * _s, vertical: 2 * _s),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7298),
                          borderRadius: BorderRadius.circular(3 * _s),
                        ),
                        child: Text(
                          "N",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10 * _s,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  //                              FOOTER
  // =====================================================================
  Widget _buildBottomFooter() {
    final double chipSize = 42 * _s;

    return SizedBox(
      height: 48 * _s,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: _chipList.map((chip) {
                final int val = chip['val'] as int;
                final bool selected = selectedChip == val;
                return Padding(
                  padding: EdgeInsets.only(right: 8 * _s),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedChip = val),
                    child: Container(
                      width: chipSize,
                      height: chipSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: selected
                            ? const [
                          BoxShadow(
                            color: Color(0xFFFFD700),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]
                            : null,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          chip['img'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _chipFallback(val, chip['color'] as Color),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _actionPillButton(
            label: "Clear",
            onTap: () {
              setState(() {
                for (var h in horses) {
                  h['bet'] = 0;
                }
              });
            },
          ),
          SizedBox(width: 8 * _s),
          _actionPillButton(
            label: "Double",
            onTap: () {
              setState(() {
                for (var h in horses) {
                  h['bet'] = (h['bet'] as int) * 2;
                }
              });
            },
          ),
          SizedBox(width: 12 * _s),
          _timerBox(),
        ],
      ),
    );
  }

  Widget _chipFallback(int val, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        "$val",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _actionPillButton(
      {required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32 * _s,
        padding: EdgeInsets.symmetric(horizontal: 18 * _s),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3B3F).withOpacity(0.85),
          borderRadius: BorderRadius.circular(16 * _s),
          border: Border.all(color: const Color(0xFF6E6D74), width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: const Color(0xFFECEBF0),
            fontSize: 12 * _s,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _timerBox() {
    return Container(
      height: 36 * _s,
      padding: EdgeInsets.symmetric(horizontal: 12 * _s),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(6 * _s),
        border: Border.all(color: const Color(0xFFFFB300), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            secondsLeft < 10 ? "0$secondsLeft" : "$secondsLeft",
            style: TextStyle(
              color: const Color(0xFFFFB300),
              fontSize: 22 * _s,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 4 * _s),
          Text(
            "SEC\nLEFT",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 7.5 * _s,
              height: 1.1,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}