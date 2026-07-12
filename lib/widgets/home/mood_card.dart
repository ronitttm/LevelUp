import 'package:flutter/material.dart';

import '../../utils/mood_utils.dart';

class MoodCard extends StatelessWidget {
  final MoodType mood;

  const MoodCard({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    final isSmall = width < 360;
    final isTablet = width > 700;

    return Container(
      height: height * 0.25,
      padding: EdgeInsets.all(width * 0.015),
      decoration: BoxDecoration(
        color: moodBackground(mood),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),

          child: TweenAnimationBuilder<double>(
            key: ValueKey(mood),

            tween: Tween(begin: 0.85, end: 1),

            duration: const Duration(milliseconds: 800),

            curve: Curves.easeOutBack,

            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },

            child: Image.asset(
              moodImage(mood),

              height: isTablet
                  ? 220
                  : isSmall
                  ? 120
                  : 165,

              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
