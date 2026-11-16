import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/providers/profile_repository_provider.dart';
import '../../profile/repositories/profile_repository.dart';
import '../models/startup_destination.dart';
import '../repositories/auth_repo.dart';
import 'auth_repo_provider.dart';
import '../models/auth_mode.dart';
import '../models/auth_result.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  ProfileRepository get _profileRepository =>
      ref.read(profileRepositoryProvider);

  @override
  Future<void> build() async {
    print("OnboardingController build");
    // Repositories are accessed lazily via getters.
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _authRepository.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<StartupDestination> determineStartupDestination() async {
    final user = _authRepository.currentUser;

    if (user == null) {
      return StartupDestination.login;
    }

    final hasProfile = await _profileRepository.profileExists(user.id);

    if (!hasProfile) {
      return StartupDestination.onboarding;
    }

    return StartupDestination.home;
  }

  Future<AuthResult> submit({
    required AuthMode mode,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      switch (mode) {
        case AuthMode.login:
          await _authRepository.signIn(email: email, password: password);
          state = const AsyncData(null);
          return AuthResult.loginSuccess;

        case AuthMode.signup:
          final response = await _authRepository.signUp(
            email: email,
            password: password,
          );
          state = const AsyncData(null);
          return response.session == null
              ? AuthResult.verificationRequired
              : AuthResult.signupSuccess;
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
