import '../models/block_cell.dart';
import '../models/piece_model.dart';
import '../models/position_model.dart';
import '../utils/constants.dart';

class LineClearResult {
  const LineClearResult({
    required this.board,
    required this.clearedCells,
    required this.clearedLineCount,
  });

  final List<List<BlockCell>> board;
  final List<PositionModel> clearedCells;
  final int clearedLineCount;

  bool get hasClearedLines => clearedLineCount > 0;
}

class BoardManager {
  const BoardManager();

  List<List<BlockCell>> createEmptyBoard() {
    return List.generate(
      AppConstants.boardSize,
      (row) => List.generate(
        AppConstants.boardSize,
        (column) => BlockCell(
          position: PositionModel(row: row, column: column),
        ),
      ),
    );
  }

  bool canPlacePiece(
    List<List<BlockCell>> board,
    PieceModel piece,
    PositionModel origin,
  ) {
    if (piece.isEmpty || !_hasExpectedSize(board)) {
      return false;
    }

    for (final cell in piece.cells) {
      final row = origin.row + cell.row;
      final column = origin.column + cell.column;
      if (!_isInsideBoard(row, column)) {
        return false;
      }
      if (board[row][column].isFilled) {
        return false;
      }
    }

    return true;
  }

  List<List<BlockCell>> placePiece(
    List<List<BlockCell>> board,
    PieceModel piece,
    PositionModel origin,
  ) {
    final nextBoard = _copyBoard(board);

    for (final cell in piece.cells) {
      final row = origin.row + cell.row;
      final column = origin.column + cell.column;
      nextBoard[row][column] = nextBoard[row][column].copyWith(
        colorValue: piece.colorValue,
        isFilled: true,
      );
    }

    return nextBoard;
  }

  LineClearResult clearCompletedLines(List<List<BlockCell>> board) {
    if (!_hasExpectedSize(board)) {
      return LineClearResult(
        board: board,
        clearedCells: const [],
        clearedLineCount: 0,
      );
    }

    final rowsToClear = <int>{};
    final columnsToClear = <int>{};

    for (var row = 0; row < AppConstants.boardSize; row++) {
      if (board[row].every((cell) => cell.isFilled)) {
        rowsToClear.add(row);
      }
    }

    for (var column = 0; column < AppConstants.boardSize; column++) {
      var fullColumn = true;
      for (var row = 0; row < AppConstants.boardSize; row++) {
        if (!board[row][column].isFilled) {
          fullColumn = false;
          break;
        }
      }
      if (fullColumn) {
        columnsToClear.add(column);
      }
    }

    if (rowsToClear.isEmpty && columnsToClear.isEmpty) {
      return LineClearResult(
        board: board,
        clearedCells: const [],
        clearedLineCount: 0,
      );
    }

    final clearedCells = <PositionModel>{};
    final nextBoard = _copyBoard(board);

    for (final row in rowsToClear) {
      for (var column = 0; column < AppConstants.boardSize; column++) {
        clearedCells.add(PositionModel(row: row, column: column));
      }
    }

    for (final column in columnsToClear) {
      for (var row = 0; row < AppConstants.boardSize; row++) {
        clearedCells.add(PositionModel(row: row, column: column));
      }
    }

    for (final cell in clearedCells) {
      nextBoard[cell.row][cell.column] = nextBoard[cell.row][cell.column]
          .copyWith(clearColor: true, isFilled: false);
    }

    return LineClearResult(
      board: nextBoard,
      clearedCells: clearedCells.toList(growable: false),
      clearedLineCount: rowsToClear.length + columnsToClear.length,
    );
  }

  bool hasAnyValidMove(
    List<List<BlockCell>> board,
    List<PieceModel> pieces,
  ) {
    for (final piece in pieces) {
      if (findFirstValidPlacement(board, piece) != null) {
        return true;
      }
    }
    return false;
  }

  PositionModel? findFirstValidPlacement(
    List<List<BlockCell>> board,
    PieceModel piece,
  ) {
    for (var row = 0; row < AppConstants.boardSize; row++) {
      for (var column = 0; column < AppConstants.boardSize; column++) {
        final origin = PositionModel(row: row, column: column);
        if (canPlacePiece(board, piece, origin)) {
          return origin;
        }
      }
    }
    return null;
  }

  List<PositionModel> targetCellsFor(PieceModel piece, PositionModel origin) {
    return piece.cells
        .map(
          (cell) => PositionModel(
            row: origin.row + cell.row,
            column: origin.column + cell.column,
          ),
        )
        .toList(growable: false);
  }

  List<List<BlockCell>> _copyBoard(List<List<BlockCell>> board) {
    return [
      for (final row in board) [...row],
    ];
  }

  bool _isInsideBoard(int row, int column) {
    return row >= 0 &&
        row < AppConstants.boardSize &&
        column >= 0 &&
        column < AppConstants.boardSize;
  }

  bool _hasExpectedSize(List<List<BlockCell>> board) {
    return board.length == AppConstants.boardSize &&
        board.every((row) => row.length == AppConstants.boardSize);
  }
}
