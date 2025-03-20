import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'clothes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE statuses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE conditions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE clothes (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        status_id INTEGER,
        condition_id INTEGER,
        image_url TEXT,
        FOREIGN KEY (status_id) REFERENCES statuses(id),
        FOREIGN KEY (condition_id) REFERENCES conditions(id)
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getClothesList() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT 
      clothes.id, 
      clothes.name, 
      clothes.description, 
      clothes.imagePath,
      statuses.id AS status_id,
      statuses.name AS status_name,
      conditions.id AS condition_id,
      conditions.name AS condition_name
    FROM clothes
    JOIN statuses ON clothes.status_id = statuses.id
    JOIN conditions ON clothes.condition_id = conditions.id
  ''');
  }

  Future<Map<String, dynamic>> getClothesItem(int itemId) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT 
      clothes.id, 
      clothes.name, 
      clothes.description, 
      clothes.imagePath,
      statuses.id AS status_id,
      statuses.name AS status_name,
      conditions.id AS condition_id,
      conditions.name AS condition_name
    FROM clothes
    JOIN statuses ON clothes.status_id = statuses.id
    JOIN conditions ON clothes.condition_id = conditions.id
    WHERE clothes.id = ?
  ''', [itemId]);
    return result.first;
  }

  Future<void> insertClothesItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('clothes', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteClothesItem(int itemId) async {
    final db = await database;
    await db.delete('clothes', where: 'id = ?', whereArgs: [itemId]);
  }

  Future<void> updateClothesItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.update('clothes', item, where: 'id = ?', whereArgs: [item['id']]);
  }

  Future<void> insertStatus(String status) async {
    final db = await database;
    await db.insert('statuses', {'name': status}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<String>> getStatuses() async {
    final db = await database;
    final data = await db.query('statuses');
    return data.map((item) => item['name'] as String).toList();
  }

  Future<void> insertCondition(String condition) async {
    final db = await database;
    await db.insert('conditions', {'name': condition}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<String>> getConditions() async {
    final db = await database;
    final data = await db.query('conditions');
    return data.map((item) => item['name'] as String).toList();
  }
}
