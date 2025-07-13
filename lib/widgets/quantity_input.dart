
import 'package:flutter/material.dart';

class QuantityInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final Map<String, dynamic> portfolioData;
  final double currentPrice;
  final ValueChanged<int> onPositionSizeCalculated;

  const QuantityInputWidget({
    required this.controller,
    required this.portfolioData,
    required this.currentPrice,
    required this.onPositionSizeCalculated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "Quantity"),
      onChanged: (value) {
        int quantity = int.tryParse(value) ?? 0;
        onPositionSizeCalculated(quantity);
      },
    );
  }
}
