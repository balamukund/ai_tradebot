
import 'package:flutter/material.dart';

class OrderTypeSelectorWidget extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const OrderTypeSelectorWidget({
    required this.selectedType,
    required this.onTypeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Order Type: $selectedType"),
        Row(
          children: ['BUY', 'SELL'].map((type) {
            return ElevatedButton(
              onPressed: () => onTypeChanged(type),
              child: Text(type),
            );
          }).toList(),
        ),
      ],
    );
  }
}
