import 'block_cell.dart';
import 'piece_model.dart';
import 'position_model.dart';

enum GameStatus {
  ready,
  playing,
  paused,
  gameOver,
}

class GameStateModel {
  const GameStateModel({
    required this.board,
    required this.availablePieces,
    required this.score,
    required this.bestScore,
    required this.status,
    this.combo = 0,
    this.lastClearedCells = const [],
    this.lastPlacedCells = const [],
    this.moveCount = 0,
  });

  final List<List<BlockCell>> board;
  final List<PieceModel> availablePieces;
  final int score;
  final int bestScore;
  final GameStatus status;
  final int combo;
  final List<PositionModel> lastClearedCells;
  final List<PositionModel> lastPlacedCells;
  final int moveCount;

  GameStateModel copyWith({
    List<List<BlockCell>>? board,
    List<PieceModel>? availablePieces,
    int? score,
    int? bestScore,
    GameStatus? status,
    int? combo,
    List<PositionModel>? lastClearedCells,
    List<PositionModel>? lastPlacedCells,
    int? moveCount,
  }) {
    return GameStateModel(
      board: board ?? this.board,
      availablePieces: availablePieces ?? this.availablePieces,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      status: status ?? this.status,
      combo: combo ?? this.combo,
      lastClearedCells: lastClearedCells ?? this.lastClearedCells,
      lastPlacedCells: lastPlacedCells ?? this.lastPlacedCells,
      moveCount: moveCount ?? this.moveCount,
    );
  }
}
