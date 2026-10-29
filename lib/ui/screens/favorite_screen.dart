import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/sticker_state.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StickerState>();
    final favoriteItems = state.favorite;

    return Scaffold(
      appBar: _appBar(context),
      body: EmptyWrapper(
        type: EmptyWrapperType.favorite,
        title: "Empty favorite",
        isEmpty: favoriteItems.isEmpty,
        child: _favoriteListView(context, state),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text("Favorite screen",
          style: Theme.of(context).textTheme.displayMedium),
    );
  }

  Widget _favoriteListView(BuildContext context, StickerState state) {
    final favoriteItems = state.favorite;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: favoriteItems.length,
      itemBuilder: (_, index) {
        final sticker = favoriteItems[index];
        return Card(
          color: isDark ? AppColor.dark : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListTile(
            title: Text(sticker.name,
                style: Theme.of(context).textTheme.headlineMedium),
            leading: Image.asset(sticker.image),
            subtitle: Text(
              sticker.description,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: IconButton(
              icon: const Icon(AppIcon.heart, color: Colors.redAccent),
              onPressed: () => context
                  .read<StickerState>()
                  .onAddRemoveFavoriteTap(sticker.id),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => Container(height: 20),
    );
  }
}