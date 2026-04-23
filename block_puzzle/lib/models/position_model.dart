class PositionModel {
  const PositionModel({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;

  PositionModel translate({
    int rowOffset = 0,
    int columnOffset = 0,
  }) {
    return PositionModel(
      row: row + rowOffset,
      column: column + columnOffset,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PositionModel &&
            runtimeType == other.runtimeType &&
            row == other.row &&
            column == other.column;
  }

  @override
  int get hashCode => Object.hash(row, column);
}
