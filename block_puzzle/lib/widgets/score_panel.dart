import 'package:flutter/material.dart';

import '../utils/helpers.dart';

class ScorePanel extends StatelessWidget {
  const ScorePanel({
    required this.score,
    required this.bestScore,
    required this.combo,
    super.key,
  });

  final int score;
  final int bestScore;
  final int combo;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: _cardWidth(context),
          child: _ScoreCard(
            label: 'Score',
            value: AppHelpers.formatScore(score),
            icon: Icons.star_rounded,
          ),
        ),
        SizedBox(
          width: _cardWidth(context),
          child: _ScoreCard(
            label: 'Best',
            value: AppHelpers.formatScore(bestScore),
            icon: Icons.emoji_events_rounded,
          ),
        ),
        if (combo > 0)
          SizedBox(
            width: _cardWidth(context),
            child: _ScoreCard(
              label: 'Combo',
              value: 'x$combo',
              icon: Icons.bolt_rounded,
            ),
          ),
      ],
    );
  }

  double _cardWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width - 44) / 2;
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
