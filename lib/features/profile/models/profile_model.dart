class ProfileModel {
  final String id;
  final String displayName;
  final String avatarSeed;
  final String role;
  bool get isAdmin => role == 'admin';
  bool get isMember => role == 'member';

  const ProfileModel({
    required this.id,
    required this.displayName,
    required this.avatarSeed,
    required this.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"],
      displayName: json["display_name"],
      avatarSeed: json["avatar_seed"],
      role: json['role'] as String,
    );
  }
}
