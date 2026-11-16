import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';
import 'task_provider.dart';

final tasksForDateProvider = FutureProvider.family<List<TaskModel>, DateTime>((
  ref,
  date,
) async {
  final repo = ref.read(taskRepositoryProvider);

  return await repo.getTasksForDate(date);
});
