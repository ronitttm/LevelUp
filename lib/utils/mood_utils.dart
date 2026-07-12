import 'package:flutter/material.dart';

enum MoodType { great, good, neutral, sad }

MoodType getMood(int total, int completed) {
  if (total == 0) return MoodType.neutral;
  if (completed == 0) return MoodType.sad;
  if (completed == total) return MoodType.great;
  if (completed >= total / 2) return MoodType.good;
  return MoodType.neutral;
}

String moodImage(MoodType mood) {
  switch (mood) {
    case MoodType.great:
      return "assets/cat_moods/great_mood.png";

    case MoodType.good:
      return "assets/cat_moods/good_mood.png";

    case MoodType.sad:
      return "assets/cat_moods/sad_mood.png";

    case MoodType.neutral:
      return "assets/cat_moods/neutral_mood.png";
  }
}

Color moodBackground(MoodType mood) {
  switch (mood) {
    case MoodType.great:
      return const Color(0xffD6F7DD);

    case MoodType.good:
      return const Color(0xffEEF8D8);

    case MoodType.sad:
      return const Color(0xffFFE6DC);

    case MoodType.neutral:
      return const Color(0xffECE9FF);
  }
}
