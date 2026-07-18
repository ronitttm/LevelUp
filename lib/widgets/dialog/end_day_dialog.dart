import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tasks/providers/task_provider.dart';
import '../../services/celebration_service.dart';

class EndDayDialog extends ConsumerStatefulWidget {
  const EndDayDialog({super.key});

  @override
  ConsumerState<EndDayDialog> createState() => _EndDayDialogState();
}

class _EndDayDialogState extends ConsumerState<EndDayDialog> {
  bool _loading = false;

  Future<void> _endDay() async {
    if (_loading) return;

    setState(() => _loading = true);

    final result = await ref.read(taskControllerProvider.notifier).endDay();

    if (!mounted) return;

    if (result.noTasks) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No tasks were added today. Nothing to end 😊"),
        ),
      );

      return;
    }

    if (result.streakIncreased) {
      ref.read(celebrationServiceProvider).streak(result.currentStreak);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),

      title: const Text(
        "End your day?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

      content: const Text(
        "This will save today's progress and prepare a fresh task list for tomorrow.",
      ),

      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        ElevatedButton.icon(
          onPressed: _loading ? null : _endDay,

          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.nightlight_round),

          label: Text(_loading ? "Ending..." : "End Day"),
        ),
      ],
    );
  }
}
