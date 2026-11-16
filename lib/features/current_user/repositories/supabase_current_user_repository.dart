import 'package:flutter/material.dart';

import '../../../core/supabase/supabase.dart';

import '../models/current_user.dart';
import 'current_user_repository.dart';

class SupabaseCurrentUserRepository implements CurrentUserRepository {
  @override
  Future<CurrentUser> getCurrentUser() async {
    debugPrint("🔥 API -> get current user");
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("No authenticated user.");
    }
    final today = DateTime.now();
    final result = await supabase.rpc(
      'get_current_user',
      params: {
        'p_today':
            "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}",
      },
    );

    return CurrentUser.fromMap(Map<String, dynamic>.from(result));
  }
}
