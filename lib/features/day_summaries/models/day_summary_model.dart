class DaySummary {
  final String id;
  final DateTime date;

  final int tasksCreated;
  final int tasksCompleted;

  final int xpEarned;

  final double completionPercentage;

  final String mood;

  final bool streakMaintained;
  final int streakAfterDay;

  const DaySummary({
    required this.id,
    required this.date,
    required this.tasksCreated,
    required this.tasksCompleted,
    required this.xpEarned,
    required this.completionPercentage,
    required this.mood,
    required this.streakMaintained,
    required this.streakAfterDay,
  });

  factory DaySummary.fromMap(Map<String, dynamic> map) {
    return DaySummary(
      id: map['id'],
      date: DateTime.parse(map['date']),
      tasksCreated: map['tasks_created'],
      tasksCompleted: map['tasks_completed'],
      xpEarned: map['xp_earned'],
      completionPercentage: (map['completion_percentage'] as num).toDouble(),
      mood: map['mood'],
      streakMaintained: map['is_streak_maintained'],
      streakAfterDay: map['streak_after_day'],
    );
  }
}
