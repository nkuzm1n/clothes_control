import 'package:flutter/foundation.dart';
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
        color TEXT,
        created_at TEXT,
        updated_at TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE categories (
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
        category_id INTEGER,
        image_url TEXT,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
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
    final statuses = [
      {'name': 'Чистая', 'color': '#00ff00'},
      {'name': 'Грязная', 'color': '#ff0000'},
      {'name': 'В стирке', 'color': '#0000ff'},
    ];
    for (var status in statuses) {
      await db.insert(
        'statuses',
        {
          'name': status['name'],
          'color': status['color'],
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    final categories = ['Верхняя одежда', 'Нижнее белье'];
    for (var category in categories) {
      await db.insert('categories', {'name': category});
    }
  }

  Future<List<Map<String, dynamic>>> getClothesList({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  }) async {
    name ??= '';
    orderBy ??= 'updated_at';
    direction ??= 'DESC';
    final db = await instance.database;
    return await db.query(
      'clothes',
      where: '''
        name LIKE ? 
        ${statusId != null ? " AND status_id = ?" : ""} 
        ${categoryId != null ? " AND category_id = ?" : ""}
      ''',
      whereArgs: [
        '%$name%',
        statusId,
        categoryId,
      ].whereType<Object>().toList(),
      orderBy: "$orderBy $direction",
    );
  }

  Future<Map<String, dynamic>> getCloth(int id) async {
    final db = await instance.database;
    final data = await db.query('clothes', where: 'id = ?', whereArgs: [id]);
    return data.first;
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
    final result = await db.update(
      'clothes',
      addUpdateDates(item),
      where: 'id = ?',
      whereArgs: [item['id']],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getStatuses({List<int>? id}) async {
    final db = await instance.database;
    final data = await db.query(
      'statuses',
      whereArgs: id,
      where: id == null ? null : 'id IN (${List.filled(id.length, '?').join(',')})',
    );
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

  Future<int> deleteStatus(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.delete(
      'statuses',
      where: 'id = ?',
      whereArgs: [item['id']],
    );
  }

  Future<List<Map<String, dynamic>>> getCategories({List<int>? id}) async {
    final db = await instance.database;
    final data = await db.query(
      'categories',
      whereArgs: id,
      where: id == null ? null : 'id IN (${List.filled(id.length, '?').join(',')})',
    );
    return data;
  }

  Future<Map<String, dynamic>> getCategory(int id) async {
    final db = await instance.database;
    final data = await db.query('categories', where: 'id = ?', whereArgs: [id]);
    return data.first;
  }

  Future<int> insertCategory(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.insert(
      'categories',
      addInsertDates(item),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> updateCategory(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.update(
      'categories',
      addUpdateDates(item),
      where: 'id = ?',
      whereArgs: [item['id']],
    );
  }

  Future<int> deleteCategory(Map<String, dynamic> item) async {
    final db = await instance.database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [item['id']],
    );
  }
}
