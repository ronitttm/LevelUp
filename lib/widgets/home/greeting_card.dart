import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class GreetingCard extends StatelessWidget {
  final String userName;
  final int streak;
  final DateTime currentDay;

  const GreetingCard({
    super.key,
    required this.userName,
    required this.streak,
    required this.currentDay,
  });

  int get hour => DateTime.now().hour;

  bool get isMorning => hour >= 7 && hour < 12;

  bool get isAfternoon => hour >= 12 && hour < 17;

  bool get isSunset => hour >= 17 && hour < 19;

  bool get isNight => hour >= 19 || hour < 7;

  String get formattedDate => DateFormat("EEE • d MMM").format(currentDay);

  String get greeting {
    if (isMorning) return "Good Morning, $userName ☀️";
    if (isAfternoon) return "Good Afternoon, $userName 🌤";
    if (isSunset) return "Good Evening, $userName 🌇";
    return "Good Night, $userName";
  }

  String get subtitle {
    if (isMorning) return "Let's make today amazing!";
    if (isAfternoon) return "Keep the momentum going!";
    if (isSunset) return "Finish today strong!";
    return "Time to recharge and reflect.";
  }

  String get animationAsset {
    return hour < 18
        ? "assets/animations/weather-sunset.json"
        : "assets/animations/weather-night.json";
  }

  List<Color> get gradient {
    if (isMorning) {
      return const [Color(0xFF6A5AE0), Color(0xFF8E7BFF)];
    }

    if (isAfternoon) {
      return const [Color(0xFF4FACFE), Color(0xFF00C6FB)];
    }

    if (isSunset) {
      return const [Color(0xFFFF9966), Color(0xFFFF5E62)];
    }

    return const [Color(0xFF16213E), Color(0xFF0F3460)];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    final isSmall = width < 360;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: height * 0.25,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            /// ☀️🌙 Background Animation
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.7,
                  child: isSunset
                      // 🌇 Sunset stays at the bottom
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipRect(
                            child: SizedBox(
                              height: 58,
                              width: double.infinity,
                              child: Lottie.asset(
                                "assets/animations/weather-sunset.json",
                                fit: BoxFit.cover,
                                repeat: true,
                              ),
                            ),
                          ),
                        )
                      // ☀️ Day & 🌙 Night both stay top-right
                      : Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 8),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: Lottie.asset(
                                isNight
                                    ? "assets/animations/weather-night.json"
                                    : "assets/animations/weather-day.json",
                                repeat: true,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),

            /// Card Content
            Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmall ? 20 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isSmall ? 15 : 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.012,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                                size: 12,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  formattedDate,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isSmall ? 12 : 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: width * 0.02),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: height * 0.012,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.deepOrange,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$streak",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmall ? 12 : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
