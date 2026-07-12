import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../providers/task_provider.dart';
import 'task_card.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    if (tasks.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.45,
                        child: Transform.scale(
                          scale: 1.85, // 1.0 = normal
                          child: Lottie.asset(
                            "assets/animations/empty.json",
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 12),

      itemCount: tasks.length,

      separatorBuilder: (_, __) => const SizedBox(height: 12),

      itemBuilder: (context, index) {
        return TaskCard(task: tasks[index]);
      },
    );
  }
}
