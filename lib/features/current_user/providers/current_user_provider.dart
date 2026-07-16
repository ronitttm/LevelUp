import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/current_user.dart';
import 'current_user_repository_provider.dart';

final currentUserProvider = FutureProvider<CurrentUser>((ref) async {
  return ref.read(currentUserRepositoryProvider).getCurrentUser();
});
