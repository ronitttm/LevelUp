import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
part 'app_database.g.dart';

class Users extends Table {
  TextColumn get userName => text()();
  IntColumn get id => integer().autoIncrement()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get points => integer().withDefault(const Constant(10))();
  TextColumn get difficulty => text().withDefault(const Constant('medium'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get appDay => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  BoolColumn get xpClaimed => boolean().withDefault(const Constant(false))();
}

class DaySummaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  IntColumn get totalTasks => integer()();
  IntColumn get completedTasks => integer()();
  IntColumn get xpEarned => integer()();
  TextColumn get mood => text()();
  IntColumn get streak => integer()();
  BoolColumn get completedDay => boolean()();
}

@DriftDatabase(tables: [Users, Tasks, DaySummaries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 2;
  Future<User?> getUser() {
    return select(users).getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'levelup.sqlite'));
    return NativeDatabase(file);
  });
}
