import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback onAddTask;
  final VoidCallback onEndDay;

  const BottomButtons({
    super.key,
    required this.onAddTask,
    required this.onEndDay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAddTask,
            icon: const Icon(Icons.add),
            label: const Text("Add Task"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: onEndDay,
            icon: const Icon(Icons.nightlight_round),
            label: const Text("End Day"),
          ),
        ),
      ],
    );
  }
}
