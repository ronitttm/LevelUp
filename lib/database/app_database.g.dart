// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userNameMeta =
      const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
      'xp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [userName, id, xp, level, streak];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      xp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String userName;
  final int id;
  final int xp;
  final int level;
  final int streak;
  const User(
      {required this.userName,
      required this.id,
      required this.xp,
      required this.level,
      required this.streak});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_name'] = Variable<String>(userName);
    map['id'] = Variable<int>(id);
    map['xp'] = Variable<int>(xp);
    map['level'] = Variable<int>(level);
    map['streak'] = Variable<int>(streak);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      userName: Value(userName),
      id: Value(id),
      xp: Value(xp),
      level: Value(level),
      streak: Value(streak),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      userName: serializer.fromJson<String>(json['userName']),
      id: serializer.fromJson<int>(json['id']),
      xp: serializer.fromJson<int>(json['xp']),
      level: serializer.fromJson<int>(json['level']),
      streak: serializer.fromJson<int>(json['streak']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userName': serializer.toJson<String>(userName),
      'id': serializer.toJson<int>(id),
      'xp': serializer.toJson<int>(xp),
      'level': serializer.toJson<int>(level),
      'streak': serializer.toJson<int>(streak),
    };
  }

  User copyWith(
          {String? userName, int? id, int? xp, int? level, int? streak}) =>
      User(
        userName: userName ?? this.userName,
        id: id ?? this.id,
        xp: xp ?? this.xp,
        level: level ?? this.level,
        streak: streak ?? this.streak,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      userName: data.userName.present ? data.userName.value : this.userName,
      id: data.id.present ? data.id.value : this.id,
      xp: data.xp.present ? data.xp.value : this.xp,
      level: data.level.present ? data.level.value : this.level,
      streak: data.streak.present ? data.streak.value : this.streak,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('userName: $userName, ')
          ..write('id: $id, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userName, id, xp, level, streak);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.userName == this.userName &&
          other.id == this.id &&
          other.xp == this.xp &&
          other.level == this.level &&
          other.streak == this.streak);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> userName;
  final Value<int> id;
  final Value<int> xp;
  final Value<int> level;
  final Value<int> streak;
  const UsersCompanion({
    this.userName = const Value.absent(),
    this.id = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.streak = const Value.absent(),
  });
  UsersCompanion.insert({
    required String userName,
    this.id = const Value.absent(),
    this.xp = const Value.absent(),
    this.level = const Value.absent(),
    this.streak = const Value.absent(),
  }) : userName = Value(userName);
  static Insertable<User> custom({
    Expression<String>? userName,
    Expression<int>? id,
    Expression<int>? xp,
    Expression<int>? level,
    Expression<int>? streak,
  }) {
    return RawValuesInsertable({
      if (userName != null) 'user_name': userName,
      if (id != null) 'id': id,
      if (xp != null) 'xp': xp,
      if (level != null) 'level': level,
      if (streak != null) 'streak': streak,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? userName,
      Value<int>? id,
      Value<int>? xp,
      Value<int>? level,
      Value<int>? streak}) {
    return UsersCompanion(
      userName: userName ?? this.userName,
      id: id ?? this.id,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('userName: $userName, ')
          ..write('id: $id, ')
          ..write('xp: $xp, ')
          ..write('level: $level, ')
          ..write('streak: $streak')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
      'points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(10));
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('medium'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _appDayMeta = const VerificationMeta('appDay');
  @override
  late final GeneratedColumn<DateTime> appDay = GeneratedColumn<DateTime>(
      'app_day', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _xpClaimedMeta =
      const VerificationMeta('xpClaimed');
  @override
  late final GeneratedColumn<bool> xpClaimed = GeneratedColumn<bool>(
      'xp_claimed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("xp_claimed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        isCompleted,
        points,
        difficulty,
        createdAt,
        appDay,
        completedAt,
        xpClaimed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('points')) {
      context.handle(_pointsMeta,
          points.isAcceptableOrUnknown(data['points']!, _pointsMeta));
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('app_day')) {
      context.handle(_appDayMeta,
          appDay.isAcceptableOrUnknown(data['app_day']!, _appDayMeta));
    } else if (isInserting) {
      context.missing(_appDayMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('xp_claimed')) {
      context.handle(_xpClaimedMeta,
          xpClaimed.isAcceptableOrUnknown(data['xp_claimed']!, _xpClaimedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      points: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}points'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      appDay: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}app_day'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      xpClaimed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}xp_claimed'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String title;
  final bool isCompleted;
  final int points;
  final String difficulty;
  final DateTime createdAt;
  final DateTime appDay;
  final DateTime? completedAt;
  final bool xpClaimed;
  const Task(
      {required this.id,
      required this.title,
      required this.isCompleted,
      required this.points,
      required this.difficulty,
      required this.createdAt,
      required this.appDay,
      this.completedAt,
      required this.xpClaimed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['points'] = Variable<int>(points);
    map['difficulty'] = Variable<String>(difficulty);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['app_day'] = Variable<DateTime>(appDay);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['xp_claimed'] = Variable<bool>(xpClaimed);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      isCompleted: Value(isCompleted),
      points: Value(points),
      difficulty: Value(difficulty),
      createdAt: Value(createdAt),
      appDay: Value(appDay),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      xpClaimed: Value(xpClaimed),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      points: serializer.fromJson<int>(json['points']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      appDay: serializer.fromJson<DateTime>(json['appDay']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      xpClaimed: serializer.fromJson<bool>(json['xpClaimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'points': serializer.toJson<int>(points),
      'difficulty': serializer.toJson<String>(difficulty),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'appDay': serializer.toJson<DateTime>(appDay),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'xpClaimed': serializer.toJson<bool>(xpClaimed),
    };
  }

  Task copyWith(
          {int? id,
          String? title,
          bool? isCompleted,
          int? points,
          String? difficulty,
          DateTime? createdAt,
          DateTime? appDay,
          Value<DateTime?> completedAt = const Value.absent(),
          bool? xpClaimed}) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        points: points ?? this.points,
        difficulty: difficulty ?? this.difficulty,
        createdAt: createdAt ?? this.createdAt,
        appDay: appDay ?? this.appDay,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        xpClaimed: xpClaimed ?? this.xpClaimed,
      );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      points: data.points.present ? data.points.value : this.points,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      appDay: data.appDay.present ? data.appDay.value : this.appDay,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      xpClaimed: data.xpClaimed.present ? data.xpClaimed.value : this.xpClaimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('points: $points, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt, ')
          ..write('appDay: $appDay, ')
          ..write('completedAt: $completedAt, ')
          ..write('xpClaimed: $xpClaimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, isCompleted, points, difficulty,
      createdAt, appDay, completedAt, xpClaimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.isCompleted == this.isCompleted &&
          other.points == this.points &&
          other.difficulty == this.difficulty &&
          other.createdAt == this.createdAt &&
          other.appDay == this.appDay &&
          other.completedAt == this.completedAt &&
          other.xpClaimed == this.xpClaimed);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> title;
  final Value<bool> isCompleted;
  final Value<int> points;
  final Value<String> difficulty;
  final Value<DateTime> createdAt;
  final Value<DateTime> appDay;
  final Value<DateTime?> completedAt;
  final Value<bool> xpClaimed;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.points = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.appDay = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.xpClaimed = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.isCompleted = const Value.absent(),
    this.points = const Value.absent(),
    this.difficulty = const Value.absent(),
    required DateTime createdAt,
    required DateTime appDay,
    this.completedAt = const Value.absent(),
    this.xpClaimed = const Value.absent(),
  })  : title = Value(title),
        createdAt = Value(createdAt),
        appDay = Value(appDay);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<bool>? isCompleted,
    Expression<int>? points,
    Expression<String>? difficulty,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? appDay,
    Expression<DateTime>? completedAt,
    Expression<bool>? xpClaimed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (points != null) 'points': points,
      if (difficulty != null) 'difficulty': difficulty,
      if (createdAt != null) 'created_at': createdAt,
      if (appDay != null) 'app_day': appDay,
      if (completedAt != null) 'completed_at': completedAt,
      if (xpClaimed != null) 'xp_claimed': xpClaimed,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<bool>? isCompleted,
      Value<int>? points,
      Value<String>? difficulty,
      Value<DateTime>? createdAt,
      Value<DateTime>? appDay,
      Value<DateTime?>? completedAt,
      Value<bool>? xpClaimed}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      points: points ?? this.points,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      appDay: appDay ?? this.appDay,
      completedAt: completedAt ?? this.completedAt,
      xpClaimed: xpClaimed ?? this.xpClaimed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (appDay.present) {
      map['app_day'] = Variable<DateTime>(appDay.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (xpClaimed.present) {
      map['xp_claimed'] = Variable<bool>(xpClaimed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('points: $points, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt, ')
          ..write('appDay: $appDay, ')
          ..write('completedAt: $completedAt, ')
          ..write('xpClaimed: $xpClaimed')
          ..write(')'))
        .toString();
  }
}

class $DaySummariesTable extends DaySummaries
    with TableInfo<$DaySummariesTable, DaySummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DaySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalTasksMeta =
      const VerificationMeta('totalTasks');
  @override
  late final GeneratedColumn<int> totalTasks = GeneratedColumn<int>(
      'total_tasks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedTasksMeta =
      const VerificationMeta('completedTasks');
  @override
  late final GeneratedColumn<int> completedTasks = GeneratedColumn<int>(
      'completed_tasks', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _xpEarnedMeta =
      const VerificationMeta('xpEarned');
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
      'xp_earned', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
      'mood', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedDayMeta =
      const VerificationMeta('completedDay');
  @override
  late final GeneratedColumn<bool> completedDay = GeneratedColumn<bool>(
      'completed_day', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("completed_day" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        totalTasks,
        completedTasks,
        xpEarned,
        mood,
        streak,
        completedDay
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_summaries';
  @override
  VerificationContext validateIntegrity(Insertable<DaySummary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_tasks')) {
      context.handle(
          _totalTasksMeta,
          totalTasks.isAcceptableOrUnknown(
              data['total_tasks']!, _totalTasksMeta));
    } else if (isInserting) {
      context.missing(_totalTasksMeta);
    }
    if (data.containsKey('completed_tasks')) {
      context.handle(
          _completedTasksMeta,
          completedTasks.isAcceptableOrUnknown(
              data['completed_tasks']!, _completedTasksMeta));
    } else if (isInserting) {
      context.missing(_completedTasksMeta);
    }
    if (data.containsKey('xp_earned')) {
      context.handle(_xpEarnedMeta,
          xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta));
    } else if (isInserting) {
      context.missing(_xpEarnedMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    } else if (isInserting) {
      context.missing(_moodMeta);
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    } else if (isInserting) {
      context.missing(_streakMeta);
    }
    if (data.containsKey('completed_day')) {
      context.handle(
          _completedDayMeta,
          completedDay.isAcceptableOrUnknown(
              data['completed_day']!, _completedDayMeta));
    } else if (isInserting) {
      context.missing(_completedDayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DaySummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DaySummary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_tasks'])!,
      completedTasks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_tasks'])!,
      xpEarned: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}xp_earned'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      completedDay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed_day'])!,
    );
  }

  @override
  $DaySummariesTable createAlias(String alias) {
    return $DaySummariesTable(attachedDatabase, alias);
  }
}

class DaySummary extends DataClass implements Insertable<DaySummary> {
  final int id;
  final DateTime date;
  final int totalTasks;
  final int completedTasks;
  final int xpEarned;
  final String mood;
  final int streak;
  final bool completedDay;
  const DaySummary(
      {required this.id,
      required this.date,
      required this.totalTasks,
      required this.completedTasks,
      required this.xpEarned,
      required this.mood,
      required this.streak,
      required this.completedDay});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['total_tasks'] = Variable<int>(totalTasks);
    map['completed_tasks'] = Variable<int>(completedTasks);
    map['xp_earned'] = Variable<int>(xpEarned);
    map['mood'] = Variable<String>(mood);
    map['streak'] = Variable<int>(streak);
    map['completed_day'] = Variable<bool>(completedDay);
    return map;
  }

  DaySummariesCompanion toCompanion(bool nullToAbsent) {
    return DaySummariesCompanion(
      id: Value(id),
      date: Value(date),
      totalTasks: Value(totalTasks),
      completedTasks: Value(completedTasks),
      xpEarned: Value(xpEarned),
      mood: Value(mood),
      streak: Value(streak),
      completedDay: Value(completedDay),
    );
  }

  factory DaySummary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DaySummary(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalTasks: serializer.fromJson<int>(json['totalTasks']),
      completedTasks: serializer.fromJson<int>(json['completedTasks']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      mood: serializer.fromJson<String>(json['mood']),
      streak: serializer.fromJson<int>(json['streak']),
      completedDay: serializer.fromJson<bool>(json['completedDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'totalTasks': serializer.toJson<int>(totalTasks),
      'completedTasks': serializer.toJson<int>(completedTasks),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'mood': serializer.toJson<String>(mood),
      'streak': serializer.toJson<int>(streak),
      'completedDay': serializer.toJson<bool>(completedDay),
    };
  }

  DaySummary copyWith(
          {int? id,
          DateTime? date,
          int? totalTasks,
          int? completedTasks,
          int? xpEarned,
          String? mood,
          int? streak,
          bool? completedDay}) =>
      DaySummary(
        id: id ?? this.id,
        date: date ?? this.date,
        totalTasks: totalTasks ?? this.totalTasks,
        completedTasks: completedTasks ?? this.completedTasks,
        xpEarned: xpEarned ?? this.xpEarned,
        mood: mood ?? this.mood,
        streak: streak ?? this.streak,
        completedDay: completedDay ?? this.completedDay,
      );
  DaySummary copyWithCompanion(DaySummariesCompanion data) {
    return DaySummary(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      totalTasks:
          data.totalTasks.present ? data.totalTasks.value : this.totalTasks,
      completedTasks: data.completedTasks.present
          ? data.completedTasks.value
          : this.completedTasks,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      mood: data.mood.present ? data.mood.value : this.mood,
      streak: data.streak.present ? data.streak.value : this.streak,
      completedDay: data.completedDay.present
          ? data.completedDay.value
          : this.completedDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DaySummary(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalTasks: $totalTasks, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('mood: $mood, ')
          ..write('streak: $streak, ')
          ..write('completedDay: $completedDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, totalTasks, completedTasks,
      xpEarned, mood, streak, completedDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DaySummary &&
          other.id == this.id &&
          other.date == this.date &&
          other.totalTasks == this.totalTasks &&
          other.completedTasks == this.completedTasks &&
          other.xpEarned == this.xpEarned &&
          other.mood == this.mood &&
          other.streak == this.streak &&
          other.completedDay == this.completedDay);
}

class DaySummariesCompanion extends UpdateCompanion<DaySummary> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> totalTasks;
  final Value<int> completedTasks;
  final Value<int> xpEarned;
  final Value<String> mood;
  final Value<int> streak;
  final Value<bool> completedDay;
  const DaySummariesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.totalTasks = const Value.absent(),
    this.completedTasks = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.mood = const Value.absent(),
    this.streak = const Value.absent(),
    this.completedDay = const Value.absent(),
  });
  DaySummariesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int totalTasks,
    required int completedTasks,
    required int xpEarned,
    required String mood,
    required int streak,
    required bool completedDay,
  })  : date = Value(date),
        totalTasks = Value(totalTasks),
        completedTasks = Value(completedTasks),
        xpEarned = Value(xpEarned),
        mood = Value(mood),
        streak = Value(streak),
        completedDay = Value(completedDay);
  static Insertable<DaySummary> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? totalTasks,
    Expression<int>? completedTasks,
    Expression<int>? xpEarned,
    Expression<String>? mood,
    Expression<int>? streak,
    Expression<bool>? completedDay,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (totalTasks != null) 'total_tasks': totalTasks,
      if (completedTasks != null) 'completed_tasks': completedTasks,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (mood != null) 'mood': mood,
      if (streak != null) 'streak': streak,
      if (completedDay != null) 'completed_day': completedDay,
    });
  }

  DaySummariesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? date,
      Value<int>? totalTasks,
      Value<int>? completedTasks,
      Value<int>? xpEarned,
      Value<String>? mood,
      Value<int>? streak,
      Value<bool>? completedDay}) {
    return DaySummariesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      xpEarned: xpEarned ?? this.xpEarned,
      mood: mood ?? this.mood,
      streak: streak ?? this.streak,
      completedDay: completedDay ?? this.completedDay,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalTasks.present) {
      map['total_tasks'] = Variable<int>(totalTasks.value);
    }
    if (completedTasks.present) {
      map['completed_tasks'] = Variable<int>(completedTasks.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (completedDay.present) {
      map['completed_day'] = Variable<bool>(completedDay.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaySummariesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalTasks: $totalTasks, ')
          ..write('completedTasks: $completedTasks, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('mood: $mood, ')
          ..write('streak: $streak, ')
          ..write('completedDay: $completedDay')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $DaySummariesTable daySummaries = $DaySummariesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, tasks, daySummaries];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String userName,
  Value<int> id,
  Value<int> xp,
  Value<int> level,
  Value<int> streak,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> userName,
  Value<int> id,
  Value<int> xp,
  Value<int> level,
  Value<int> streak,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xp => $composableBuilder(
      column: $table.xp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userName = const Value.absent(),
            Value<int> id = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> streak = const Value.absent(),
          }) =>
              UsersCompanion(
            userName: userName,
            id: id,
            xp: xp,
            level: level,
            streak: streak,
          ),
          createCompanionCallback: ({
            required String userName,
            Value<int> id = const Value.absent(),
            Value<int> xp = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> streak = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            userName: userName,
            id: id,
            xp: xp,
            level: level,
            streak: streak,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  required String title,
  Value<bool> isCompleted,
  Value<int> points,
  Value<String> difficulty,
  required DateTime createdAt,
  required DateTime appDay,
  Value<DateTime?> completedAt,
  Value<bool> xpClaimed,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<bool> isCompleted,
  Value<int> points,
  Value<String> difficulty,
  Value<DateTime> createdAt,
  Value<DateTime> appDay,
  Value<DateTime?> completedAt,
  Value<bool> xpClaimed,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get appDay => $composableBuilder(
      column: $table.appDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get xpClaimed => $composableBuilder(
      column: $table.xpClaimed, builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get points => $composableBuilder(
      column: $table.points, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get appDay => $composableBuilder(
      column: $table.appDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get xpClaimed => $composableBuilder(
      column: $table.xpClaimed, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
      column: $table.difficulty, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get appDay =>
      $composableBuilder(column: $table.appDay, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<bool> get xpClaimed =>
      $composableBuilder(column: $table.xpClaimed, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> appDay = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> xpClaimed = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            isCompleted: isCompleted,
            points: points,
            difficulty: difficulty,
            createdAt: createdAt,
            appDay: appDay,
            completedAt: completedAt,
            xpClaimed: xpClaimed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<bool> isCompleted = const Value.absent(),
            Value<int> points = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            required DateTime createdAt,
            required DateTime appDay,
            Value<DateTime?> completedAt = const Value.absent(),
            Value<bool> xpClaimed = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            isCompleted: isCompleted,
            points: points,
            difficulty: difficulty,
            createdAt: createdAt,
            appDay: appDay,
            completedAt: completedAt,
            xpClaimed: xpClaimed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()>;
typedef $$DaySummariesTableCreateCompanionBuilder = DaySummariesCompanion
    Function({
  Value<int> id,
  required DateTime date,
  required int totalTasks,
  required int completedTasks,
  required int xpEarned,
  required String mood,
  required int streak,
  required bool completedDay,
});
typedef $$DaySummariesTableUpdateCompanionBuilder = DaySummariesCompanion
    Function({
  Value<int> id,
  Value<DateTime> date,
  Value<int> totalTasks,
  Value<int> completedTasks,
  Value<int> xpEarned,
  Value<String> mood,
  Value<int> streak,
  Value<bool> completedDay,
});

class $$DaySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTasks => $composableBuilder(
      column: $table.totalTasks, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedTasks => $composableBuilder(
      column: $table.completedTasks,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completedDay => $composableBuilder(
      column: $table.completedDay, builder: (column) => ColumnFilters(column));
}

class $$DaySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTasks => $composableBuilder(
      column: $table.totalTasks, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedTasks => $composableBuilder(
      column: $table.completedTasks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xpEarned => $composableBuilder(
      column: $table.xpEarned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completedDay => $composableBuilder(
      column: $table.completedDay,
      builder: (column) => ColumnOrderings(column));
}

class $$DaySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DaySummariesTable> {
  $$DaySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalTasks => $composableBuilder(
      column: $table.totalTasks, builder: (column) => column);

  GeneratedColumn<int> get completedTasks => $composableBuilder(
      column: $table.completedTasks, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<bool> get completedDay => $composableBuilder(
      column: $table.completedDay, builder: (column) => column);
}

class $$DaySummariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DaySummariesTable,
    DaySummary,
    $$DaySummariesTableFilterComposer,
    $$DaySummariesTableOrderingComposer,
    $$DaySummariesTableAnnotationComposer,
    $$DaySummariesTableCreateCompanionBuilder,
    $$DaySummariesTableUpdateCompanionBuilder,
    (DaySummary, BaseReferences<_$AppDatabase, $DaySummariesTable, DaySummary>),
    DaySummary,
    PrefetchHooks Function()> {
  $$DaySummariesTableTableManager(_$AppDatabase db, $DaySummariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DaySummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DaySummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DaySummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> totalTasks = const Value.absent(),
            Value<int> completedTasks = const Value.absent(),
            Value<int> xpEarned = const Value.absent(),
            Value<String> mood = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<bool> completedDay = const Value.absent(),
          }) =>
              DaySummariesCompanion(
            id: id,
            date: date,
            totalTasks: totalTasks,
            completedTasks: completedTasks,
            xpEarned: xpEarned,
            mood: mood,
            streak: streak,
            completedDay: completedDay,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required int totalTasks,
            required int completedTasks,
            required int xpEarned,
            required String mood,
            required int streak,
            required bool completedDay,
          }) =>
              DaySummariesCompanion.insert(
            id: id,
            date: date,
            totalTasks: totalTasks,
            completedTasks: completedTasks,
            xpEarned: xpEarned,
            mood: mood,
            streak: streak,
            completedDay: completedDay,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DaySummariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DaySummariesTable,
    DaySummary,
    $$DaySummariesTableFilterComposer,
    $$DaySummariesTableOrderingComposer,
    $$DaySummariesTableAnnotationComposer,
    $$DaySummariesTableCreateCompanionBuilder,
    $$DaySummariesTableUpdateCompanionBuilder,
    (DaySummary, BaseReferences<_$AppDatabase, $DaySummariesTable, DaySummary>),
    DaySummary,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$DaySummariesTableTableManager get daySummaries =>
      $$DaySummariesTableTableManager(_db, _db.daySummaries);
}
