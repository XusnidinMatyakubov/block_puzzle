import 'package:flutter/material.dart';

import '../utils/helpers.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    required this.score,
    required this.bestScore,
    required this.onRestart,
    required this.onHome,
    super.key,
  });

  final int score;
  final int bestScore;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.flag_rounded),
      title: const Text('Game Over'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScoreLine(label: 'Score', value: AppHelpers.formatScore(score)),
          const SizedBox(height: 8),
          _ScoreLine(label: 'Best', value: AppHelpers.formatScore(bestScore)),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: onHome,
          icon: const Icon(Icons.home_rounded),
          label: const Text('Home'),
        ),
        FilledButton.icon(
          onPressed: onRestart,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Restart'),
        ),
      ],
    );
  }
}

class _ScoreLine extends StatelessWidget {
  const _ScoreLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
