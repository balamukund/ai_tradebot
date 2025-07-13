import 'package:flutter/material.dart';

class PageIndicatorWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double spacing;

  const PageIndicatorWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.size = 8.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: index == currentPage ? size * 2.5 : size,
          height: size,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          decoration: BoxDecoration(
            color: index == currentPage ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
      ),
    );
  }
}
