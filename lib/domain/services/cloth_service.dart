import 'package:clothes_control/domain/entities/cloth.dart';
import 'package:clothes_control/domain/entities/status.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';
import 'package:collection/collection.dart';

class ClothService {
  final IClothesRepository _clothesRepository;

  ClothService({required IClothesRepository clothesRepository})
      : _clothesRepository = clothesRepository;

  Status? getStatus(Cloth cloth, List<Status> statuses) {
    return statuses.firstWhereOrNull((status) => cloth.statusId == status.id);
  }

  Future<Cloth?> updateOne(Cloth cloth) async {
    await _clothesRepository.updateOne(cloth);
    return await _clothesRepository.getOneById(cloth.id);
  }
}
