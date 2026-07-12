import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../features/auth/models/startup_destination.dart';
import '../features/auth/providers/auth_controller.dart';
import '../features/auth/screens/auth_screen.dart';
import '../features/auth/screens/onboarding_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _animationFinished = false;
  bool _startupFinished = false;

  StartupDestination? _destination;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationFinished = true;
        _tryNavigate();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _determineStartupDestination();
    });
  }

  Future<void> _determineStartupDestination() async {
    _destination = await ref
        .read(authControllerProvider.notifier)
        .determineStartupDestination();

    _startupFinished = true;

    _tryNavigate();
  }

  void _tryNavigate() {
    if (!_animationFinished) return;
    if (!_startupFinished) return;
    if (!mounted) return;

    Widget nextScreen;

    switch (_destination!) {
      case StartupDestination.login:
        nextScreen = const AuthScreen();
        break;

      case StartupDestination.onboarding:
        nextScreen = const OnboardingScreen();
        break;

      case StartupDestination.home:
        nextScreen = const HomeScreen();
        break;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, animation, __) => nextScreen,
        transitionsBuilder: (_, animation, __, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutExpo,
          );

          final slide = Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(fade);

          final scale = Tween<double>(begin: 0.96, end: 1).animate(fade);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: ScaleTransition(scale: scale, child: child),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          "assets/animations/rocket.json",
          controller: _controller,
          repeat: false,
          onLoaded: (composition) {
            _controller.duration = Duration(
              milliseconds: (composition.duration.inMilliseconds * 0.55)
                  .toInt(),
            );

            _controller.forward();
          },
        ),
      ),
    );
  }
}
