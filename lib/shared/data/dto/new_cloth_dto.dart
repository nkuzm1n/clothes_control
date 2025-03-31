import 'package:equatable/equatable.dart';

class NewClothDTO extends Equatable {
  final String name;
  final String? description;
  final int? statusId;
  final int? conditionId;
  final String? imageUrl;

  const NewClothDTO({
    required this.name,
    this.description,
    this.statusId,
    this.conditionId,
    this.imageUrl,
  });

  factory NewClothDTO.fromMap(Map<String, dynamic> map) {
    return NewClothDTO(
      name: map['name'],
      description: map['description'],
      statusId: map['status_id'],
      conditionId: map['condition_id'],
      imageUrl: map['image_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'status_id': statusId,
      'condition_id': conditionId,
      'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [
        name,
        description,
        statusId,
        conditionId,
        imageUrl,
      ];
}
