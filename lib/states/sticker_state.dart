import 'package:flutter/material.dart';
import '../data/_data.dart';

class StickerState extends ChangeNotifier {
  List<StickerCategory> categories = List.of(AppData.categories);
  List<Sticker> stickers = List.of(AppData.stickers);
  List<Sticker> stickersByCategory = List.of(AppData.stickers);
  List<Sticker> cart = <Sticker>[];
  List<Sticker> favorite = <Sticker>[];
  bool light = true;
  String searchQuery = '';

  Future<void> onCategoryTap(StickerCategory category) async {
    categories = categories.map((e) {
      return e.type == category.type
          ? e.copyWith(isSelected: true)
          : e.copyWith(isSelected: false);
    }).toList();

    stickersByCategory = category.type == StickerType.all
        ? stickers
        : stickers.where((e) => e.type == category.type).toList();

    _applySearch();
    notifyListeners();
  }

  void onSearchChanged(String query) {
    searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    final selectedCategory = categories.firstWhere(
          (e) => e.isSelected,
      orElse: () => categories.first,
    );

    List<Sticker> base = selectedCategory.type == StickerType.all
        ? stickers
        : stickers.where((e) => e.type == selectedCategory.type).toList();

    if (searchQuery.isEmpty) {
      stickersByCategory = base;
    } else {
      stickersByCategory = base
          .where((e) =>
          e.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  Future<void> onIncreaseQuantityTap(int stickerId) async {
    stickers = stickers.map((e) {
      return e.id == stickerId
          ? e.copyWith(quantity: e.quantity + 1)
          : e;
    }).toList();
    _recalculateCartAndFavorite();
    notifyListeners();
  }

  Future<void> onDecreaseQuantityTap(int stickerId) async {
    stickers = stickers.map((e) {
      if (e.id == stickerId) {
        return e.quantity == 1 ? e : e.copyWith(quantity: e.quantity - 1);
      }
      return e;
    }).toList();
    _recalculateCartAndFavorite();
    notifyListeners();
  }

  Future<void> onAddToCartTap(int stickerId) async {
    stickers = stickers.map((e) {
      return e.id == stickerId ? e.copyWith(cart: true) : e;
    }).toList();
    _recalculateCartAndFavorite();
    notifyListeners();
  }

  Future<void> onRemoveFromCartTap(int stickerId) async {
    stickers = stickers.map((e) {
      return e.id == stickerId
          ? e.copyWith(cart: false, quantity: 1)
          : e;
    }).toList();
    _recalculateCartAndFavorite();
    notifyListeners();
  }

  Future<void> onCheckOutTap() async {
    final cartIds = cart.map((e) => e.id).toSet();
    stickers = stickers.map((e) {
      return cartIds.contains(e.id)
          ? e.copyWith(cart: false, quantity: 1)
          : e;
    }).toList();
    _recalculateCartAndFavorite();
    notifyListeners();
  }

  Future<void> onAddRemoveFavoriteTap(int stickerId) async {
    stickers = stickers.map((e) {
      return e.id == stickerId ? e.copyWith(favorite: !e.favorite) : e;
    }).toList();
    _recalculateCartAndFavorite();
    notifyListeners();
  }

  void toggleTheme() {
    light = !light;
    notifyListeners();
  }

  void _recalculateCartAndFavorite() {
    cart = stickers.where((e) => e.cart).toList();
    favorite = stickers.where((e) => e.favorite).toList();
  }

  int getIndex(int stickerId) =>
      stickers.indexWhere((e) => e.id == stickerId);

  Sticker getStickerById(int stickerId) =>
      stickers[getIndex(stickerId)];

  String stickerPrice(Sticker sticker) =>
      (sticker.quantity * sticker.price).toString();

  double get subtotal {
    double amount = 0.0;
    for (var e in cart) {
      amount += e.price * e.quantity;
    }
    return amount;
  }
}