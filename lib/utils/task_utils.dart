import 'package:flutter/material.dart';

import '../models/task_difficulty.dart';

class TaskUtils {
  static int getXP(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return 5;

      case TaskDifficulty.moderate:
        return 10;

      case TaskDifficulty.hard:
        return 20;
    }
  }

  static Color getColor(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return Colors.green;

      case TaskDifficulty.moderate:
        return Colors.orange;

      case TaskDifficulty.hard:
        return Colors.red;
    }
  }

  static Color getBackgroundColor(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return Colors.green.shade100;

      case TaskDifficulty.moderate:
        return Colors.orange.shade100;

      case TaskDifficulty.hard:
        return Colors.red.shade100;
    }
  }

  static String getLabel(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return "Easy";

      case TaskDifficulty.moderate:
        return "Moderate";

      case TaskDifficulty.hard:
        return "Hard";
    }
  }

  static String getEmoji(TaskDifficulty difficulty) {
    switch (difficulty) {
      case TaskDifficulty.easy:
        return "🟢";
      case TaskDifficulty.moderate:
        return "🟠";
      case TaskDifficulty.hard:
        return "🔴";
    }
  }

  static TaskDifficulty fromString(String value) {
    switch (value.toLowerCase()) {
      case "easy":
        return TaskDifficulty.easy;

      case "hard":
        return TaskDifficulty.hard;

      default:
        return TaskDifficulty.moderate;
    }
  }

  static String toStringValue(TaskDifficulty difficulty) {
    return difficulty.name;
  }
}
