import 'package:flutter/material.dart';
import '../../data/_data.dart';
import '../../ui_kit/_ui_kit.dart';

class StickerListView extends StatelessWidget {
  const StickerListView({
    super.key,
    required this.stickers,
    this.isReversed = false,
    required this.onTap,
  });

  final List<Sticker> stickers;
  final bool isReversed;
  final void Function(Sticker sticker) onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final list = isReversed ? stickers.reversed.toList() : stickers;

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 20),
        itemBuilder: (_, index) {
          final sticker = list[index];
          return GestureDetector(
            onTap: () => onTap(sticker),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: isDark ? AppColor.dark : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(sticker.image, scale: 6),
                    Text("\$${sticker.price}",
                        style: AppTextStyle.h3Style
                            .copyWith(color: AppColor.accent)),
                    Text(sticker.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => Container(width: 50),
        itemCount: stickers.length,
      ),
    );
  }
}