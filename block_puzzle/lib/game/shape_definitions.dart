import '../models/position_model.dart';

class ShapeDefinition {
  const ShapeDefinition({
    required this.name,
    required this.cells,
    this.weight = 1,
  });

  final String name;
  final List<PositionModel> cells;
  final int weight;
}

class ShapeDefinitions {
  const ShapeDefinitions._();

  static const List<ShapeDefinition> shapes = [
    ShapeDefinition(
      name: 'Single',
      weight: 4,
      cells: [PositionModel(row: 0, column: 0)],
    ),
    ShapeDefinition(
      name: 'Line 2 Horizontal',
      weight: 4,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 0, column: 1),
      ],
    ),
    ShapeDefinition(
      name: 'Line 2 Vertical',
      weight: 4,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 1, column: 0),
      ],
    ),
    ShapeDefinition(
      name: 'Line 3 Horizontal',
      weight: 3,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 0, column: 1),
        PositionModel(row: 0, column: 2),
      ],
    ),
    ShapeDefinition(
      name: 'Line 3 Vertical',
      weight: 3,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 1, column: 0),
        PositionModel(row: 2, column: 0),
      ],
    ),
    ShapeDefinition(
      name: 'Square 2',
      weight: 3,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 0, column: 1),
        PositionModel(row: 1, column: 0),
        PositionModel(row: 1, column: 1),
      ],
    ),
    ShapeDefinition(
      name: 'L Small',
      weight: 3,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 1, column: 0),
        PositionModel(row: 1, column: 1),
      ],
    ),
    ShapeDefinition(
      name: 'L Small Mirrored',
      weight: 3,
      cells: [
        PositionModel(row: 0, column: 1),
        PositionModel(row: 1, column: 0),
        PositionModel(row: 1, column: 1),
      ],
    ),
    ShapeDefinition(
      name: 'T Small',
      weight: 2,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 0, column: 1),
        PositionModel(row: 0, column: 2),
        PositionModel(row: 1, column: 1),
      ],
    ),
    ShapeDefinition(
      name: 'Zigzag',
      weight: 2,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 0, column: 1),
        PositionModel(row: 1, column: 1),
        PositionModel(row: 1, column: 2),
      ],
    ),
    ShapeDefinition(
      name: 'Zigzag Mirrored',
      weight: 2,
      cells: [
        PositionModel(row: 0, column: 1),
        PositionModel(row: 0, column: 2),
        PositionModel(row: 1, column: 0),
        PositionModel(row: 1, column: 1),
      ],
    ),
    ShapeDefinition(
      name: 'Corner 5',
      weight: 1,
      cells: [
        PositionModel(row: 0, column: 0),
        PositionModel(row: 1, column: 0),
        PositionModel(row: 2, column: 0),
        PositionModel(row: 2, column: 1),
        PositionModel(row: 2, column: 2),
      ],
    ),
  ];
}
