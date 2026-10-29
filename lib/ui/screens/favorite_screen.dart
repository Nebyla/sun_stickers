import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/_data.dart';
import '../../states/sticker_provider.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItems = ref.watch(stickerProvider).favorite;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite screen",
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: EmptyWrapper(
        type: EmptyWrapperType.favorite,
        title: "Empty favorite",
        isEmpty: favoriteItems.isEmpty,
        child: _favoriteListView(context, ref, favoriteItems),
      ),
    );
  }

  Widget _favoriteListView(
      BuildContext context, WidgetRef ref, List<Sticker> favoriteItems) {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: favoriteItems.length,
      itemBuilder: (_, index) {
        final sticker = favoriteItems[index];
        return Card(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : AppColor.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(sticker.name,
                style: Theme.of(context).textTheme.headlineMedium),
            leading: Image.asset(sticker.image),
            subtitle: Text(sticker.description,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge),
            trailing: IconButton(
              icon: const Icon(AppIcon.heart, color: Colors.redAccent),
              onPressed: () => ref
                  .read(stickerProvider.notifier)
                  .onAddRemoveFavoriteTap(sticker.id),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => Container(height: 20),
    );
  }
}