import 'package:flutter/material.dart';
import '../../features/tasks/models/task_model.dart';

import '../../utils/task_utils.dart';
import '../common/difficulty_chips.dart';
import '../dialog/submit_task.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onSubmitted;

  const TaskCard({super.key, required this.task, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final difficulty = TaskUtils.fromString(task.difficulty);

    final xp = task.xpReward;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),

      margin: const EdgeInsets.symmetric(vertical: 6),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: task.completed ? Colors.green.shade50 : Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: task.completed ? Colors.green.shade300 : Colors.grey.shade300,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Row(
            children: [
              Icon(
                task.completed ? Icons.check_circle : Icons.task_alt,
                color: task.completed ? Colors.green : Colors.deepPurple,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,

                    color: task.completed ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// Difficulty + XP
          Row(
            children: [
              DifficultyChip(difficulty: difficulty),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  "⭐ +$xp XP",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          if (task.completed) ...[
            if ((task.reflection ?? "").isNotEmpty) ...[
              const Text(
                "Reflection",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Text(task.reflection!),
              ),

              const SizedBox(height: 16),
            ],

            Container(
              alignment: Alignment.center,

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(14),
              ),

              child: const Text(
                "Completed ✔",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 14),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: () async {
                  await showDialog(
                    context: context,

                    builder: (_) => SubmitTaskDialog(task: task),
                  );

                  onSubmitted?.call();
                },

                child: const Text("Submit", style: TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
}
