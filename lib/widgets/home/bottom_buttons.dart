import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback onAddTask;
  final VoidCallback onEndDay;

  final bool hasEndedToday;

  final bool hasTasksToday;

  const BottomButtons({
    super.key,
    required this.onAddTask,
    required this.onEndDay,

    required this.hasEndedToday,
    required this.hasTasksToday,
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

              if (!hasTasksToday) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "No tasks were added today. Nothing to end 😊",
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
