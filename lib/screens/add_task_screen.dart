import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/widgets/app_drawer.dart';
import 'package:lottie/lottie.dart';

import '../providers/task_provider.dart';
import '../widgets/top_bar.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  bool showSuccess = false;

  /// 🧠 Prevent haptic spam
  final Set<int> triggeredHaptics = {};

  Future<void> addTask() async {
    final text = taskController.text.trim();
    if (text.isEmpty) return;
    final points = int.tryParse(pointsController.text) ?? 10;

    ref.read(taskProvider.notifier).addTask(text, points: points);

    setState(() {
      showSuccess = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      showSuccess = false;
      taskController.clear();
      pointsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      appBar: const TopBar(),
      drawer: const AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔤 Input Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      hintText: "Enter task",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// ➕ / 🎬 Lottie Button
                SizedBox(
                  height: 56,
                  width: 56,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showSuccess
                        ? ClipRRect(
                            key: const ValueKey("lottie"),
                            borderRadius: BorderRadius.circular(8),
                            child: Lottie.asset(
                              "assets/success.json",
                              repeat: false,
                            ),
                          )
                        : ElevatedButton(
                            key: const ValueKey("button"),
                            onPressed: showSuccess ? null : addTask,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.add),
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔢 Points Input
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 120,
                child: TextField(
                  controller: pointsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Points",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📋 Title + hint
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Tasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 4),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Swipe left to delete",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 10),

            /// 📋 Task List / Empty State
            Expanded(
              child: tasks.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 140,
                            child: Lottie.asset(
                              "assets/empty.json",
                              repeat: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "It feels empty 😕",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return Dismissible(
                          key: ValueKey(task.title + index.toString()),
                          direction: DismissDirection.endToStart,

                          /// 🎬 Background animation while swiping
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red.shade100,
                            child: SizedBox(
                              height: 50,
                              child: Lottie.asset(
                                "assets/delete.json",
                                repeat: false,
                              ),
                            ),
                          ),

                          /// 👆 Light haptic on swipe start
                          onUpdate: (details) {
                            if (details.progress > 0.2 &&
                                !triggeredHaptics.contains(index)) {
                              triggeredHaptics.add(index);
                              HapticFeedback.lightImpact();
                            }
                          },

                          /// 💥 Strong haptic on delete
                          onDismissed: (_) {
                            triggeredHaptics.remove(index);
                            HapticFeedback.mediumImpact();

                            ref.read(taskProvider.notifier).deleteTask(index);
                          },

                          child: CheckboxListTile(
                            value: task.isCompleted,
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),

                            secondary: const Icon(Icons.task_alt),

                            onChanged: (_) {
                              ref.read(taskProvider.notifier).toggleTask(index);
                            },

                            /// optional styling
                            tileColor: task.isCompleted
                                ? Colors.green.shade50
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
