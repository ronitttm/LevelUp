import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'database_provider.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier(this.db) : super(null) {
    loadUser();
  }

  final AppDatabase db;

  /// LOAD USER
  Future<void> loadUser() async {
    final user = await db.getUser();

    if (user == null) {
      await db
          .into(db.users)
          .insert(
            UsersCompanion.insert(
              userName: 'Ronit',
              xp: Value(0),
              level: Value(1),
            ),
          );

      state = await db.getUser();
    } else {
      state = user;
    }
  }

  /// XP REQUIRED
  int xpRequired(int level) {
    return (100 * (level * 1.5)).toInt();
  }

  /// ADD XP
  Future<void> addXP(int points) async {
    if (state == null) return;

    int newXP = state!.xp + points;
    int level = state!.level;

    while (newXP >= xpRequired(level)) {
      newXP -= xpRequired(level);
      level++;
    }

    await (db.update(db.users)..where((tbl) => tbl.id.equals(state!.id))).write(
      UsersCompanion(xp: Value(newXP), level: Value(level)),
    );

    state = await db.getUser();
  }

  /// INCREASE STREAK
  Future<void> increaseStreak() async {
    if (state == null) return;

    await (db.update(db.users)..where((tbl) => tbl.id.equals(state!.id))).write(
      UsersCompanion(streak: Value(state!.streak + 1)),
    );

    state = await db.getUser();
  }

  /// RESET STREAK
  Future<void> resetStreak() async {
    if (state == null) return;

    await (db.update(db.users)..where((tbl) => tbl.id.equals(state!.id))).write(
      const UsersCompanion(streak: Value(0)),
    );

    state = await db.getUser();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  final db = ref.read(databaseProvider);

  return UserNotifier(db);
});
