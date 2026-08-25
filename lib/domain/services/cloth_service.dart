import 'package:clothes_control/domain/entities/cloth.dart';
import 'package:clothes_control/domain/entities/status.dart';
import 'package:collection/collection.dart';

class ClothService {
  Status? getStatus(Cloth cloth, List<Status> statuses) {
    return statuses.firstWhereOrNull((status) => cloth.statusId == status.id);
  }
}
