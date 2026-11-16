import 'package:flutter/material.dart';

import '../../../core/supabase/supabase.dart';
import '../models/admin_user.dart';
import 'admin_repository.dart';

class SupabaseAdminRepository implements AdminRepository {
  @override
  Future<List<AdminUser>> getMembers() async {
    debugPrint("🔥 API -> get members");

    final response = await supabase
        .from('profiles')
        .select('id, display_name, avatar_seed, role')
        .eq('role', 'member')
        .order('display_name');

    return response.map<AdminUser>((e) => AdminUser.fromMap(e)).toList();
  }

  @override
  Future<void> assignTask({
    required String memberId,
    required String title,
    required String difficulty,
    required DateTime taskDate,
  }) async {
    await supabase.rpc(
      'assign_task',
      params: {
        'p_member_id': memberId,
        'p_title': title,
        'p_difficulty': difficulty,
        'p_task_date': taskDate.toIso8601String().split('T').first,
      },
    );
  }
}
