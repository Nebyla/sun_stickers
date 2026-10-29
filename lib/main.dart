import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'states/sticker_controller.dart';
import 'ui/_ui.dart';
import 'ui_kit/_ui_kit.dart';

void main() {
  Get.put(StickerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StickerController>();
    return Obx(() {
      return GetMaterialApp(
        title: 'Sunny Stickers',
        debugShowCheckedModeBanner: false,
        theme: controller.light.value
            ? AppTheme.lightTheme
            : AppTheme.darkTheme,
        home: const HomeScreen(),
      );
    });
  }
}