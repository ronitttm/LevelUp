class StartupResult {
  final bool autoEnded;
  final bool streakReset;

  const StartupResult({required this.autoEnded, required this.streakReset});

  factory StartupResult.fromJson(Map<String, dynamic> json) {
    return StartupResult(
      autoEnded: json['auto_ended'] ?? false,
      streakReset: json['streak_reset'] ?? false,
    );
  }

  bool get hasMessage => autoEnded || streakReset;

  String? get message {
    if (autoEnded && streakReset) {
      return "🌙 Yesterday was automatically ended.\n🔥 Your streak has been reset.";
    }

    if (autoEnded) {
      return "🌙 Yesterday was automatically ended.";
    }

    if (streakReset) {
      return "🔥 Your streak has been reset after missing several days.";
    }

    return null;
  }
}
