abstract class IStatusRepository {
  Future<List<String>> getStatuses();
  Future<void> addStatus(String status);
}
