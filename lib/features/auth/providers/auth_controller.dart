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
  late final AuthRepository _authRepository;
  late final ProfileRepository _profileRepository;

  @override
  Future<void> build() async {
    _authRepository = ref.read(authRepositoryProvider);
    _profileRepository = ref.read(profileRepositoryProvider);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.signOut();
    });
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
          await _authRepository.signUp(email: email, password: password);
          state = const AsyncData(null);
          return AuthResult.signupSuccess;
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
