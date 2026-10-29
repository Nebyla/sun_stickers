import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/_data.dart';
import '../../states/sticker_provider.dart';
import '../../states/sticker_state.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  double taxes = 5.0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stickerProvider);
    final cartItems = state.cart;

    return Scaffold(
      appBar: _appBar(context),
      body: EmptyWrapper(
        title: "Empty cart",
        isEmpty: cartItems.isEmpty,
        child: _cartListView(context, state),
      ),
      bottomNavigationBar:
      cartItems.isEmpty ? const SizedBox() : _bottomAppBar(context, state),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text("Cart screen",
          style: Theme.of(context).textTheme.displayMedium),
    );
  }

  Widget _cartListView(BuildContext context, StickerState state) {
    final cartItems = state.cart;
    final notifier = ref.read(stickerProvider.notifier);
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: cartItems.length,
      itemBuilder: (_, index) {
        final sticker = cartItems[index];
        return Dismissible(
          direction: DismissDirection.endToStart,
          onDismissed: (_) => notifier.onRemoveFromCartTap(sticker.id),
          key: ValueKey(sticker.id),
          background: Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const FaIcon(FontAwesomeIcons.trash),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.dark
                  : Colors.white,
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Image.asset(sticker.image, scale: 10),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sticker.name,
                        style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 5),
                    Text("\$${sticker.price}",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    CounterButton(
                      onIncrementTap: () =>
                          notifier.onIncreaseQuantityTap(sticker.id),
                      onDecrementTap: () =>
                          notifier.onDecreaseQuantityTap(sticker.id),
                      size: const Size(24, 24),
                      padding: 0,
                      label: Text(sticker.quantity.toString(),
                          style:
                          Theme.of(context).textTheme.displayMedium),
                    ),
                    Text(
                      "\$${state.stickerPrice(sticker)}",
                      style: AppTextStyle.h2Style
                          .copyWith(color: AppColor.accent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => Container(height: 20),
    );
  }

  Widget _bottomAppBar(BuildContext context, StickerState state) {
    final notifier = ref.read(stickerProvider.notifier);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
        child: SizedBox(
          height: 250,
          child: Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.dark
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _row(context, "Subtotal",
                        "\$${state.subtotal.toString()}"),
                    const SizedBox(height: 15),
                    _row(context, "Taxes", "\$${taxes.toString()}"),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(thickness: 4.0, height: 30.0),
                    ),
                    _row(context, "Total",
                        "\$${(state.subtotal + taxes).toString()}",
                        accent: true),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          onPressed: notifier.onCheckOutTap,
                          child: const Text("Checkout"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value,
      {bool accent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.headlineSmall),
          Text(value,
              style: accent
                  ? AppTextStyle.h2Style.copyWith(color: AppColor.accent)
                  : Theme.of(context).textTheme.displayMedium),
        ],
      ),
    );
  }
}