
import 'package:flutter/material.dart';

class AiSuggestionsWidget extends StatelessWidget {
  final List<String> suggestions;
  final TextEditingController stopLossController;
  final TextEditingController targetController;

  const AiSuggestionsWidget({
    required this.suggestions,
    required this.stopLossController,
    required this.targetController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI Suggestions:"),
        for (var suggestion in suggestions) Text("- $suggestion"),
      ],
    );
  }
}
