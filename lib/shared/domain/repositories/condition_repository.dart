abstract class IConditionRepository {
  Future<List<String>> getConditions();
  Future<void> addCondition(String condition);
}
