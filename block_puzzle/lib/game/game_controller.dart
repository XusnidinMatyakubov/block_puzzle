import '../models/game_state_model.dart';
import '../models/position_model.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import 'board_manager.dart';
import 'piece_generator.dart';

typedef GameListener = void Function();

class GameController {
  GameController({
    required StorageService storageService,
    SoundService soundService = const SoundService(),
    BoardManager boardManager = const BoardManager(),
    PieceGenerator? pieceGenerator,
  })  : _storageService = storageService,
        _soundService = soundService,
        _boardManager = boardManager,
        _pieceGenerator = pieceGenerator ?? PieceGenerator() {
    _state = _createInitialState();
  }

  final StorageService _storageService;
  final SoundService _soundService;
  final BoardManager _boardManager;
  final PieceGenerator _pieceGenerator;

  late GameStateModel _state;
  final List<GameListener> _listeners = [];

  GameStateModel get state => _state;

  void addListener(GameListener listener) {
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
  }

  void removeListener(GameListener listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
  }

  void startNewGame() {
    _state = _createInitialState().copyWith(status: GameStatus.playing);
    _notifyListeners();
  }

  void pauseGame() {
    if (_state.status != GameStatus.playing) {
      return;
    }
    _state = _state.copyWith(status: GameStatus.paused);
    _notifyListeners();
  }

  void resumeGame() {
    if (_state.status != GameStatus.paused) {
      return;
    }
    _state = _state.copyWith(status: GameStatus.playing);
    _notifyListeners();
  }

  void clearTransientEffects() {
    if (_state.lastClearedCells.isEmpty && _state.lastPlacedCells.isEmpty) {
      return;
    }
    _state = _state.copyWith(
      lastClearedCells: const [],
      lastPlacedCells: const [],
    );
    _notifyListeners();
  }

  Future<void> endGame() async {
    final bestScore = await _saveBestScore(_state.score);
    _soundService.playGameOverSound(
      enabled: _storageService.getSoundEnabled(),
    );
    _state = _state.copyWith(
      bestScore: bestScore,
      status: GameStatus.gameOver,
    );
    _notifyListeners();
  }

  bool canPlacePiece(int pieceIndex, PositionModel boardPosition) {
    if (pieceIndex < 0 || pieceIndex >= _state.availablePieces.length) {
      return false;
    }
    return _boardManager.canPlacePiece(
      _state.board,
      _state.availablePieces[pieceIndex],
      boardPosition,
    );
  }

  Future<bool> placeSelectedPiece(
    int pieceIndex,
    PositionModel boardPosition,
  ) async {
    if (_state.status != GameStatus.playing ||
        !canPlacePiece(pieceIndex, boardPosition)) {
      return false;
    }

    final piece = _state.availablePieces[pieceIndex];
    final placedCells = _boardManager.targetCellsFor(piece, boardPosition);
    final placedBoard = _boardManager.placePiece(
      _state.board,
      piece,
      boardPosition,
    );
    final clearResult = _boardManager.clearCompletedLines(placedBoard);
    final remainingPieces = [..._state.availablePieces]..removeAt(pieceIndex);
    final nextPieces = remainingPieces.isEmpty
        ? _pieceGenerator.generatePieces()
        : remainingPieces;
    final placementScore = piece.cells.length;
    final clearScore = _scoreForClear(clearResult.clearedLineCount);
    final nextCombo = clearResult.hasClearedLines ? _state.combo + 1 : 0;
    final totalScore = _state.score + placementScore + clearScore;
    final bestScore =
        totalScore > _state.bestScore ? totalScore : _state.bestScore;
    final hasMoves =
        _boardManager.hasAnyValidMove(clearResult.board, nextPieces);
    final nextStatus = hasMoves ? GameStatus.playing : GameStatus.gameOver;

    if (clearResult.hasClearedLines) {
      _soundService.playClearSound(enabled: _storageService.getSoundEnabled());
    } else {
      _soundService.playPlaceSound(enabled: _storageService.getSoundEnabled());
    }

    _state = _state.copyWith(
      board: clearResult.board,
      availablePieces: nextPieces,
      score: totalScore,
      bestScore: bestScore,
      combo: nextCombo,
      lastPlacedCells: placedCells,
      lastClearedCells: clearResult.clearedCells,
      moveCount: _state.moveCount + 1,
      status: nextStatus,
    );

    await _saveBestScore(bestScore);

    if (nextStatus == GameStatus.gameOver) {
      _soundService.playGameOverSound(
        enabled: _storageService.getSoundEnabled(),
      );
    }

    _notifyListeners();
    return true;
  }

  List<PositionModel> previewCellsFor(int pieceIndex, PositionModel origin) {
    if (pieceIndex < 0 || pieceIndex >= _state.availablePieces.length) {
      return const [];
    }
    return _boardManager.targetCellsFor(
      _state.availablePieces[pieceIndex],
      origin,
    );
  }

  int _scoreForClear(int clearedLineCount) {
    if (clearedLineCount == 0) {
      return 0;
    }
    final lineScore = clearedLineCount * AppConstants.lineClearScore;
    final comboScore = (clearedLineCount - 1) * AppConstants.comboBonusScore;
    return lineScore + comboScore;
  }

  Future<int> _saveBestScore(int score) async {
    await _storageService.saveBestScore(score);
    return _storageService.getBestScore();
  }

  void _notifyListeners() {
    for (final listener in List<GameListener>.of(_listeners)) {
      listener();
    }
  }

  GameStateModel _createInitialState() {
    return GameStateModel(
      board: _boardManager.createEmptyBoard(),
      availablePieces: _pieceGenerator.generatePieces(),
      score: AppConstants.startingScore,
      bestScore: _storageService.getBestScore(),
      status: GameStatus.ready,
    );
  }
}
