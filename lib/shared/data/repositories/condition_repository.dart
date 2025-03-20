import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/repositories/condition_repository.dart';

class ConditionRepository implements IConditionRepository {
  final DatabaseHelper databaseHelper;

  ConditionRepository({required this.databaseHelper});

  @override
  Future<List<String>> getConditions() async {
    return await databaseHelper.getConditions();
  }

  @override
  Future<void> addCondition(String condition) async {
    await databaseHelper.insertCondition(condition);
  }
}
