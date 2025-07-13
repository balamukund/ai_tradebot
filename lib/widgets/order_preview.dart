
import 'package:flutter/material.dart';

class OrderPreviewWidget extends StatelessWidget {
  final String orderType;
  final String symbol;
  final int quantity;
  final double price;
  final double? stopLoss;
  final double? target;
  final bool bracketOrderEnabled;
  final bool isPaperTrading;

  const OrderPreviewWidget({
    required this.orderType,
    required this.symbol,
    required this.quantity,
    required this.price,
    this.stopLoss,
    this.target,
    required this.bracketOrderEnabled,
    required this.isPaperTrading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Preview: $orderType $symbol"),
        Text("Qty: $quantity @ ₹$price"),
        if (stopLoss != null) Text("SL: ₹$stopLoss"),
        if (target != null) Text("Target: ₹$target"),
        Text("Bracket Order: $bracketOrderEnabled"),
        Text("Paper Trading: $isPaperTrading"),
      ],
    );
  }
}
