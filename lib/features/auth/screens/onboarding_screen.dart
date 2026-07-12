import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/providers/onboarding_controller.dart';
import '../../../screens/home_screen.dart';
import '../../../core/utils/avatar_utils.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);

    final isLoading = state.isSubmitting;

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 700;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : double.infinity,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: state.selectedAvatarSeed == null
                    ? _buildAvatarSelection(state, isLoading)
                    : _buildProfileSetup(state, isLoading),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSelection(OnboardingState state, bool isLoading) {
    return Card(
      key: const ValueKey("avatar_selection"),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.auto_awesome, size: 60),

            const SizedBox(height: 20),

            const Text(
              "Choose Your Companion",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              "Click an avatar to choose your character.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 32),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.avatarSeeds.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final seed = state.avatarSeeds[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: isLoading
                      ? null
                      : () {
                          ref
                              .read(onboardingControllerProvider.notifier)
                              .selectAvatar(seed);
                        },
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(AvatarUtils.url(seed)),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            OutlinedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .generateAnotherSet();
                    },
              icon: const Icon(Icons.refresh),
              label: const Text("Generate Another Set"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSetup(OnboardingState state, bool isLoading) {
    return Card(
      key: const ValueKey("profile_setup"),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(
                      AvatarUtils.url(state.selectedAvatarSeed!),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Great choice! 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Your companion is ready.\nNow let's create your LevelUp profile.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),

              const SizedBox(height: 32),

              TextFormField(
                controller: _displayNameController,
                enabled: !isLoading,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Display Name",
                  hintText: "What should we call you?",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your display name.";
                  }

                  if (value.trim().length < 2) {
                    return "Display name must be at least 2 characters.";
                  }

                  if (value.trim().length > 30) {
                    return "Display name can't exceed 30 characters.";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              TextButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                        ref
                            .read(onboardingControllerProvider.notifier)
                            .changeMind();
                      },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Changed your mind?"),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: isLoading ? null : _completeOnboarding,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.rocket_launch),
                  label: Text(
                    isLoading
                        ? "Creating your adventure..."
                        : "Let's Enter LevelUp",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref
          .read(onboardingControllerProvider.notifier)
          .completeOnboarding(displayName: _displayNameController.text.trim());

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().replaceFirst("Exception: ", "");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }
}
