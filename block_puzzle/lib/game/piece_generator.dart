import 'dart:math';

import '../models/piece_model.dart';
import '../utils/constants.dart';
import 'shape_definitions.dart';

class PieceGenerator {
  PieceGenerator({Random? random}) : _random = random ?? Random();

  final Random _random;

  List<PieceModel> generatePieces() {
    return List.generate(AppConstants.piecesPerTurn, (index) {
      final shape = _pickShape();

      return PieceModel(
        id: '${DateTime.now().microsecondsSinceEpoch}_$index',
        name: shape.name,
        cells: shape.cells,
        colorValue: AppConstants.pieceColorValues[
            _random.nextInt(AppConstants.pieceColorValues.length)],
      );
    });
  }

  ShapeDefinition _pickShape() {
    final totalWeight = ShapeDefinitions.shapes.fold<int>(
      0,
      (sum, shape) => sum + shape.weight,
    );
    var roll = _random.nextInt(totalWeight);

    for (final shape in ShapeDefinitions.shapes) {
      roll -= shape.weight;
      if (roll < 0) {
        return shape;
      }
    }

    return ShapeDefinitions.shapes.first;
  }
}
