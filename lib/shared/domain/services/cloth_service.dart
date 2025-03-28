import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:collection/collection.dart';

class ClothService {
  static Status? getStatus(Cloth cloth, List<Status> statuses) {
    return statuses.firstWhereOrNull((status) => cloth.statusId == status.id);
  }

  static Condition? getCondition(Cloth cloth, List<Condition> conditions) {
    return conditions.firstWhereOrNull((condition) => cloth.conditionId == condition.id);
  }
}
