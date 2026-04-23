import 'package:flutter/material.dart';

class AppHelpers {
  const AppHelpers._();

  static Color cellColor(BuildContext context, int? colorValue) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorValue == null
        ? Color.alphaBlend(
            colorScheme.primary.withOpacity(0.05),
            colorScheme.surface,
          )
        : Color(colorValue);
  }

  static String formatScore(int score) {
    return score.toString();
  }
}
