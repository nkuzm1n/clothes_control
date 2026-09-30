import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = 'clothes.db';

const int dbVersion = 1;

class SqliteDatabase {
  static final SqliteDatabase _instance = SqliteDatabase._();

  Database? _database;

  // Сиды (миграции данных), выполняемые один раз при первом создании БД.
  final List<Future<void> Function()> _seeds = [];

  factory SqliteDatabase() => _instance;
  SqliteDatabase._();

  void registerSeed(Future<void> Function() seedFn) {
    _seeds.add(seedFn);
  }

  Future<Database> get database async {
    _database ??= await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), dbName);
    final db = await openDatabase(path, version: dbVersion, onCreate: _onCreate);
    // Устанавливаем инстанс ПЕРЕД запуском сидов, чтобы геттер .database
    // не инициировал повторный _init() (рекурсии) при обращении из seed.
    _database = db;
    for (final seed in List.of(_seeds)) {
      await seed();
    }
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    // Foreign keys are not enforced by SQLite unless explicitly enabled.
    await db.execute('PRAGMA foreign_keys = ON');

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

    await db.execute('''
      CREATE INDEX idx_clothes_status ON clothes(status_id);
    ''');
    await db.execute('''
      CREATE INDEX idx_clothes_category on clothes(category_id);
    ''');
  }

  Map<String, dynamic> addInsertDates(Map<String, dynamic> data) {
    final date = DateTime.now().toUtc().toIso8601String();
    return {'created_at': date, 'updated_at': date, ...data};
  }

  Map<String, dynamic> addUpdateDates(Map<String, dynamic> data) {
    return {'updated_at': DateTime.now().toUtc().toIso8601String(), ...data};
  }
}
