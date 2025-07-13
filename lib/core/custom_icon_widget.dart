import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final double size;
  final Color color;

  const CustomIconWidget({
    Key? key,
    required this.iconName,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconMap = {
      'close': Icons.close,
      // Add other icons as needed
    };
    return Icon(
      iconMap[iconName] ?? Icons.error,
      size: size,
      color: color,
    );
  }
}