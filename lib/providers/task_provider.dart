import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../services/celebration_service.dart';
import 'database_provider.dart';
import 'user_provider.dart';
import 'celebration_provider.dart';
import 'package:levelup_app/models/celebration_event.dart';

import '../utils/task_utils.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier(this.ref, this.db) : super([]) {
    loadTasks();
  }

  final Ref ref;
  final AppDatabase db;

  /// 🔹 SAFE APP DATE
  DateTime getCurrentAppDay() {
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day);
  }

  /// 🔹 LOAD TASKS
  Future<void> loadTasks() async {
    final currentDay = getCurrentAppDay();

    final tasks =
        await (db.select(db.tasks)
              ..where((tbl) => tbl.appDay.equals(currentDay))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.isCompleted,
                  mode: OrderingMode.asc,
                ),
                (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.asc,
                ),
              ]))
            .get();

    state = tasks;
  }

  ///Add tasks
  Future<void> addTask(String title, {String difficulty = "easy"}) async {
    final currentDay = getCurrentAppDay();

    await db
        .into(db.tasks)
        .insert(
          TasksCompanion.insert(
            title: title,
            difficulty: Value(difficulty),
            createdAt: DateTime.now(),
            appDay: currentDay,
          ),
        );

    await loadTasks();
  }

  ///submit tasks
  Future<void> submitTask(Task task, String reflection) async {
    if (task.isCompleted) return;

    final difficulty = TaskUtils.fromString(task.difficulty);

    final xp = TaskUtils.getXP(difficulty);

    if (!task.xpClaimed) {
      ref.read(userProvider.notifier).addXP(xp);
    }

    await (db.update(db.tasks)..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(
        isCompleted: const Value(true),

        reflection: Value(reflection.isEmpty ? null : reflection),

        completedAt: Value(DateTime.now()),

        xpClaimed: const Value(true),
      ),
    );

    await loadTasks();

    // 👇 Check if every task is completed
    if (state.isNotEmpty && state.every((task) => task.isCompleted)) {
      ref.read(celebrationServiceProvider).allTasksCompleted();
    }
  }

  /// 🔹 DELETE TASK
  Future<void> deleteTaskById(int id) async {
    await (db.delete(db.tasks)..where((tbl) => tbl.id.equals(id))).go();

    await loadTasks();
  }

  /// 🔥 END DAY
  Future<void> endDay() async {
    final currentDay = getCurrentAppDay();

    final tasks = await (db.select(
      db.tasks,
    )..where((tbl) => tbl.appDay.equals(currentDay))).get();

    final completedTasks = tasks.where((t) => t.isCompleted).length;

    final totalTasks = tasks.length;

    /// 🔥 streak
    if (completedTasks > 0) {
      await ref.read(userProvider.notifier).increaseStreak();

      final streak = ref.read(userProvider)?.streak ?? 0;

      ref.read(celebrationServiceProvider).streak(streak);
    } else {
      await ref.read(userProvider.notifier).resetStreak();
    }

    /// 🔥 mood
    String mood = "neutral";

    if (totalTasks == 0) {
      mood = "neutral";
    } else if (completedTasks == 0) {
      mood = "sad";
    } else if (completedTasks == totalTasks) {
      mood = "great";
    } else if (completedTasks >= totalTasks / 2) {
      mood = "good";
    }

    int totalXP = 0;

    for (final task in tasks) {
      if (task.isCompleted) {
        totalXP += TaskUtils.getXP(TaskUtils.fromString(task.difficulty));
      }
    }

    /// 🔥 prevent duplicate summaries
    final existingSummary = await (db.select(
      db.daySummaries,
    )..where((tbl) => tbl.date.equals(currentDay))).getSingleOrNull();

    if (existingSummary == null) {
      await db
          .into(db.daySummaries)
          .insert(
            DaySummariesCompanion.insert(
              date: currentDay,
              totalTasks: totalTasks,
              completedTasks: completedTasks,
              xpEarned: totalXP,
              mood: mood,
              streak: ref.read(userProvider)?.streak ?? 0,
              completedDay: completedTasks > 0,
            ),
          );
    }

    /// 🔥 reload state
    await loadTasks();
  }

  /// 🔹 AUTO END DAY
  Future<bool> checkAndAutoEndDay() async {
    return false;
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  final db = ref.read(databaseProvider);

  return TaskNotifier(ref, db);
});
