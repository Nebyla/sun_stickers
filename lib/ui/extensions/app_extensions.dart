import '../../data/models/sticker.dart';

extension StringExtension on String {
  String get firstCapital => this[0].toUpperCase() + substring(1, length);
}

extension StickerTypeExtension on StickerType {
  String get name {
    switch (this) {
      case StickerType.all:     return 'all';
      case StickerType.toy:     return 'toy';
      case StickerType.fauna:   return 'fauna';
      case StickerType.plant:   return 'plant';
      case StickerType.berry:   return 'berry';
      case StickerType.fruit:   return 'fruit';
      case StickerType.other:   return 'other';
    }
  }
}