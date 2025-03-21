import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/repositories/condition_repository.dart';

class ConditionRepository implements IConditionRepository {
  final DatabaseHelper databaseHelper;

  ConditionRepository({required this.databaseHelper});

  @override
  Future<List<Condition>> getConditions() async {
    final result = await databaseHelper.getConditions();
    return result.map((item) => Condition.fromMap(item)).toList();
  }

  @override
  Future<void> addCondition(String condition) async {
    await databaseHelper.insertCondition(condition);
  }
}
