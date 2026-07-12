import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase.dart';
import 'auth_repo.dart';

class SupabaseAuthRepository implements AuthRepository {
  @override
  User? get currentUser => supabase.auth.currentUser;

  @override
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) {
    return supabase.auth.signUp(email: email, password: password);
  }

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return supabase.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return supabase.auth.signOut();
  }
}
