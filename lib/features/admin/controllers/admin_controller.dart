import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_user.dart';
import '../providers/admin_provider.dart';

class AdminController extends AsyncNotifier<List<AdminUser>> {
  @override
  Future<List<AdminUser>> build() {
    return ref.read(adminRepositoryProvider).getMembers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(adminRepositoryProvider).getMembers(),
    );
  }
}
