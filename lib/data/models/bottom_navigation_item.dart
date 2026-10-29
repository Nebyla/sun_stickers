import 'package:flutter/material.dart';

class BottomNavigationItem {
  final Widget disableIcon;
  final Widget enableIcon;
  final String label;
  final bool isSelected;

  const BottomNavigationItem(
      this.disableIcon,
      this.enableIcon,
      this.label, {
        this.isSelected = false,
      });
}
