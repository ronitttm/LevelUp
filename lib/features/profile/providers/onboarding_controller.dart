import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../repositories/profile_repository.dart';
import 'profile_repository_provider.dart';

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
      OnboardingController.new,
    );

class OnboardingController extends Notifier<OnboardingState> {
  late final ProfileRepository _repository;

  final _uuid = const Uuid();

  @override
  OnboardingState build() {
    _repository = ref.read(profileRepositoryProvider);

    return OnboardingState(
      avatarSeeds: _generateAvatarSeeds(),
      selectedAvatarSeed: null,
    );
  }

  List<String> _generateAvatarSeeds() {
    return List.generate(6, (_) => _uuid.v4());
  }

  void generateAnotherSet() {
    state = state.copyWith(
      avatarSeeds: _generateAvatarSeeds(),
      selectedAvatarSeed: null,
    );
  }

  void selectAvatar(String seed) {
    state = state.copyWith(selectedAvatarSeed: seed);
  }

  void changeMind() {
    state = state.copyWith(
      avatarSeeds: _generateAvatarSeeds(),
      selectedAvatarSeed: null,
    );
  }

  Future<void> completeOnboarding({required String displayName}) async {
    if (state.selectedAvatarSeed == null) {
      throw Exception("Please choose your companion.");
    }

    state = state.copyWith(isSubmitting: true);

    try {
      await _repository.createProfile(
        displayName: displayName,
        avatarSeed: state.selectedAvatarSeed!,
      );
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

class OnboardingState {
  static const _unset = Object();

  final List<String> avatarSeeds;
  final String? selectedAvatarSeed;
  final bool isSubmitting;

  const OnboardingState({
    required this.avatarSeeds,
    required this.selectedAvatarSeed,
    this.isSubmitting = false,
  });

  OnboardingState copyWith({
    List<String>? avatarSeeds,
    Object? selectedAvatarSeed = _unset,
    bool? isSubmitting,
  }) {
    return OnboardingState(
      avatarSeeds: avatarSeeds ?? this.avatarSeeds,
      selectedAvatarSeed: identical(selectedAvatarSeed, _unset)
          ? this.selectedAvatarSeed
          : selectedAvatarSeed as String?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
