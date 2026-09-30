import 'package:clothes_control/features/status/data/database/models/status_model.dart';
import 'package:clothes_control/shared/data/database/database.dart';
import 'package:sqflite/sqflite.dart';

class StatusDataSource {
  static const _table = 'statuses';

  final SqliteDatabase _db;

  StatusDataSource(this._db);

  Future<List<StatusModel>> getAll({List<int>? id}) async {
    final db = await _db.database;
    final rawData = await db.query(
      _table,
      where: id == null ? null : 'id IN (${List.filled(id.length, '?').join(',')})',
      whereArgs: id,
    );
    return rawData.map((json) => StatusModel.fromJson(json)).toList();
  }

  Future<StatusModel?> getById(int id) async {
    final db = await _db.database;
    final data = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return data.isNotEmpty ? StatusModel.fromJson(data.first) : null;
  }

  Future<int> create(StatusModel model) async {
    final db = await _db.database;
    return db.insert(
      _table,
      _db.addInsertDates(model.toJson()),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> update(StatusModel model) async {
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

    final defaults = [
      {'name': 'Чистая', 'color': '#00ff00'},
      {'name': 'Грязная', 'color': '#ff0000'},
      {'name': 'В стирке', 'color': '#0000ff'},
    ];
    for (final status in defaults) {
      await db.insert(_table, status, conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  Future<bool> _isEmpty(Database db) async {
    final rows = await db.query(_table);
    return rows.isEmpty;
  }
}
