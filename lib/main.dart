import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'states/sticker_state.dart';
import 'ui/_ui.dart';
import 'ui_kit/_ui_kit.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StickerState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StickerState>();
    return MaterialApp(
      title: 'Sunny Stickers',
      debugShowCheckedModeBanner: false,
      theme: state.light ? AppTheme.lightTheme : AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}