import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/current_user/providers/current_user_provider.dart';
import 'package:levelup_app/widgets/common/app_drawer.dart';

import '../features/tasks/providers/task_provider.dart';

import '../widgets/common/top_bar.dart';
import 'add_task_screen.dart';

///Home screen widgets
import '../widgets/home/greeting_card.dart';
import '../widgets/home/mood_card.dart';
import '../widgets/home/xp_card.dart';
import '../widgets/home/progress_card.dart';
import '../widgets/home/task_list.dart';
import '../widgets/home/bottom_buttons.dart';
import '../widgets/overlay/celebration_overlay.dart';
import '../widgets/dialog/end_day_dialog.dart';

import '../utils/mood_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await ref
          .read(taskControllerProvider.notifier)
          .syncUserDay();

      if (!mounted) return;

      String? message;

      if (result.autoEnded && result.streakReset) {
        message =
            "🌙 Yesterday was automatically ended. 🔥 Your streak has been reset.";
      } else if (result.autoEnded) {
        message = "🌙 Yesterday was automatically ended.";
      } else if (result.streakReset) {
        message = "🔥 Your streak has been reset after missing several days.";
      }

      if (message != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskControllerProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final isSmall = width < 360;
    final isTablet = width > 700;
    final currentDay = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return currentUserAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text(error.toString()))),
      data: (user) {
        return tasksAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),

          error: (error, stack) =>
              Scaffold(body: Center(child: Text(error.toString()))),

          data: (tasks) {
            final total = tasks.length;

            final completed = tasks.where((t) => t.completed).length;

            final progress = total == 0 ? 0.0 : completed / total;

            final mood = getMood(total, completed);
            // existing Scaffold goes here
            return Scaffold(
              appBar: const TopBar(),

              drawer: const AppDrawer(),
              body: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04,
                      vertical: height * 0.015,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// GREETING CARD
                            Expanded(
                              flex: 5,
                              child: GreetingCard(
                                userName: user
                                    .displayName, // or user.name if you add it later
                                streak: user.currentStreak,
                                currentDay: currentDay,
                              ),
                            ),

                            SizedBox(width: width * 0.03),

                            /// CAT CARD
                            Expanded(flex: 4, child: MoodCard(mood: mood)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Level card
                        XPCard(level: user.level, xp: user.xp),

                        const SizedBox(height: 16),

                        /// 📊 Daily Progress
                        ProgressCard(
                          progress: progress,
                          completedTasks: completed,
                          totalTasks: total,
                        ),

                        const SizedBox(height: 12),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tasks for Today",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Expanded(child: TaskList()),

                        /// 🔘 Buttons
                        BottomButtons(
                          hasEndedToday: user.hasEndedToday,

                          onAddTask: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddTaskScreen(),
                              ),
                            );
                          },

                          onEndDay: () {
                            showDialog(
                              context: context,
                              builder: (_) => const EndDayDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  /// celebration overlay
                  const CelebrationOverlay(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
