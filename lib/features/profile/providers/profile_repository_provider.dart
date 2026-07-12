import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/profile_repository.dart';
import '../repositories/supabase_profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return SupabaseProfileRepository();
});
