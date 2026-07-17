import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../repositories/supabase_task_repository.dart';
import '../repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return SupabaseTaskRepository();
});

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, List<TaskModel>>(TaskController.new);
