import 'package:levelup_app/features/startup/models/startup_model.dart';

import '../../../core/supabase/supabase.dart';

import 'startup_repository.dart';

class SupabaseStartupRepository implements StartupRepository {
  @override
  Future<StartupResult> syncUserDay() async {
    final response = await supabase.rpc('sync_user_day');

    return StartupResult.fromJson(Map<String, dynamic>.from(response));
  }
}
