import '../../../core/supabase/supabase.dart';

import '../models/current_user.dart';
import 'current_user_repository.dart';

class SupabaseCurrentUserRepository implements CurrentUserRepository {
  @override
  Future<CurrentUser> getCurrentUser() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("No authenticated user.");
    }

    final result = await supabase.rpc('get_current_user');

    return CurrentUser.fromMap(Map<String, dynamic>.from(result));
  }
}
