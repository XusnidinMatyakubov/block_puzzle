import 'package:flutter/material.dart';

import '../game/game_controller.dart';
import '../models/game_state_model.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/control_bar.dart';
import '../widgets/game_board.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/piece_preview.dart';
import '../widgets/score_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    required this.storageService,
    super.key,
  });

  final StorageService storageService;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;
  bool _gameOverDialogShown = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController(storageService: widget.storageService)
      ..addListener(_handleStateChanged)
      ..startNewGame();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleStateChanged)
      ..dispose();
    super.dispose();
  }

  void _handleStateChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
    if (_controller.state.lastClearedCells.isNotEmpty ||
        _controller.state.lastPlacedCells.isNotEmpty) {
      Future<void>.delayed(AppConstants.clearAnimationDuration, () {
        if (mounted) {
          _controller.clearTransientEffects();
        }
      });
    }

    if (_controller.state.status != GameStatus.gameOver) {
      _gameOverDialogShown = false;
      return;
    }

    if (!_gameOverDialogShown) {
      _gameOverDialogShown = true;
      _showGameOverDialog();
    }
  }

  Future<void> _showGameOverDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => GameOverDialog(
        score: _controller.state.score,
        bestScore: _controller.state.bestScore,
        onRestart: () {
          Navigator.of(context).pop();
          _controller.startNewGame();
        },
        onHome: () {
          Navigator.of(context)
            ..pop()
            ..pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Block Puzzle'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Column(
            children: [
              ScorePanel(
                score: state.score,
                bestScore: state.bestScore,
                combo: state.combo,
              ),
              const SizedBox(height: 20),
              GameBoard(
                board: state.board,
                moveCount: state.moveCount,
                lastClearedCells: state.lastClearedCells,
                lastPlacedCells: state.lastPlacedCells,
                canPlacePiece: _controller.canPlacePiece,
                previewCellsFor: _controller.previewCellsFor,
                onPlacePiece: _controller.placeSelectedPiece,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  for (var index = 0;
                      index < state.availablePieces.length;
                      index++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: PiecePreview(
                          piece: state.availablePieces[index],
                          index: index,
                          enabled: state.status == GameStatus.playing,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              ControlBar(
                isPaused: state.status == GameStatus.paused,
                onPause: _controller.pauseGame,
                onResume: _controller.resumeGame,
                onRestart: _controller.startNewGame,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
