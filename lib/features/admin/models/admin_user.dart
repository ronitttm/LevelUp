class AdminUser {
  final String id;
  final String displayName;
  final String avatarSeed;
  final String role;

  const AdminUser({
    required this.id,
    required this.displayName,
    required this.avatarSeed,
    required this.role,
  });

  factory AdminUser.fromMap(Map<String, dynamic> map) {
    return AdminUser(
      id: map['id'],
      displayName: map['display_name'],
      avatarSeed: map['avatar_seed'],
      role: map['role'],
    );
  }
}
