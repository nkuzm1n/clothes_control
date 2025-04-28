import 'package:equatable/equatable.dart';

class ClothDTO extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int? statusId;
  final int? conditionId;
  final String? imageUrl;

  const ClothDTO({
    required this.id,
    required this.name,
    this.description,
    this.statusId,
    this.conditionId,
    this.imageUrl,
  });

  factory ClothDTO.fromMap(Map<String, dynamic> map) {
    return ClothDTO(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      statusId: map['status_id'],
      conditionId: map['condition_id'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status_id': statusId,
      'condition_id': conditionId,
      'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        statusId,
        conditionId,
        imageUrl,
      ];
}
