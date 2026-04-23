class AppConstants {
  const AppConstants._();

  static const int boardSize = 8;
  static const int startingScore = 0;
  static const int piecesPerTurn = 3;
  static const int lineClearScore = 100;
  static const int comboBonusScore = 50;

  static const double screenPadding = 16;
  static const double boardGap = 4;
  static const double cardRadius = 8;
  static const double boardRadius = 10;
  static const Duration splashDuration = Duration(milliseconds: 900);
  static const Duration placementAnimationDuration = Duration(milliseconds: 180);
  static const Duration clearAnimationDuration = Duration(milliseconds: 320);

  static const List<int> pieceColorValues = [
    0xFF2563EB,
    0xFF16A34A,
    0xFFE11D48,
    0xFFF59E0B,
    0xFF7C3AED,
    0xFF0891B2,
  ];
}
