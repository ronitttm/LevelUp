# 🚀 LevelUp App

LevelUp is a gamified productivity and self-improvement mobile application built with Flutter.  
The app helps users stay productive by turning daily tasks into an RPG-style leveling system with XP, streaks, moods, achievements, and calendar tracking.

---

# ✨ Features

## 📝 Daily Task Management
- Add tasks for the day
- Mark tasks as completed
- Tasks support:
  - Difficulty levels
  - XP points
  - Completion tracking
  - Completion timestamps

---

## 🎮 Gamification System
- Gain XP for completing tasks
- Automatic leveling system
- Daily streak tracking
- Longest streak tracking
- Mood detection based on task completion
- Confetti celebration on completing all tasks

---

## 📅 Mood Calendar
- Interactive calendar UI
- View productivity history for each day
- Mood visualization:
  - Great 😄
  - Good 🙂
  - Neutral 😐
  - Sad 😞
- Streak day highlights
- Day-wise analytics popup

---

## 📊 Daily Analytics
Each completed day stores:
- Total tasks
- Completed tasks
- Completion percentage
- XP earned
- Mood
- Full task list
- Completed/Incomplete task states

---

## 💾 Local Database
The app uses **Drift (SQLite)** for persistent local storage.

### Stored Data
- Tasks
- Day summaries
- XP progress
- Levels
- Streaks
- Task completion history

---

# 🛠️ Tech Stack

## Frontend
- Flutter
- Dart

## State Management
- Riverpod

## Local Database
- Drift (SQLite)

## Animations
- Lottie Animations

---

# 📂 Project Structure

```bash
lib/
│
├── database/
│   ├── app_database.dart
│
├── providers/
│   ├── task_provider.dart
│   ├── user_provider.dart
│   ├── database_provider.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── calendar_screen.dart
│   ├── add_task_screen.dart
│
├── widgets/
│   ├── top_bar.dart
│   ├── app_drawer.dart
│
├── services/
│
└── main.dart