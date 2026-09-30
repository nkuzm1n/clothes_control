import 'package:clothes_control/features/category/data/database/models/category_model.dart';
import 'package:clothes_control/shared/data/database/database.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDataSource {
  static const _table = 'categories';

  final SqliteDatabase _db;

  CategoryDataSource(this._db);

  Future<List<CategoryModel>> getAll({List<int>? id}) async {
    final db = await _db.database;
    final rawData = await db.query(
      _table,
      where: id == null ? null : 'id IN (${List.filled(id.length, '?').join(',')})',
      whereArgs: id,
    );
    return rawData.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<CategoryModel?> getById(int id) async {
    final db = await _db.database;
    final data = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return data.isNotEmpty ? CategoryModel.fromJson(data.first) : null;
  }

  Future<int> create(CategoryModel model) async {
    final db = await _db.database;
    return db.insert(
      _table,
      _db.addInsertDates(model.toJson()),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> update(CategoryModel model) async {
    final db = await _db.database;
    return db.update(
      _table,
      _db.addUpdateDates(model.toJson()),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deleteById(int id) async {
    final db = await _db.database;
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> seed() async {
    final db = await _db.database;
    if (!(await _isEmpty(db))) return; // защита от повторного сидирования

    final defaults = ['Верхняя одежда', 'Нижнее белье'];
    for (final name in defaults) {
      await db.insert(
        _table,
        _db.addInsertDates({'name': name}),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<bool> _isEmpty(Database db) async {
    final rows = await db.query(_table);
    return rows.isEmpty;
  }
}
