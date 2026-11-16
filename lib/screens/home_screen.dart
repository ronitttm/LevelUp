import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/current_user/providers/current_user_provider.dart';
import 'package:levelup_app/features/startup/models/startup_model.dart';
import 'package:levelup_app/features/startup/controllers/startup_controller.dart';
import 'package:levelup_app/features/day_summaries/providers/summary_provider.dart';
import 'package:levelup_app/features/tasks/providers/tasks_for_date_provider.dart';
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
  final StartupResult? startupResult;

  const HomeScreen({super.key, this.startupResult});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Timer? _dayTimer;
  DateTime _syncedDay = DateUtils.dateOnly(DateTime.now());
  bool _syncingDay = false;

  @override
  void initState() {
    debugPrint("🏠 HomeScreen init: ${identityHashCode(this)}");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scheduleDayCheck();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final result = widget.startupResult;

      if (result?.hasMessage ?? false) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result!.message!)));
      }
    });
  }

  void _scheduleDayCheck([Duration? delay]) {
    _dayTimer?.cancel();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    final untilMidnight = nextDay.difference(now);
    final nextCheck = untilMidnight < const Duration(minutes: 1)
        ? untilMidnight
        : const Duration(minutes: 1);
    _dayTimer = Timer(delay ?? nextCheck, _checkDay);
  }

  Future<void> _checkDay() async {
    if (_syncingDay || !mounted) return;
    final today = DateUtils.dateOnly(DateTime.now());
    if (today == _syncedDay) {
      _scheduleDayCheck();
      return;
    }
    _syncingDay = true;
    try {
      final result = await ref
          .read(startupControllerProvider.notifier)
          .initializeApp();
      if (!mounted) return;
      if (DateUtils.dateOnly(DateTime.now()) != today) {
        _scheduleDayCheck(Duration.zero);
        return;
      }
      _syncedDay = today;
      ref.invalidate(currentUserProvider);
      ref.invalidate(taskControllerProvider);
      ref.invalidate(daySummaryControllerProvider);
      ref.invalidate(tasksForDateProvider);
      if (result.hasMessage) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message!)));
      }
      _scheduleDayCheck();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not update the new day. Retrying shortly.'),
          ),
        );
        _scheduleDayCheck(const Duration(minutes: 1));
      }
    } finally {
      _syncingDay = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkDay();
  }

  @override
  void dispose() {
    _dayTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskControllerProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

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

                        Expanded(child: TaskList(tasks: tasks)),

                        /// 🔘 Buttons
                        BottomButtons(
                          hasEndedToday: user.hasEndedToday,
                          hasTasksToday: tasks.isNotEmpty,
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
