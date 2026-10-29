import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../states/sticker_controller.dart';
import '../extensions/_extensions.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class StickerList extends StatelessWidget {
  const StickerList({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<StickerController>();

    return Scaffold(
      appBar: _appBar(context, c),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Morning, Sunny",
                  style: Theme.of(context).textTheme.headlineSmall),
              Text("What sticker do you want\nto buy today",
                  style: Theme.of(context).textTheme.displayLarge),
              _searchBar(),
              Text("Available for you",
                  style: Theme.of(context).textTheme.displaySmall),

              _categories(context, c),
              Obx(() => StickerListView(stickers: c.stickersByCategory.value)),

              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Best stickers of the week",
                        style: Theme.of(context).textTheme.displaySmall),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text("See all",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppColor.accent)),
                    ),
                  ],
                ),
              ),
              Obx(() => StickerListView(
                stickers: c.stickers.value,
                isReversed: true,
              )),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, StickerController c) {
    return AppBar(
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.dice),
        onPressed: c.toggleTheme,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on_outlined, color: AppColor.accent),
          Text("Location", style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Badge(
            badgeStyle: const BadgeStyle(badgeColor: AppColor.accent),
            badgeContent:
            const Text("2", style: TextStyle(color: Colors.white)),
            position: BadgePosition.topStart(start: -3),
            child: const Icon(Icons.notifications_none, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search sticker',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _categories(BuildContext context, StickerController c) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 40,
        child: Obx(() => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: c.categories.length,
          separatorBuilder: (_, __) => Container(width: 15),
          itemBuilder: (_, index) {
            final category = c.categories[index];
            return GestureDetector(
              onTap: () => c.onCategoryTap(category),
              child: Container(
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: category.isSelected
                      ? AppColor.accent
                      : Colors.transparent,
                  borderRadius:
                  const BorderRadius.all(Radius.circular(15)),
                ),
                child: Text(
                  category.type.name.firstCapital,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            );
          },
        )),
      ),
    );
  }
}