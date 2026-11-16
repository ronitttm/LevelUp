import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/current_user/providers/current_user_provider.dart';
import 'package:levelup_app/features/day_summaries/providers/summary_provider.dart';
import 'package:levelup_app/features/tasks/models/end_day_result.dart';
import 'package:levelup_app/features/tasks/providers/task_provider.dart';
import 'package:levelup_app/features/tasks/providers/tasks_for_date_provider.dart';
import 'package:levelup_app/services/celebration_service.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskController extends AsyncNotifier<List<TaskModel>> {
  TaskRepository get _repository => ref.read(taskRepositoryProvider);
  int _refreshVersion = 0;

  @override
  Future<List<TaskModel>> build() async {
    _refreshVersion++;
    debugPrint("🟢 TaskController build: ${identityHashCode(this)}");
    return _repository.getTasks();
  }

  /// Refresh today's tasks
  Future<void> refresh() async {
    final version = ++_refreshVersion;
    state = const AsyncLoading();

    final result = await AsyncValue.guard(() => _repository.getTasks());
    if (version == _refreshVersion) state = result;
  }

  /// Create task
  Future<void> createTask({
    required String title,
    required String difficulty,
  }) async {
    final currentUser = ref.read(currentUserProvider).value;

    if (currentUser == null) {
      throw Exception("Unable to load user.");
    }

    if (currentUser.hasEndedToday) {
      throw Exception("You have already ended your day.");
    }
    await _repository.createTask(title: title, difficulty: difficulty);

    ref.invalidate(tasksForDateProvider);
    await refresh();
  }

  Future<void> completeTask({
    required String taskId,
    String? reflection,
  }) async {
    final currentUser = ref.read(currentUserProvider).value;

    if (currentUser == null) {
      throw Exception("Unable to load user.");
    }

    if (currentUser.hasEndedToday) {
      throw Exception("You have already ended your day.");
    }
    final previousTasks = state.valueOrNull;
    final wasIncomplete =
        previousTasks?.any((task) => task.id == taskId && !task.completed) ??
        false;
    await _repository.completeTask(taskId: taskId, reflection: reflection);

    ref.invalidate(tasksForDateProvider);
    ref.invalidate(currentUserProvider);

    await refresh();
    final tasks = state.valueOrNull;
    if (wasIncomplete &&
        tasks != null &&
        tasks.isNotEmpty &&
        tasks.every((task) => task.completed)) {
      ref.read(celebrationServiceProvider).allTasksCompleted();
    }
  }

  /// Soft delete
  Future<void> deleteTask(String taskId) async {
    final currentUser = ref.read(currentUserProvider).value;

    if (currentUser == null) {
      throw Exception("Unable to load user.");
    }

    if (currentUser.hasEndedToday) {
      throw Exception("You have already ended your day.");
    }
    await _repository.deleteTask(taskId);

    ref.invalidate(tasksForDateProvider);
    await refresh();
  }

  ///End day
  Future<EndDayResult> endDay() async {
    final result = await _repository.endDay();

    ref.invalidate(tasksForDateProvider);
    ref.invalidate(currentUserProvider);

    // Refresh the summaries
    await ref.read(daySummaryControllerProvider.notifier).refresh();

    await refresh();

    return result;
  }
}
