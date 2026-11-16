import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_model.dart';
import 'profile_repository_provider.dart';

final profileProvider = FutureProvider<ProfileModel>((ref) {
  return ref.read(profileRepositoryProvider).getProfile();
});
