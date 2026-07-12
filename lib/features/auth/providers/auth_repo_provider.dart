import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/auth_repo.dart';
import '../repositories/supabase_auth_repo.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository();
});
