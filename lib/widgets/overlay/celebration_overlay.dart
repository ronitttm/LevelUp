import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../providers/celebration_provider.dart';

class CelebrationOverlay extends ConsumerStatefulWidget {
  const CelebrationOverlay({super.key});

  @override
  ConsumerState<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends ConsumerState<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  Timer? _timer;

  String? _currentId;

  late final AnimationController _controller;

  late final Animation<double> _fade;

  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _scale = Tween(
      begin: .85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(celebrationProvider);

    final notifier = ref.read(celebrationProvider.notifier);

    if (queue.isEmpty) {
      _timer?.cancel();

      _currentId = null;

      _controller.reset();

      return const SizedBox.shrink();
    }

    final current = queue.first;

    if (_currentId != current.id) {
      _currentId = current.id;

      _timer?.cancel();

      _controller.forward(from: 0);

      _timer = Timer(current.duration, () async {
        await _controller.reverse();

        notifier.dequeue();
      });
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Dark overlay
            AnimatedBuilder(
              animation: _fade,
              builder: (_, __) {
                return Container(
                  color: Colors.black.withValues(alpha: .25 * _fade.value),
                );
              },
            ),

            /// Celebration card
            FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 330,

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        color: current.primaryColor.withValues(alpha: .35),
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: current.primaryColor.withValues(
                          alpha: .15,
                        ),

                        child: Icon(
                          current.icon,
                          color: current.primaryColor,
                          size: 34,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 180,
                        child: Lottie.asset(current.animation, repeat: false),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        current.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        current.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    _controller.dispose();

    super.dispose();
  }
}
