import 'package:flutter/material.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({
    required this.isPaused,
    required this.onPause,
    required this.onResume,
    required this.onRestart,
    super.key,
  });

  final bool isPaused;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onRestart,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Restart'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: isPaused ? onResume : onPause,
            icon: Icon(
              isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            ),
            label: Text(isPaused ? 'Resume' : 'Pause'),
          ),
        ),
      ],
    );
  }
}
