import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../data/_data.dart';
import '../../states/sticker_controller.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<StickerController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart screen",
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Obx(() => EmptyWrapper(
        title: "Empty cart",
        isEmpty: c.cart.value.isEmpty,
        child: _cartListView(context, c),
      )),
      bottomNavigationBar: Obx(() => c.cart.value.isEmpty
          ? const SizedBox()
          : _bottomAppBar(context, c)),
    );
  }

  Widget _cartListView(BuildContext context, StickerController c) {
    return Obx(() => ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: c.cart.value.length,
      separatorBuilder: (_, __) => Container(height: 20),
      itemBuilder: (_, index) {
        final sticker = c.cart.value[index];
        return Dismissible(
          direction: DismissDirection.endToStart,
          onDismissed: (_) => c.onRemoveFromCartTap(sticker),
          key: UniqueKey(),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const FaIcon(FontAwesomeIcons.trash),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sticker.name,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium),
                      const SizedBox(height: 5),
                      Text("\$${sticker.price}",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CounterButton(
                      onIncrementTap: () =>
                          c.onIncreaseQuantityTap(sticker),
                      onDecrementTap: () =>
                          c.onDecreaseQuantityTap(sticker),
                      size: const Size(24, 24),
                      padding: 0,
                      label: Text(
                        sticker.quantity.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium,
                      ),
                    ),
                    Text(
                      "\$${c.stickerPrice(sticker)}",
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
    ));
  }

  Widget _bottomAppBar(BuildContext context, StickerController c) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        height: 250,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.dark
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              _row(context, "Subtotal", "\$${c.subtotal.toString()}"),
              const SizedBox(height: 15),
              _row(context, "Taxes", "\$5.0"),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(thickness: 4.0, height: 30.0),
              ),
              _row(context, "Total", "\$${(c.subtotal + 5.0).toString()}",
                  accent: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: c.onCheckOutTap,
                    child: const Text("Checkout"),
                  ),
                ),
              ),
            ],
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