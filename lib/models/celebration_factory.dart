import 'package:flutter/material.dart';

import 'celebration_event.dart';

class CelebrationFactory {
  static CelebrationEvent allTasksCompleted() {
    return const CelebrationEvent(
      id: "all_tasks_completed",
      title: "Daily Quest Complete! 🎉",
      subtitle: "Every task conquered today.",
      animation: "assets/animations/confetti.json",
      primaryColor: Colors.green,
      icon: Icons.task_alt,
    );
  }

  static CelebrationEvent firstTaskCompleted() {
    return const CelebrationEvent(
      id: "first_task_completed",
      title: "Great Start!",
      subtitle: "Momentum begins with one task.",
      animation: "assets/animations/confetti.json",
      primaryColor: Colors.blue,
      icon: Icons.flag,
    );
  }

  static CelebrationEvent levelUp(int level) {
    return CelebrationEvent(
      id: "level_up_$level",
      title: "LEVEL $level!",
      subtitle: "You're becoming unstoppable ⭐",
      animation: "assets/animations/levelup.json",
      primaryColor: Colors.amber,
      icon: Icons.auto_awesome,
    );
  }

  static CelebrationEvent streak(int streak) {
    String title = "Streak Increased!";
    String subtitle = "$streak days of consistency 🔥";

    if (streak == 7) {
      title = "7 Day Streak!";
      subtitle = "You're building a real habit!";
    }

    if (streak == 30) {
      title = "30 Day Legend!";
      subtitle = "This deserves respect 👑";
    }

    if (streak >= 100) {
      title = "100 Day Beast!";
      subtitle = "You're in the top 1%.";
    }

    return CelebrationEvent(
      id: "streak_$streak",
      title: title,
      subtitle: subtitle,
      animation: "assets/animations/streak.json",
      primaryColor: Colors.orange,
      icon: Icons.local_fire_department,
    );
  }

  // static CelebrationEvent achievement(String title, String subtitle) {
  //   return CelebrationEvent(
  //     id: "achievement_${DateTime.now().millisecondsSinceEpoch}",
  //     title: title,
  //     subtitle: subtitle,
  //     animation: "assets/animations/confetti.json",
  //     primaryColor: Colors.indigo,
  //     icon: Icons.workspace_premium,
  //   );
  // }
}
