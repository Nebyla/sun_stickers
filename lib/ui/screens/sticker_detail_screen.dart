import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../data/models/sticker.dart';
import '../../states/sticker_state.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class StickerDetail extends StatelessWidget {
  final int stickerId;

  const StickerDetail({super.key, required this.stickerId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StickerState>();
    final sticker = state.getStickerById(stickerId);

    return Scaffold(
      appBar: _appBar(context),
      body: Center(child: Image.asset(sticker.image, scale: 2)),
      floatingActionButton: _floatingActionButton(context, sticker),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: _bottomAppBar(context, state, sticker),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget _floatingActionButton(BuildContext context, Sticker sticker) {
    return FloatingActionButton(
      elevation: 0.0,
      backgroundColor: AppColor.accent,
      onPressed: () => context
          .read<StickerState>()
          .onAddRemoveFavoriteTap(sticker.id),
      child: sticker.favorite
          ? const Icon(AppIcon.heart)
          : const Icon(AppIcon.outlinedHeart),
    );
  }

  Widget _bottomAppBar(
      BuildContext context, StickerState state, Sticker sticker) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
        child: SizedBox(
          height: 300,
          child: Container(
            color: isDark ? AppColor.dark : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
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
                        Text(
                          sticker.score.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "(${sticker.voter})",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                          onIncrementTap: () => context
                              .read<StickerState>()
                              .onIncreaseQuantityTap(sticker.id),
                          onDecrementTap: () => context
                              .read<StickerState>()
                              .onDecreaseQuantityTap(sticker.id),
                          label: Text(
                            sticker.quantity.toString(),
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      sticker.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          onPressed: () => context
                              .read<StickerState>()
                              .onAddToCartTap(sticker.id),
                          child: const Text("Add to cart"),
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
}