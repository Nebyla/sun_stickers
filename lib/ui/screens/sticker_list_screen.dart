import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studentwor/ui/screens/sticker_detail_screen.dart';
import '../../data/models/sticker.dart';
import '../../states/sticker_provider.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class StickerList extends ConsumerWidget {
  const StickerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stickerProvider);
    final notifier = ref.read(stickerProvider.notifier);

    return Scaffold(
      appBar: _appBar(context, ref),
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
              _categories(context, ref, state),
              StickerListView(
                stickers: state.stickersByCategory,
                onTap: (sticker) => _openDetail(context, sticker),
              ),
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
              StickerListView(
                stickers: state.stickers,
                isReversed: true,
                onTap: (sticker) => _openDetail(context, sticker),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, sticker) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StickerDetail(stickerId: sticker.id),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.dice),
        onPressed: () => ref.read(stickerProvider.notifier).toggleTheme(),
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

  Widget _categories(BuildContext context, WidgetRef ref, state) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final category = state.categories[index];
            return GestureDetector(
              onTap: () =>
                  ref.read(stickerProvider.notifier).onCategoryTap(category),
              child: Container(
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: category.isSelected
                      ? AppColor.accent
                      : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Text(
                  _categoryLabel(category.type),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => Container(width: 15),
          itemCount: state.categories.length,
        ),
      ),
    );
  }

  String _categoryLabel(StickerType type) {
    switch (type) {
      case StickerType.all:   return 'All';
      case StickerType.toy:   return 'Toy';
      case StickerType.fauna: return 'Fauna';
      case StickerType.plant: return 'Plant';
      case StickerType.berry: return 'Berry';
      case StickerType.fruit: return 'Fruit';
      case StickerType.other: return 'Other';
    }
  }
}