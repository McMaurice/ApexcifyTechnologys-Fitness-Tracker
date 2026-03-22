import 'package:fitness_tracker_app/fitness_tracker_core.dart';
import 'package:path/path.dart' as p;

class DB {
  DB._();
  static final DB instance = DB._();

  static Database? _db;
  final _uuid = const Uuid();

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'fittrack.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Activities table
    await db.execute('''
      CREATE TABLE activities (
        id              TEXT PRIMARY KEY,
        exerciseType    TEXT    NOT NULL,
        durationMinutes INTEGER NOT NULL,
        caloriesBurned  REAL    NOT NULL,
        steps           INTEGER NOT NULL,
        intensity       TEXT    NOT NULL,
        notes           TEXT    NOT NULL DEFAULT '',
        date            TEXT    NOT NULL
      )
    ''');

    // Goals table (single row, id = 'default')
    await db.execute('''
      CREATE TABLE goals (
        id              TEXT PRIMARY KEY,
        dailySteps      INTEGER NOT NULL,
        dailyCalories   REAL    NOT NULL,
        dailyMinutes    INTEGER NOT NULL,
        weeklyWorkouts  INTEGER NOT NULL
      )
    ''');

    // Seed default goals
    final g = FitnessGoal.defaults();
    await db.insert('goals', {'id': 'default', ...g.toMap()});
  }

  // ── Activities ──────────────────────────────────────────────────────────────

  Future<Activity> insertActivity(Activity a) async {
    final db = await database;
    final id = _uuid.v4();
    final row = a.copyWith(id: id);
    await db.insert('activities', row.toMap());
    return row;
  }

  Future<int> updateActivity(Activity a) async {
    final db = await database;
    return db.update('activities', a.toMap(), where: 'id = ?', whereArgs: [a.id]);
  }

  Future<int> deleteActivity(String id) async {
    final db = await database;
    return db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Activity>> allActivities() async {
    final db = await database;
    final rows = await db.query('activities', orderBy: 'date DESC');
    return rows.map(Activity.fromMap).toList();
  }

  Future<List<Activity>> activitiesForDay(DateTime day) async {
    final db = await database;
    final start = DateTime(day.year, day.month, day.day).toIso8601String();
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59).toIso8601String();
    final rows = await db.query(
      'activities',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
      orderBy: 'date DESC',
    );
    return rows.map(Activity.fromMap).toList();
  }

  Future<List<Activity>> activitiesForWeek(DateTime weekStart) async {
    final db = await database;
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day).toIso8601String();
    final end = weekStart.add(const Duration(days: 7)).toIso8601String();
    final rows = await db.query(
      'activities',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start, end],
      orderBy: 'date ASC',
    );
    return rows.map(Activity.fromMap).toList();
  }

  // ── Goals ───────────────────────────────────────────────────────────────────

  Future<FitnessGoal> getGoal() async {
    final db = await database;
    final rows = await db.query('goals', limit: 1);
    if (rows.isEmpty) return FitnessGoal.defaults();
    final map = Map<String, dynamic>.from(rows.first)..remove('id');
    return FitnessGoal.fromMap(map);
  }

  Future<void> saveGoal(FitnessGoal g) async {
    final db = await database;
    await db.update(
      'goals',
      {'id': 'default', ...g.toMap()},
      where: 'id = ?',
      whereArgs: ['default'],
    );
  }
}
