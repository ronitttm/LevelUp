import 'package:levelup_app/features/profile/models/profile_model.dart';

import '../../../core/supabase/supabase.dart';
import 'profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  @override
  Future<bool> profileExists(String userId) async {
    final response = await supabase
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    return response != null;
  }

  @override
  Future<ProfileModel> getProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final response = await supabase
        .from("profiles")
        .select()
        .eq("id", user.id)
        .single();

    return ProfileModel.fromJson(response);
  }

  @override
  Future<void> createProfile({
    required String displayName,
    required String avatarSeed,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated.");
    }

    await supabase.rpc(
      'complete_onboarding',
      params: {'p_display_name': displayName, 'p_avatar_seed': avatarSeed},
    );
  }
}
