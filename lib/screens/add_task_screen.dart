import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/core/supabase/supabase.dart';
import 'package:lottie/lottie.dart';

import '../models/task_difficulty.dart';
import '../features/tasks/providers/task_provider.dart';
import '../utils/task_utils.dart';
import '../widgets/common/app_drawer.dart';
import '../widgets/common/top_bar.dart';
import '../widgets/common/difficulty_chips.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final TextEditingController taskController = TextEditingController();

  bool showSuccess = false;

  TaskDifficulty selectedDifficulty = TaskDifficulty.moderate;

  final Set<String> triggeredHaptics = {};

  Future<void> addTask() async {
    final user = supabase.auth.currentUser;
    final title = taskController.text.trim();

    if (title.isEmpty) return;

    await ref
        .read(taskControllerProvider.notifier)
        .createTask(
          title: title,
          difficulty: TaskUtils.toStringValue(selectedDifficulty),
        );

    setState(() {
      showSuccess = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      showSuccess = false;
      taskController.clear();
      selectedDifficulty = TaskDifficulty.moderate;
    });
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskControllerProvider);

    final rewardXP = TaskUtils.getXP(selectedDifficulty);

    return Scaffold(
      appBar: const TopBar(),
      drawer: const AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// PAGE TITLE
            Text(
              "Create Mission 🚀",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "Every mission completed makes you stronger.",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 15),

            /// TASK NAME + ADD BUTTON
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => addTask(),
                    decoration: InputDecoration(
                      hintText: "Mission name",
                      prefixIcon: const Icon(Icons.flag),
                      filled: true,
                      fillColor: Colors.deepPurple.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  width: 60,
                  height: 52,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showSuccess
                        ? ClipRRect(
                            key: const ValueKey("success"),
                            borderRadius: BorderRadius.circular(18),
                            child: Lottie.asset(
                              "assets/animations/success.json",
                              repeat: false,
                            ),
                          )
                        : ElevatedButton(
                            key: const ValueKey("button"),
                            onPressed: addTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.add_rounded, size: 20),
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              "Difficulty",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// CHOICE CHIPS
            Row(
              children: TaskDifficulty.values.map((difficulty) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${TaskUtils.getEmoji(difficulty)} ${TaskUtils.getLabel(difficulty)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      selected: selectedDifficulty == difficulty,
                      onSelected: (_) {
                        HapticFeedback.selectionClick();

                        setState(() {
                          selectedDifficulty = difficulty;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// XP CARD
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              width: double.infinity,

              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.amber.shade50,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: Colors.amber.shade300),
              ),

              child: Row(
                children: [
                  const Icon(Icons.stars, color: Colors.orange, size: 40),

                  const SizedBox(width: 15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Mission Reward",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "+$rewardXP XP",
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Today's Missions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Text(
              "Swipe left to delete a mission",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: tasksAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text(error.toString())),
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight * 0.55,
                                  child: Lottie.asset(
                                    "assets/animations/empty.json",
                                    repeat: true,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: SizedBox(
                            height: 55,
                            child: Lottie.asset(
                              "assets/animations/delete.json",
                              repeat: false,
                            ),
                          ),
                        ),
                        onUpdate: (details) {
                          if (details.progress > .20 &&
                              !triggeredHaptics.contains(task.id)) {
                            triggeredHaptics.add(task.id);

                            HapticFeedback.lightImpact();
                          }
                        },
                        onDismissed: (_) {
                          triggeredHaptics.remove(task.id);

                          HapticFeedback.mediumImpact();

                          ref
                              .read(taskControllerProvider.notifier)
                              .deleteTask(task.id);
                        },
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade50,
                              child: Icon(
                                Icons.flag,
                                color: Colors.deepPurple.shade700,
                              ),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: task.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  DifficultyChip(
                                    difficulty: TaskUtils.fromString(
                                      task.difficulty,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      "⭐ +${task.xpReward}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (task.completed)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
