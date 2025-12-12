import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:aquatrack/models/water_intake.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('aquatrack.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE water_intakes (
        id $idType,
        timestamp $textType,
        amountMl $integerType,
        date $textType
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_water_intakes_date ON water_intakes(date)
    ''');
  }

  // Water Intake CRUD operations
  Future<WaterIntake> createWaterIntake(WaterIntake intake) async {
    final db = await database;
    await db.insert('water_intakes', intake.toMap());
    return intake;
  }

  Future<List<WaterIntake>> getWaterIntakesByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'water_intakes',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => WaterIntake.fromMap(map)).toList();
  }

  Future<List<WaterIntake>> getWaterIntakesInRange(
    String startDate,
    String endDate,
  ) async {
    final db = await database;
    final result = await db.query(
      'water_intakes',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => WaterIntake.fromMap(map)).toList();
  }

  Future<Map<String, int>> getDailyTotalsInRange(
    String startDate,
    String endDate,
  ) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT date, SUM(amountMl) as total
      FROM water_intakes
      WHERE date >= ? AND date <= ?
      GROUP BY date
      ORDER BY date
    ''', [startDate, endDate]);

    final Map<String, int> dailyTotals = {};
    for (final row in result) {
      dailyTotals[row['date'] as String] = row['total'] as int;
    }

    return dailyTotals;
  }

  Future<int> deleteWaterIntake(String id) async {
    final db = await database;
    return await db.delete(
      'water_intakes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTodayTotal(String date) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amountMl) as total
      FROM water_intakes
      WHERE date = ?
    ''', [date]);

    if (result.isEmpty || result.first['total'] == null) {
      return 0;
    }

    return result.first['total'] as int;
  }

  Future<List<String>> getDatesWithIntakes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT DISTINCT date
      FROM water_intakes
      ORDER BY date DESC
    ''');

    return result.map((row) => row['date'] as String).toList();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

