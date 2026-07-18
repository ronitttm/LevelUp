class EndDayResult {
  final bool streakIncreased;
  final int currentStreak;
  final int xpEarned;
  final int completedTasks;
  final bool alreadyEndedToday;
  final int tasksCreated;
  final int longestStreak;
  final bool noTasks;

  const EndDayResult({
    required this.streakIncreased,
    required this.currentStreak,
    required this.xpEarned,
    required this.completedTasks,
    required this.alreadyEndedToday,
    required this.tasksCreated,
    required this.longestStreak,
    required this.noTasks,
  });

  factory EndDayResult.fromJson(Map<String, dynamic> json) {
    return EndDayResult(
      streakIncreased: json['streak_increased'],
      tasksCreated: json['tasks_created'],
      currentStreak: json['current_streak'],
      longestStreak: json['longest_streak'],
      xpEarned: json['xp_earned'],
      completedTasks: json['tasks_completed'],
      alreadyEndedToday: json['already_ended_today'],
      noTasks: json['no_tasks'] ?? false,
    );
  }
}
