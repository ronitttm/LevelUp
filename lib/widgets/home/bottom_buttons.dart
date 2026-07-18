import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback onAddTask;
  final VoidCallback onEndDay;

  final bool hasEndedToday;

  const BottomButtons({
    super.key,
    required this.onAddTask,
    required this.onEndDay,

    required this.hasEndedToday,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (hasEndedToday) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "You've already ended today. Check your Day Summary 📅",
                    ),
                  ),
                );
                return;
              }

              onAddTask();
            },
            icon: const Icon(Icons.add),
            label: const Text("Add Task"),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (hasEndedToday) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "You've already ended today. Check your Day Summary 📅",
                    ),
                  ),
                );
                return;
              }

              onEndDay();
            },
            icon: const Icon(Icons.nightlight_round),
            label: const Text("End Day"),
          ),
        ),
      ],
    );
  }
}
