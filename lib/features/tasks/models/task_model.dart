class TaskModel {
  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.difficulty,
    required this.xpReward,
    required this.completed,
    required this.isDeleted,
    required this.createdAt,
    this.completedAt,
    this.reflection,
  });

  final String id;
  final String userId;

  final String title;
  final String difficulty;

  final int xpReward;

  final bool completed;
  final bool isDeleted;

  final DateTime createdAt;
  final DateTime? completedAt;

  final String? reflection;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,

      title: json['title'] as String,
      difficulty: json['difficulty'] as String,

      xpReward: json['xp_reward'] as int,

      completed: json['completed'] as bool,
      isDeleted: json['is_deleted'] as bool,

      createdAt: DateTime.parse(json['created_at'] as String),

      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,

      reflection: json['reflection'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,

      'title': title,
      'difficulty': difficulty,

      'xp_reward': xpReward,

      'completed': completed,
      'is_deleted': isDeleted,

      'created_at': createdAt.toIso8601String(),

      'completed_at': completedAt?.toIso8601String(),

      'reflection': reflection,
    };
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? difficulty,
    int? xpReward,
    bool? completed,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? completedAt,
    String? reflection,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,

      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,

      xpReward: xpReward ?? this.xpReward,

      completed: completed ?? this.completed,
      isDeleted: isDeleted ?? this.isDeleted,

      createdAt: createdAt ?? this.createdAt,

      completedAt: completedAt ?? this.completedAt,

      reflection: reflection ?? this.reflection,
    );
  }
}
