import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/widgets/app_drawer.dart';
import 'package:lottie/lottie.dart';

import '../providers/task_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/top_bar.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showConfetti = false;
  bool _confettiPlayed = false;

  String getMood(int total, int completed) {
    if (total == 0) return "neutral 😐";
    if (completed == 0) return "sad 😞";
    if (completed == total) return "great 😄";
    if (completed >= total / 2) return "good 🙂";
    return "neutral 😐";
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final didAutoEnd = await ref
          .read(taskProvider.notifier)
          .checkAndAutoEndDay();

      if (didAutoEnd && mounted) {
        ref.invalidate(taskProvider);
        ref.invalidate(userProvider);

        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Previous day ended automatically 🌙")),
        );
      }
    });
  }

  void showStreakPopup(int streak) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 420,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Lottie.asset(
                    "assets/streak.json",
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Congratulations! 🎉",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  "You're on a $streak day streak 🔥",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Awesome!"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final total = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;

    final progress = total == 0 ? 0.0 : completed / total;
    final allTasksCompleted = total > 0 && completed == total;

    final mood = getMood(total, completed);

    final xpRequired = user.level * 150;
    final xpProgress = user.xp / xpRequired;

    final currentDay = ref.read(taskProvider.notifier).getCurrentAppDay();

    /// 🎉 Trigger Confetti ONLY ONCE
    if (allTasksCompleted && !_confettiPlayed) {
      Future.microtask(() {
        setState(() {
          _showConfetti = true;
          _confettiPlayed = true;
        });

        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() {
              _showConfetti = false;
            });
          }
        });
      });
    }

    /// 🔄 Reset when tasks become incomplete
    if (!allTasksCompleted && _confettiPlayed) {
      Future.microtask(() {
        setState(() {
          _confettiPlayed = false;
        });
      });
    }

    return Scaffold(
      appBar: const TopBar(),
      drawer: const AppDrawer(),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔵 Greeting + Streak Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Hi Ronit!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          /// 🔥 Streak
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${user.streak}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "How are you feeling today?",
                        style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "I'm feeling $mood",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                ///debug - day
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    "📅 App Day: ${currentDay.day}/${currentDay.month}/${currentDay.year}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// 🟣 Level Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          "${user.level}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Level Progress",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 4),

                            LinearProgressIndicator(value: xpProgress),

                            const SizedBox(height: 2),

                            Text("${user.xp} / $xpRequired XP"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 📊 Daily Progress
                const Text(
                  "Today's Progress",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 8,
                        child: LinearProgressIndicator(value: progress),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("${(progress * 100).toInt()}%"),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Tasks for today",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// 📋 Task List
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
                                child: Lottie.asset("assets/empty.json"),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "No tasks added for today 😕",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];

                            return CheckboxListTile(
                              value: task.isCompleted,
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              onChanged: (_) {
                                ref
                                    .read(taskProvider.notifier)
                                    .toggleTask(index);
                              },
                            );
                          },
                        ),
                ),

                /// 🔘 Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddTaskScreen(),
                            ),
                          );
                        },
                        child: const Text("Add Task"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("End your day?"),
                              content: const Text(
                                "This will save your progress and reset today's tasks.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),

                                ElevatedButton(
                                  onPressed: () async {
                                    final streakBefore = user.streak;

                                    await ref
                                        .read(taskProvider.notifier)
                                        .endDay();

                                    if (!mounted) return;

                                    ref.invalidate(taskProvider);
                                    ref.invalidate(userProvider);

                                    Navigator.pop(context);

                                    setState(() {});

                                    Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () {
                                        final updatedUser = ref.read(
                                          userProvider,
                                        );

                                        if (updatedUser != null &&
                                            updatedUser.streak > streakBefore) {
                                          showStreakPopup(updatedUser.streak);
                                        }
                                      },
                                    );
                                  },

                                  child: const Text("End Day"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text("End Day"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// 🎊 CONFETTI OVERLAY
          if (_showConfetti)
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: SizedBox(
                  height: 260,
                  child: Lottie.asset(
                    "assets/confetti.json",
                    repeat: false,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
