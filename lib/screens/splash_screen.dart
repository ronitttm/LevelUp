import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (_, animation, __) => const HomeScreen(),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          "assets/rocket.json",
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
