import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/current_user_repository.dart';
import '../repositories/supabase_current_user_repository.dart';

final currentUserRepositoryProvider = Provider<CurrentUserRepository>((ref) {
  return SupabaseCurrentUserRepository();
});
