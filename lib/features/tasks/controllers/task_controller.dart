import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:levelup_app/features/current_user/providers/current_user_provider.dart';
import 'package:levelup_app/features/tasks/models/end_day_result.dart';
import 'package:levelup_app/features/tasks/providers/task_provider.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskController extends AsyncNotifier<List<TaskModel>> {
  late final TaskRepository _repository;

  @override
  Future<List<TaskModel>> build() async {
    _repository = ref.read(taskRepositoryProvider);

    return _repository.getTasks();
  }

  /// Refresh today's tasks
  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => _repository.getTasks());
  }

  /// Create task
  Future<void> createTask({
    required String title,
    required String difficulty,
  }) async {
    await _repository.createTask(title: title, difficulty: difficulty);

    await refresh();
  }

  Future<void> completeTask({
    required String taskId,
    String? reflection,
  }) async {
    await _repository.completeTask(taskId: taskId, reflection: reflection);

    ref.invalidate(currentUserProvider);

    await refresh();
  }

  /// Soft delete
  Future<void> deleteTask(String taskId) async {
    await _repository.deleteTask(taskId);

    await refresh();
  }

  ///End day
  Future<EndDayResult> endDay() async {
    final result = await _repository.endDay();

    ref.invalidate(currentUserProvider);

    await refresh();

    return result;
  }

  ///Auto end day
  Future<bool> checkAndAutoEndDay() async {
    final didAutoEnd = await _repository.checkAndAutoEndDay();

    if (didAutoEnd) {
      ref.invalidate(currentUserProvider);
      await refresh();
    }

    return didAutoEnd;
  }
}
