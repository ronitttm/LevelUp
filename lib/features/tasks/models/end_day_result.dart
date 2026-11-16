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
      streakIncreased: json['streak_increased'] ?? false,
      currentStreak: json['current_streak'] ?? 0,
      xpEarned: json['xp_earned'] ?? 0,
      completedTasks: json['tasks_completed'] ?? 0,
      alreadyEndedToday: json['already_ended_today'] ?? false,
      tasksCreated: json['tasks_created'] ?? 0,
      longestStreak: json['longest_streak'] ?? 0,
      noTasks: json['no_tasks'] ?? false,
    );
  }
}
