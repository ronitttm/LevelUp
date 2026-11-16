import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/startup_repository.dart';
import '../repositories/supabase_startup_repository.dart';

final startupRepositoryProvider = Provider<StartupRepository>((ref) {
  return SupabaseStartupRepository();
});
