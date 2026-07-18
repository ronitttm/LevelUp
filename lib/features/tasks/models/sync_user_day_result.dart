class SyncUserDayResult {
  final bool autoEnded;
  final bool streakReset;

  const SyncUserDayResult({required this.autoEnded, required this.streakReset});

  factory SyncUserDayResult.fromJson(Map<String, dynamic> json) {
    return SyncUserDayResult(
      autoEnded: json['auto_ended'] ?? false,
      streakReset: json['streak_reset'] ?? false,
    );
  }
}
