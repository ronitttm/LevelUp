import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tasks/models/task_model.dart';
import '../../features/tasks/providers/task_provider.dart';

import '../../utils/task_utils.dart';
import '../common/difficulty_chips.dart';
import '../common/reflection_field.dart';

class SubmitTaskDialog extends ConsumerStatefulWidget {
  final TaskModel task;

  const SubmitTaskDialog({super.key, required this.task});

  @override
  ConsumerState<SubmitTaskDialog> createState() => _SubmitTaskDialogState();
}

class _SubmitTaskDialogState extends ConsumerState<SubmitTaskDialog> {
  final _controller = TextEditingController();

  bool _loading = false;

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await ref
          .read(taskControllerProvider.notifier)
          .completeTask(
            taskId: widget.task.id,
            reflection: _controller.text.trim(),
          );
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not submit the task. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final difficulty = TaskUtils.fromString(widget.task.difficulty);

    final xp = widget.task.xpReward;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Center(
                child: Text(
                  "Submit Task 🚀",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 28),

              Text(
                widget.task.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  DifficultyChip(difficulty: difficulty),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
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

              const SizedBox(height: 28),

              const Text(
                "Reflection (Optional)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ReflectionTextField(controller: _controller),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 16),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  onPressed: _loading ? null : _submit,

                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Submit Task",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
