# 🚀 LevelUp App

LevelUp is a gamified productivity and self-improvement mobile application built with Flutter.  
The app helps users stay productive by turning daily tasks into an RPG-style leveling system with XP, streaks, moods, and calendar tracking.

---

# ✨ Features

## 📝 Daily Task Management
- Add tasks for the day
- Mark tasks as completed or delete them
- Add an optional reflection when completing a task
- Tasks support:
  - Difficulty levels
  - XP points
  - Completion tracking
  - Completion timestamps

---

## 🎮 Gamification System
- Gain XP for completing tasks
- Level progression
- Daily streak tracking
- Longest streak tracking
- Mood based on task completion
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
End the day to record and review:
- Total tasks
- Completed tasks
- Completion percentage
- XP earned
- Mood
- Streak progress
- Task history and completion states

---

## 👤 Accounts and Profiles
- Sign up and sign in with email and password
- Set a display name and choose an avatar during onboarding

---

## 🤝 Admin Task Assignment
- Administrators can view and search members
- Assign tasks to one or more members
- Choose the task difficulty and date

---

## ☁️ Cloud Data
The app uses **Supabase** for authentication and persistent application data.

### Stored Data
- Profiles and accounts
- Tasks and reflections
- Day summaries
- XP progress and levels
- Streaks and task completion history

---

# 🛠️ Tech Stack

## Frontend
- Flutter
- Dart

## State Management
- Riverpod

## Backend and Authentication
- Supabase
- PostgreSQL

## Animations
- Lottie Animations

---

# 📂 Project Structure

```text
lib/
│
├── core/          # Shared configuration, styling, and widgets
├── features/      # Auth, profiles, tasks, summaries, and admin
├── models/        # Shared models
├── providers/     # Shared state
├── screens/       # Home, calendar, task, and splash screens
├── services/      # Celebration handling
├── utils/         # Mood and task utilities
├── widgets/       # Reusable UI components
│
└── main.dart
```