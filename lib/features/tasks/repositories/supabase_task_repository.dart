import 'package:levelup_app/features/tasks/models/end_day_result.dart';

import '../../../core/supabase/supabase.dart';

import '../models/task_model.dart';
import 'task_repository.dart';

class SupabaseTaskRepository implements TaskRepository {
  @override
  Future<List<TaskModel>> getTasks() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated.");
    }

    final today = DateTime.now();
    final todayString = DateTime(
      today.year,
      today.month,
      today.day,
    ).toIso8601String().split('T').first;

    final response = await supabase
        .from('tasks')
        .select()
        .eq('user_id', user.id)
        .eq('task_date', todayString)
        .eq('is_deleted', false)
        .order('completed')
        .order('created_at');

    return response.map<TaskModel>((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<void> createTask({
    required String title,
    required String difficulty,
  }) async {
    final user = supabase.auth.currentUser;
    final today = DateTime.now();

    if (user == null) {
      throw Exception("User not authenticated.");
    }

    await supabase.from('tasks').insert({
      'user_id': user.id,
      'title': title,
      'difficulty': difficulty,
      'task_date':
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}",
    });
  }

  @override
  Future<void> completeTask({
    required String taskId,
    required String? reflection,
  }) async {
    await supabase.rpc(
      'complete_task',
      params: {'p_task_id': taskId, 'p_reflection': reflection},
    );
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await supabase.from('tasks').update({'is_deleted': true}).eq('id', taskId);
  }

  @override
  Future<EndDayResult> endDay({DateTime? date}) async {
    final targetDate = date ?? DateTime.now();

    final dateString =
        "${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}";

    final json = await supabase.rpc('end_day', params: {'p_date': dateString});

    return EndDayResult.fromJson(Map<String, dynamic>.from(json));
  }

  @override
  Future<bool> checkAndAutoEndDay() async {
    final today = DateTime.now();

    final yesterday = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 1));

    final summary = await supabase
        .from('day_summaries')
        .select('id')
        .eq('date', yesterday.toIso8601String().split('T').first)
        .maybeSingle();

    if (summary != null) {
      return false;
    }

    await endDay();

    return true;
  }
}
