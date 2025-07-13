
import 'package:flutter/material.dart';

class PriceInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String orderType;
  final Map<String, dynamic> stockData;
  final ValueChanged<double> onPriceAdjusted;

  const PriceInputWidget({
    required this.controller,
    required this.orderType,
    required this.stockData,
    required this.onPriceAdjusted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: "Price"),
      onChanged: (value) {
        double price = double.tryParse(value) ?? 0;
        onPriceAdjusted(price);
      },
    );
  }
}
