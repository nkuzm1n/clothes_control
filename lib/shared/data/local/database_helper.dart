import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String dbName = 'clothes.db';

const int dbVersion = 1;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._instance();

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE statuses (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        created_at TEXT,
        updated_at TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE clothes (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        status_id INTEGER,
        image_url TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (status_id) REFERENCES statuses(id),
      );
    ''');

    await initialSeed(db);
  }

  Map<String, dynamic> addInsertDates(Map<String, dynamic> data) {
    final date = DateTime.now().toUtc().toIso8601String();
    return {
      'created_at': date,
      'updated_at': date,
      ...data,
    };
  }

  Map<String, dynamic> addUpdateDates(Map<String, dynamic> data) {
    final date = DateTime.now().toUtc().toIso8601String();
    return {
      'updated_at': date,
      ...data,
    };
  }

  Future<void> initialSeed(Database db) async {
    final statuses = ['Чистая', 'Грязная', 'В стирке'];
    for (var status in statuses) {
      await db.insert('statuses', {'name': status}, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<List<Map<String, dynamic>>> getClothesList({
    String? orderBy = 'updated_at',
    String? direction = 'DESC',
  }) async {
    final db = await instance.database;
    return await db.query('clothes', orderBy: "$orderBy $direction");
  }

  Future<Map<String, dynamic>> getCloth(int itemId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT 
      clothes.id, 
      clothes.name, 
      clothes.description, 
      clothes.status_id,
      clothes.image_url,
      clothes.created_at,
      clothes.updated_at
    FROM clothes
    WHERE clothes.id = ?
    LIMIT 1;
  ''', [itemId]);
    return result.first;
  }

  Future<int> insertCloth(Map<String, dynamic> item) async {
    final db = await instance.database;
    final data = await db.insert(
      'clothes',
      addInsertDates(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return data;
  }

  Future<void> deleteCloth(int itemId) async {
    final db = await instance.database;
    await db.delete('clothes', where: 'id = ?', whereArgs: [itemId]);
  }

  Future<int> updateCloth(Map<String, dynamic> item) async {
    final db = await instance.database;
    final data = await db.update(
      'clothes',
      addUpdateDates(item),
      where: 'id = ?',
      whereArgs: [item['id']],
    );
    return data;
  }

  Future<List<Map<String, dynamic>>> getStatuses() async {
    final db = await instance.database;
    final data = await db.query('statuses');
    return data;
  }

  Future<Map<String, dynamic>> getStatus(int id) async {
    final db = await instance.database;
    final data = await db.query('statuses', where: 'id = ?', whereArgs: [id]);
    return data.first;
  }

  Future<int> insertStatus(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.insert(
      'statuses',
      addInsertDates(item),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> updateStatus(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.update(
      'statuses',
      addUpdateDates(item),
      where: 'id = ?',
      whereArgs: [item['id']],
    );
  }
}
