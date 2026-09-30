import 'package:clothes_control/features/clothes/data/database/models/cloth_model.dart';
import 'package:clothes_control/shared/data/database/database.dart';
import 'package:sqflite/sqflite.dart';

class ClothesDataSource {
  static const _table = 'clothes';

  // Columns that are safe to use in an ORDER BY clause (user input is not).
  static const _allowedOrders = {'id', 'name', 'created_at', 'updated_at'};

  final SqliteDatabase _db;

  ClothesDataSource(this._db);

  Future<List<ClothModel>> getAll({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  }) async {
    final search = name ?? '';

    final order = _allowedOrders.contains(orderBy) ? orderBy! : 'updated_at';
    final dir = direction?.toUpperCase() == 'ASC' ? 'ASC' : 'DESC';

    final conditions = <String>['name LIKE ?'];
    final args = <Object>['%$search%'];

    if (statusId != null) {
      conditions.add('status_id = ?');
      args.add(statusId);
    }

    if (categoryId != null) {
      conditions.add('category_id = ?');
      args.add(categoryId);
    }

    final db = await _db.database;
    final result = await db.query(
      _table,
      where: conditions.join(' AND '),
      whereArgs: args,
      orderBy: '$order $dir',
    );

    return result.map((json) => ClothModel.fromJson(json)).toList();
  }

  Future<ClothModel?> getById(int id) async {
    final db = await _db.database;
    final data = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return data.isNotEmpty ? ClothModel.fromJson(data.first) : null;
  }

  Future<int> create(ClothModel model) async {
    final db = await _db.database;
    return db.insert(
      _table,
      _db.addInsertDates(model.toJson()),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteById(int id) async {
    final db = await _db.database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(ClothModel model) async {
    final db = await _db.database;
    return db.update(
      _table,
      _db.addUpdateDates(model.toJson()),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
