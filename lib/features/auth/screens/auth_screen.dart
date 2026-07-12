import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_loading_button.dart';
import '../../../core/widgets/app_text_field.dart';

import '../models/auth_mode.dart';
import '../models/auth_result.dart';
import '../models/startup_destination.dart';
import '../providers/auth_controller.dart';

import '../../auth/screens/onboarding_screen.dart';
import '../../../screens/home_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  AuthMode _mode = AuthMode.login;

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  bool get isLogin => _mode == AuthMode.login;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    final isLoading = authState.isLoading;

    final size = MediaQuery.of(context).size;

    final width = size.width;

    final isTablet = width > 700;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 450 : double.infinity,
              ),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.rocket_launch_rounded, size: 72),

                        const SizedBox(height: 20),

                        const Text(
                          "LevelUp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          isLogin ? "Welcome back!" : "Create your account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 32),

                        AppTextField(
                          controller: _emailController,
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email is required";
                            }

                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

                            if (!emailRegex.hasMatch(value.trim())) {
                              return "Enter a valid email";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: _passwordValidator,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        if (!isLogin) ...[
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            validator: _confirmPasswordValidator,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),

                        AppLoadingButton(
                          isLoading: isLoading,
                          text: "Continue",
                          onPressed: isLoading ? null : _submit,
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLogin
                                  ? "Don't have an account?"
                                  : "Already have an account?",
                            ),

                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _mode = isLogin
                                      ? AuthMode.signup
                                      : AuthMode.login;
                                });
                              },
                              child: Text(isLogin ? "Create one" : "Login"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final result = await ref
          .read(authControllerProvider.notifier)
          .submit(
            mode: _mode,
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!mounted) return;

      switch (result) {
        case AuthResult.loginSuccess:
          final destination = await ref
              .read(authControllerProvider.notifier)
              .determineStartupDestination();

          if (!mounted) return;

          switch (destination) {
            case StartupDestination.login:
              break;

            case StartupDestination.onboarding:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              );
              break;

            case StartupDestination.home:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
              break;
          }

          break;

        case AuthResult.signupSuccess:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
          break;
      }
    } catch (e) {
      String message = "Something went wrong.";

      final error = e.toString().toLowerCase();

      if (error.contains("invalid login credentials")) {
        message = "Invalid email or password.";
      } else if (error.contains("user already registered")) {
        message = "An account with this email already exists.";
      } else if (error.contains("email not confirmed")) {
        message = "Please verify your email before signing in.";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (isLogin) return null;

    if (value == null || value.isEmpty) {
      return "Please confirm your password";
    }

    if (value != _passwordController.text) {
      return "Passwords do not match";
    }

    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
