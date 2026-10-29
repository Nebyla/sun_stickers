import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/_data.dart';
import '../../states/sticker_controller.dart';
import '../../ui_kit/_ui_kit.dart';
import '../widgets/_widgets.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<StickerController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite screen",
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Obx(() => EmptyWrapper(
        type: EmptyWrapperType.favorite,
        title: "Empty favorite",
        isEmpty: c.favorite.isEmpty,
        child: _favoriteListView(context, c),
      )),
    );
  }

  Widget _favoriteListView(BuildContext context, StickerController c) {
    return Obx(() => ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: c.favorite.length,
      separatorBuilder: (_, __) => Container(height: 20),
      itemBuilder: (_, index) {
        final sticker = c.favorite[index];
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
            subtitle: Text(
              sticker.description,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: IconButton(
              icon: const Icon(AppIcon.heart, color: Colors.redAccent),
              onPressed: () => c.onAddRemoveFavoriteTap(sticker),
            ),
          ),
        );
      },
    ));
  }
}