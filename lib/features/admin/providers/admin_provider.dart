import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/admin_controller.dart';
import '../models/admin_user.dart';
import '../repositories/admin_repository.dart';
import '../repositories/supabase_admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return SupabaseAdminRepository();
});

final adminControllerProvider =
    AsyncNotifierProvider<AdminController, List<AdminUser>>(
      AdminController.new,
    );

final membersProvider = FutureProvider<List<AdminUser>>((ref) async {
  return ref.read(adminRepositoryProvider).getMembers();
});
