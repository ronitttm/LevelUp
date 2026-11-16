import 'package:levelup_app/features/admin/models/admin_user.dart';

abstract class AdminRepository {
  Future<List<AdminUser>> getMembers();

  Future<void> assignTask({
    required String memberId,
    required String title,
    required String difficulty,
    required DateTime taskDate,
  });
}
