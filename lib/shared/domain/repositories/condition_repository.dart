import 'package:clothes_control/shared/domain/entities/condition.dart';

abstract class IConditionRepository {
  Future<List<Condition>> getConditions();
  Future<void> addCondition(String condition);
}
