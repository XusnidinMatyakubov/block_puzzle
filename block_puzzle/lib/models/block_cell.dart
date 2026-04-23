import 'position_model.dart';

class BlockCell {
  const BlockCell({
    required this.position,
    this.colorValue,
    this.isFilled = false,
  });

  final PositionModel position;
  final int? colorValue;
  final bool isFilled;

  BlockCell copyWith({
    PositionModel? position,
    int? colorValue,
    bool? isFilled,
    bool clearColor = false,
  }) {
    return BlockCell(
      position: position ?? this.position,
      colorValue: clearColor ? null : colorValue ?? this.colorValue,
      isFilled: isFilled ?? this.isFilled,
    );
  }
}
