import 'package:flutter/material.dart';

import 'game_status.dart';
import 'game_view-model.dart';

class GameHUD extends StatelessWidget {
  final GameViewModel viewModel;

  const GameHUD({
    super.key,
    required this.viewModel,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = viewModel.status == GameStatus.running;
    final isCompleted = viewModel.status == GameStatus.completed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TIMER BADGE
          _buildGlassContainer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.cyanAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(viewModel.remainingDuration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                if (GameViewModel.testMode) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orangeAccent, width: 0.8),
                    ),
                    child: const Text(
                      'TEST 60s',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // PROGRESS BADGE & BAR
          _buildGlassContainer(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'PROGRESS: ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(viewModel.progress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: viewModel.progress,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                      minHeight: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ACTION BUTTONS
          Row(
            children: [
              _buildGlassButton(
                onTap: isCompleted
                    ? null
                    : () {
                  if (isRunning) {
                    viewModel.pause();
                  } else {
                    viewModel.startOrResume();
                  }
                },
                icon: isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                label: isRunning ? 'PAUSE' : (viewModel.status == GameStatus.paused ? 'RESUME' : 'START'),
                accentColor: isRunning ? Colors.amberAccent : Colors.greenAccent,
                disabled: isCompleted,
              ),
              const SizedBox(width: 10),
              _buildGlassButton(
                onTap: () => viewModel.reset(),
                icon: Icons.refresh_rounded,
                label: 'RESET',
                accentColor: Colors.redAccent,
                disabled: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: child,
    );
  }

  Widget _buildGlassButton({
    required VoidCallback? onTap,
    required IconData icon,
    required String label,
    required Color accentColor,
    required bool disabled,
  }) {
    final effectiveColor = disabled ? Colors.white24 : accentColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: effectiveColor.withOpacity(disabled ? 0.2 : 0.6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: effectiveColor, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: effectiveColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}