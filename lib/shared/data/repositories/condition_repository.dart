import 'package:clothes_control/shared/data/dto/condition/new_condition_dto.dart';
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
  Future<Condition?> getConditionById(int id) async {
    final result = await databaseHelper.getCondition(id);
    return result.isNotEmpty ? Condition.fromMap(result) : null;
  }

  @override
  Future<int> addCondition(NewConditionDTO condition) async {
    return await databaseHelper.insertCondition(condition.toMap());
  }
}
