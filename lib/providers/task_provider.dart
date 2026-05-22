import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'database_provider.dart';
import 'user_provider.dart';

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

  /// 🔹 ADD TASK
  Future<void> addTask(
    String title, {
    int points = 10,
    String difficulty = 'medium',
  }) async {
    final currentDay = getCurrentAppDay();

    await db
        .into(db.tasks)
        .insert(
          TasksCompanion.insert(
            title: title,
            points: Value(points),
            difficulty: Value(difficulty),
            createdAt: DateTime.now(),
            appDay: currentDay,
          ),
        );

    await loadTasks();
  }

  /// 🔹 TOGGLE TASK
  Future<void> toggleTask(int index) async {
    final task = state[index];

    final newValue = !task.isCompleted;

    if (newValue && !task.xpClaimed) {
      ref.read(userProvider.notifier).addXP(task.points);
    }

    await (db.update(db.tasks)..where((tbl) => tbl.id.equals(task.id))).write(
      TasksCompanion(
        isCompleted: Value(newValue),
        completedAt: Value(newValue ? DateTime.now() : null),
        xpClaimed: Value(task.xpClaimed || newValue),
      ),
    );

    await loadTasks();
  }

  /// 🔹 DELETE TASK
  Future<void> deleteTask(int index) async {
    final task = state[index];

    await (db.delete(db.tasks)..where((tbl) => tbl.id.equals(task.id))).go();

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
      ref.read(userProvider.notifier).increaseStreak();
    } else {
      ref.read(userProvider.notifier).resetStreak();
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
              xpEarned: completedTasks * 10,
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
