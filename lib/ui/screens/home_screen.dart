import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/_data.dart';
import '_screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = 0.obs;

    return Scaffold(
      body: SafeArea(
        child: Obx(() => IndexedStack(
          index: currentIndex.value,
          children: const [
            StickerList(),
            CartScreen(),
            FavoriteScreen(),
            ProfileScreen(),
          ],
        )),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: currentIndex.value,
        selectedFontSize: 0,
        onTap: (index) => currentIndex.value = index,
        items: AppData.bottomNavigationItems.map((element) {
          return BottomNavigationBarItem(
            icon: element.disableIcon,
            label: element.label,
            activeIcon: element.enableIcon,
          );
        }).toList(),
      )),
    );
  }
}