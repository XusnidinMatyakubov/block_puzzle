import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/piece_drag_data.dart';
import '../models/piece_model.dart';

class PiecePreview extends StatelessWidget {
  const PiecePreview({
    required this.piece,
    this.index,
    this.enabled = true,
    super.key,
  });

  final PieceModel piece;
  final int? index;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final preview = _PiecePreviewSurface(piece: piece);
    final pieceIndex = index;

    if (!enabled || pieceIndex == null) {
      return preview;
    }

    return Draggable<PieceDragData>(
      data: PieceDragData(index: pieceIndex),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.08,
          child: SizedBox.square(
            dimension: 104,
            child: _PiecePreviewSurface(
              piece: piece,
              elevated: true,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.32,
        child: preview,
      ),
      child: preview,
    );
  }
}

class _PiecePreviewSurface extends StatelessWidget {
  const _PiecePreviewSurface({
    required this.piece,
    this.elevated = false,
  });

  final PieceModel piece;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedScale(
      scale: elevated ? 1.0 : 0.98,
      duration: const Duration(milliseconds: 140),
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: elevated ? colorScheme.surface : colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: elevated
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: CustomPaint(
              painter: _PiecePreviewPainter(piece: piece),
            ),
          ),
        ),
      ),
    );
  }
}

class _PiecePreviewPainter extends CustomPainter {
  const _PiecePreviewPainter({
    required this.piece,
  });

  final PieceModel piece;

  @override
  void paint(Canvas canvas, Size size) {
    if (piece.cells.isEmpty) {
      return;
    }

    final paint = Paint()..color = Color(piece.colorValue);
    final maxRow = piece.cells.map((cell) => cell.row).reduce(math.max);
    final maxColumn = piece.cells.map((cell) => cell.column).reduce(math.max);
    final rows = maxRow + 1;
    final columns = maxColumn + 1;
    final cellSize = size.shortestSide / 4;
    final totalWidth = columns * cellSize;
    final totalHeight = rows * cellSize;
    final left = (size.width - totalWidth) / 2;
    final top = (size.height - totalHeight) / 2;

    for (final cell in piece.cells) {
      final rect = Rect.fromLTWH(
        left + cell.column * cellSize,
        top + cell.row * cellSize,
        cellSize - 4,
        cellSize - 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(5)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PiecePreviewPainter oldDelegate) {
    return oldDelegate.piece != piece;
  }
}
