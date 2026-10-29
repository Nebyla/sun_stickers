import '_models.dart';

class StickerCategory {
  final StickerType type;
  final bool isSelected;

  const StickerCategory({required this.type, required this.isSelected});

  StickerCategory copyWith({
    StickerType? type,
    bool? isSelected,
  }) {
    return StickerCategory(
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}