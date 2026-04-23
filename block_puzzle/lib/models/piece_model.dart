import 'position_model.dart';

class PieceModel {
  const PieceModel({
    required this.id,
    required this.name,
    required this.cells,
    required this.colorValue,
  });

  final String id;
  final String name;
  final List<PositionModel> cells;
  final int colorValue;

  bool get isEmpty => cells.isEmpty;

  int get width {
    if (cells.isEmpty) {
      return 0;
    }
    final maxColumn = cells
        .map((cell) => cell.column)
        .reduce((value, element) => value > element ? value : element);
    return maxColumn + 1;
  }

  int get height {
    if (cells.isEmpty) {
      return 0;
    }
    final maxRow = cells
        .map((cell) => cell.row)
        .reduce((value, element) => value > element ? value : element);
    return maxRow + 1;
  }
}
