import 'package:flutter/material.dart';

import '../../data/_data.dart';
import '_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void onTabTap(int index) {
    if (currentIndex == index) return;
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      StickerList(),
      CartScreen(),
      FavoriteScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: currentIndex, children: screens),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTap,
        selectedFontSize: 0,
        items: AppData.bottomNavigationItems.map((element) {
          return BottomNavigationBarItem(
            icon: element.disableIcon,
            label: element.label,
            activeIcon: element.enableIcon,
          );
        }).toList(),
      ),
    );
  }
}