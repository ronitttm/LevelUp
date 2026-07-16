class CurrentUser {
  final String id;

  final String displayName;

  final String avatarSeed;

  final int level;

  final int xp;

  final int currentStreak;

  final int longestStreak;

  final int coins;

  final DateTime? lastLogin;

  const CurrentUser({
    required this.id,
    required this.displayName,
    required this.avatarSeed,
    required this.level,
    required this.xp,
    required this.currentStreak,
    required this.longestStreak,
    required this.coins,
    required this.lastLogin,
  });

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
      id: map['id'] as String,
      displayName: map['display_name'] as String,
      avatarSeed: map['avatar_seed'] as String,
      level: map['level'] as int,
      xp: map['xp'] as int,
      currentStreak: map['current_streak'] as int,
      longestStreak: map['longest_streak'] as int,
      coins: map['coins'] as int,
      lastLogin: map['last_login'] == null
          ? null
          : DateTime.parse(map['last_login']),
    );
  }
}
