import 'package:flutter/material.dart';

import '../../models/task_difficulty.dart';
import '../../utils/task_utils.dart';

class DifficultyChip extends StatelessWidget {
  final TaskDifficulty difficulty;

  const DifficultyChip({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Text(
        TaskUtils.getEmoji(difficulty),
        style: const TextStyle(fontSize: 18),
      ),
      label: Text(
        TaskUtils.getLabel(difficulty),
        style: TextStyle(
          color: TaskUtils.getColor(difficulty),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: TaskUtils.getBackgroundColor(difficulty),
      side: BorderSide.none,
    );
  }
}
