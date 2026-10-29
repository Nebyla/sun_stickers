import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/_data.dart';
import '../../states/sticker_controller.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class StickerDetail extends StatelessWidget {
  const StickerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<StickerController>();
    final Sticker sticker = Get.arguments as Sticker;

    return Obx(() {
      final _ = c.stickers.length;

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            'Sticker Detail Screen',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
        body: Center(child: Image.asset(sticker.image, scale: 2)),
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: AppColor.accent,
          onPressed: () => c.onAddRemoveFavoriteTap(sticker),
          child: sticker.favorite
              ? const Icon(AppIcon.heart)
              : const Icon(AppIcon.outlinedHeart),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: _bottomAppBar(context, c, sticker),
      );
    });
  }

  Widget _bottomAppBar(
      BuildContext context, StickerController c, Sticker sticker) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        height: 300,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.dark
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    itemPadding: EdgeInsets.zero,
                    itemSize: 20,
                    initialRating: sticker.score,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    glow: false,
                    ignoreGestures: true,
                    itemBuilder: (_, __) => const FaIcon(
                      FontAwesomeIcons.solidStar,
                      color: AppColor.yellow,
                    ),
                    onRatingUpdate: (_) {},
                  ),
                  const SizedBox(width: 15),
                  Text(sticker.score.toString(),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 5),
                  Text("(${sticker.voter})",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${sticker.price}",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(color: AppColor.accent),
                  ),
                  CounterButton(
                    onIncrementTap: () => c.onIncreaseQuantityTap(sticker),
                    onDecrementTap: () => c.onDecreaseQuantityTap(sticker),
                    label: Text(
                      sticker.quantity.toString(),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text("Description",
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(sticker.description,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => c.onAddToCartTap(sticker),
                  child: const Text("Add to cart"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}