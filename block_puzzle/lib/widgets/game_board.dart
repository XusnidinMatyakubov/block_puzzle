import 'package:flutter/material.dart';

import '../models/block_cell.dart';
import '../models/piece_drag_data.dart';
import '../models/position_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    required this.board,
    required this.moveCount,
    required this.lastClearedCells,
    required this.lastPlacedCells,
    required this.canPlacePiece,
    required this.previewCellsFor,
    required this.onPlacePiece,
    super.key,
  });

  final List<List<BlockCell>> board;
  final int moveCount;
  final List<PositionModel> lastClearedCells;
  final List<PositionModel> lastPlacedCells;
  final bool Function(int pieceIndex, PositionModel origin) canPlacePiece;
  final List<PositionModel> Function(int pieceIndex, PositionModel origin)
      previewCellsFor;
  final Future<bool> Function(int pieceIndex, PositionModel origin) onPlacePiece;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  final GlobalKey _boardKey = GlobalKey();
  List<PositionModel> _previewCells = const [];
  bool _isPreviewValid = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rows = widget.board.length;
    final columns = rows == 0 ? 0 : widget.board.first.length;

    return DragTarget<PieceDragData>(
      onWillAcceptWithDetails: _handleWillAccept,
      onMove: _handleMove,
      onLeave: (_) => _clearPreview(),
      onAcceptWithDetails: _handleAccept,
      builder: (context, candidateData, rejectedData) {
        return AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            key: _boardKey,
            duration: const Duration(milliseconds: 160),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppConstants.boardRadius),
              border: Border.all(
                color: _previewCells.isEmpty
                    ? colorScheme.outlineVariant
                    : _isPreviewValid
                        ? colorScheme.primary
                        : colorScheme.error,
                width: _previewCells.isEmpty ? 1 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.boardGap),
              child: columns == 0
                  ? const SizedBox.shrink()
                  : GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rows * columns,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: AppConstants.boardGap,
                        mainAxisSpacing: AppConstants.boardGap,
                      ),
                      itemBuilder: (context, index) {
                        final row = index ~/ columns;
                        final column = index % columns;
                        final position = PositionModel(
                          row: row,
                          column: column,
                        );
                        final cell = widget.board[row][column];

                        return _BoardCell(
                          cell: cell,
                          position: position,
                          isPreviewed: _previewCells.contains(position),
                          isPreviewValid: _isPreviewValid,
                          isCleared: widget.lastClearedCells.contains(position),
                          isPlaced: widget.lastPlacedCells.contains(position),
                          moveCount: widget.moveCount,
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  bool _handleWillAccept(DragTargetDetails<PieceDragData> details) {
    return _originFromGlobalOffset(details.offset) != null;
  }

  void _handleMove(DragTargetDetails<PieceDragData> details) {
    final origin = _originFromGlobalOffset(details.offset);
    if (origin == null) {
      _clearPreview();
      return;
    }
    final previewCells = widget.previewCellsFor(details.data.index, origin);
    final isValid = widget.canPlacePiece(details.data.index, origin);

    if (_isPreviewValid == isValid && _sameCells(_previewCells, previewCells)) {
      return;
    }

    setState(() {
      _previewCells = previewCells;
      _isPreviewValid = isValid;
    });
  }

  Future<void> _handleAccept(DragTargetDetails<PieceDragData> details) async {
    final origin = _originFromGlobalOffset(details.offset);
    _clearPreview();
    if (origin == null) {
      return;
    }
    await widget.onPlacePiece(details.data.index, origin);
  }

  PositionModel? _originFromGlobalOffset(Offset globalOffset) {
    final renderObject = _boardKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) {
      return null;
    }

    final localOffset = renderObject.globalToLocal(globalOffset);
    if (localOffset.dx < AppConstants.boardGap ||
        localOffset.dy < AppConstants.boardGap ||
        localOffset.dx >= renderObject.size.width - AppConstants.boardGap ||
        localOffset.dy >= renderObject.size.height - AppConstants.boardGap) {
      return null;
    }

    final boardPixels = renderObject.size.width - (AppConstants.boardGap * 2);
    final cellPixels = boardPixels / AppConstants.boardSize;
    final row = ((localOffset.dy - AppConstants.boardGap) / cellPixels).floor();
    final column =
        ((localOffset.dx - AppConstants.boardGap) / cellPixels).floor();

    return PositionModel(row: row, column: column);
  }

  void _clearPreview() {
    if (_previewCells.isEmpty) {
      return;
    }
    setState(() {
      _previewCells = const [];
      _isPreviewValid = false;
    });
  }

  bool _sameCells(List<PositionModel> first, List<PositionModel> second) {
    if (first.length != second.length) {
      return false;
    }
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) {
        return false;
      }
    }
    return true;
  }
}

class _BoardCell extends StatelessWidget {
  const _BoardCell({
    required this.cell,
    required this.position,
    required this.isPreviewed,
    required this.isPreviewValid,
    required this.isCleared,
    required this.isPlaced,
    required this.moveCount,
  });

  final BlockCell cell;
  final PositionModel position;
  final bool isPreviewed;
  final bool isPreviewValid;
  final bool isCleared;
  final bool isPlaced;
  final int moveCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = AppHelpers.cellColor(context, cell.colorValue);
    final previewColor = isPreviewValid
        ? colorScheme.primary.withOpacity(0.36)
        : colorScheme.error.withOpacity(0.30);
    final color = isPreviewed ? previewColor : baseColor;

    return TweenAnimationBuilder<double>(
      key: ValueKey('${position.row}_${position.column}_$moveCount'),
      tween: Tween<double>(begin: isCleared || isPlaced ? 0.75 : 1, end: 1),
      duration: isCleared
          ? AppConstants.clearAnimationDuration
          : AppConstants.placementAnimationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isCleared
              ? colorScheme.tertiaryContainer.withOpacity(0.8)
              : color,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: cell.isFilled
                ? Colors.white.withOpacity(0.45)
                : colorScheme.outlineVariant.withOpacity(0.35),
            width: 0.7,
          ),
        ),
      ),
    );
  }
}
