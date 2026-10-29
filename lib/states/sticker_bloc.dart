import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/_data.dart';
import 'sticker_event.dart';
import 'sticker_state.dart';

class StickerBloc extends Bloc<StickerEvent, StickerState> {
  StickerBloc() : super(StickerState.initial()) {
    on<CategoryTapped>(_onCategoryTapped);
    on<QuantityIncreased>(_onQuantityIncreased);
    on<QuantityDecreased>(_onQuantityDecreased);
    on<AddedToCart>(_onAddedToCart);
    on<RemovedFromCart>(_onRemovedFromCart);
    on<CheckedOut>(_onCheckedOut);
    on<FavoriteToggled>(_onFavoriteToggled);
    on<ThemeToggled>(_onThemeToggled);
  }

  // Подсветка категории + фильтр стикеров
  void _onCategoryTapped(CategoryTapped event, Emitter<StickerState> emit) {
    final selectedType = event.category.type;

    final categories = state.categories
        .map((c) => c.copyWith(isSelected: c.type == selectedType))
        .toList();

    emit(state.copyWith(
      categories: categories,
      stickersByCategory: _filter(state.stickers, selectedType),
    ));
  }

  void _onQuantityIncreased(
      QuantityIncreased event, Emitter<StickerState> emit) {
    emit(_update(
      event.stickerId,
          (s) => s.copyWith(quantity: s.quantity + 1),
    ));
  }

  void _onQuantityDecreased(
      QuantityDecreased event, Emitter<StickerState> emit) {
    emit(_update(
      event.stickerId,
          (s) => s.quantity > 1 ? s.copyWith(quantity: s.quantity - 1) : s,
    ));
  }

  void _onAddedToCart(AddedToCart event, Emitter<StickerState> emit) {
    emit(_update(event.stickerId, (s) => s.copyWith(cart: true)));
  }

  void _onRemovedFromCart(RemovedFromCart event, Emitter<StickerState> emit) {
    emit(_update(
      event.stickerId,
          (s) => s.copyWith(cart: false, quantity: 1),
    ));
  }

  // Checkout: очищаем всю корзину
  void _onCheckedOut(CheckedOut event, Emitter<StickerState> emit) {
    final updated = state.stickers
        .map((s) => s.cart ? s.copyWith(cart: false, quantity: 1) : s)
        .toList();

    emit(_stateFrom(updated));
  }

  void _onFavoriteToggled(FavoriteToggled event, Emitter<StickerState> emit) {
    emit(_update(
      event.stickerId,
          (s) => s.copyWith(favorite: !s.favorite),
    ));
  }

  void _onThemeToggled(ThemeToggled event, Emitter<StickerState> emit) {
    emit(state.copyWith(light: !state.light));
  }

  // --- Вспомогательные методы ---

  /// Меняет один стикер и пересобирает состояние.
  StickerState _update(int id, Sticker Function(Sticker) change) {
    final updated =
    state.stickers.map((s) => s.id == id ? change(s) : s).toList();
    return _stateFrom(updated);
  }

  /// Собирает состояние из обновлённого списка стикеров.
  StickerState _stateFrom(List<Sticker> updated) {
    return state.copyWith(
      stickers: updated,
      stickersByCategory: _filter(updated, _selectedType),
      cart: updated.where((s) => s.cart).toList(),
      favorite: updated.where((s) => s.favorite).toList(),
    );
  }

  StickerType get _selectedType {
    final selected = state.categories.firstWhere(
          (c) => c.isSelected,
      orElse: () => state.categories.first,
    );
    return selected.type;
  }

  List<Sticker> _filter(List<Sticker> source, StickerType type) {
    if (type == StickerType.all) return source;
    return source.where((s) => s.type == type).toList();
  }

  int getIndex(int stickerId) =>
      state.stickers.indexWhere((s) => s.id == stickerId);

  Sticker getStickerById(int stickerId) =>
      state.stickers[getIndex(stickerId)];

  String stickerPrice(Sticker sticker) =>
      (sticker.quantity * sticker.price).toString();

  double get subtotal =>
      state.cart.fold(0.0, (sum, s) => sum + s.price * s.quantity);
}