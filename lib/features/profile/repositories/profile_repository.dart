import 'package:levelup_app/features/profile/models/profile_model.dart';

abstract class ProfileRepository {
  Future<bool> profileExists(String userId);

  Future<void> createProfile({
    required String displayName,
    required String avatarSeed,
  });

  Future<ProfileModel> getProfile();
}
