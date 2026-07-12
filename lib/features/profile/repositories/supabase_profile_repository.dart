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
}
