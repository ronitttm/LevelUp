import 'package:levelup_app/features/tasks/models/end_day_result.dart';
import '../models/sync_user_day_result.dart';

import '../models/task_model.dart';

abstract class TaskRepository {
  /// Fetch today's active tasks
  Future<List<TaskModel>> getTasks();

  /// Create a new task
  Future<void> createTask({required String title, required String difficulty});

  /// Complete a task
  Future<void> completeTask({
    required String taskId,
    required String? reflection,
  });

  /// Soft delete a task
  Future<void> deleteTask(String taskId);

  /// End the current day
  Future<EndDayResult> endDay({DateTime? date});

  Future<SyncUserDayResult> syncUserDay();
}
