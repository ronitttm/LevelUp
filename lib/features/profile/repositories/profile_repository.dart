abstract class ProfileRepository {
  Future<bool> profileExists(String userId);

  Future<void> createProfile({
    required String displayName,
    required String avatarSeed,
  });
}
