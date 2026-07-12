import '../database/app_database.dart';
import '../models/task_difficulty.dart';
import '../utils/task_utils.dart';

extension TaskExtension on Task {
  TaskDifficulty get difficultyEnum => TaskUtils.fromString(difficulty);

  int get xp => TaskUtils.getXP(difficultyEnum);
}
