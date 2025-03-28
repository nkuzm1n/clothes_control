import 'dart:math';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String dbName = 'clothes.db';

class DatabaseHelper {
  final randInt = Random.secure().nextDouble();
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._instance();

  Future<Database> get database async {
    print("return INSTANCE $randInt");
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE statuses (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE conditions (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE clothes (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        status_id INTEGER,
        condition_id INTEGER,
        image_url TEXT,
        FOREIGN KEY (status_id) REFERENCES statuses(id),
        FOREIGN KEY (condition_id) REFERENCES conditions(id)
      )
    ''');

    await initialSeed(db);
  }

  Future<void> initialSeed(Database db) async {
    final statuses = ['Чистая', 'На один раз', 'Грязная', 'В стирке'];
    for (var status in statuses) {
      await db.insert('statuses', {'name': status}, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    final conditions = ['Новая', 'Потрепанная', 'Удобная'];
    for (var condition in conditions) {
      await db.insert(
        'conditions',
        {'name': condition},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getClothesList() async {
    final db = await instance.database;
    return await db.rawQuery('''
    SELECT 
      clothes.id, 
      clothes.name, 
      clothes.description, 
      clothes.image_url,
      statuses.id AS status_id,
      statuses.name AS status_name,
      conditions.id AS condition_id,
      conditions.name AS condition_name
    FROM clothes
    LEFT JOIN statuses ON clothes.status_id = statuses.id
    LEFT JOIN conditions ON clothes.condition_id = conditions.id
  ''');
  }

  Future<Map<String, dynamic>> getCloth(int itemId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT 
      clothes.id, 
      clothes.name, 
      clothes.description, 
      clothes.image_url,
      statuses.id AS status_id,
      statuses.name AS status_name,
      conditions.id AS condition_id,
      conditions.name AS condition_name
    FROM clothes
    LEFT JOIN statuses ON clothes.status_id = statuses.id
    LEFT JOIN conditions ON clothes.condition_id = conditions.id
    WHERE clothes.id = ?
    LIMIT 1
  ''', [itemId]);
    return result.first;
  }

  Future<int> insertCloth(Map<String, dynamic> item) async {
    final db = await instance.database;
    print("to insert = $item.toString()");
    return await db.insert('clothes', item, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCloth(int itemId) async {
    final db = await instance.database;
    await db.delete('clothes', where: 'id = ?', whereArgs: [itemId]);
  }

  Future<int> updateCloth(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.update('clothes', item, where: 'id = ?', whereArgs: [item['id']]);
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

  Future<void> insertStatus(String status) async {
    final db = await instance.database;
    await db.insert('statuses', {'name': status}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> getConditions() async {
    final db = await instance.database;
    final data = await db.query('conditions');
    return data;
  }

  Future<Map<String, dynamic>> getCondition(int id) async {
    final db = await instance.database;
    final data = await db.query('conditions', where: 'id = ?', whereArgs: [id]);
    return data.first;
  }

  Future<void> insertCondition(String condition) async {
    final db = await instance.database;
    await db.insert('conditions', {'name': condition}, conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}
