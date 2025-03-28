import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:equatable/equatable.dart';

class Cloth extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int? statusId;
  final int? conditionId;
  final String? imageUrl;

  const Cloth({
    required this.id,
    required this.name,
    this.description,
    this.statusId,
    this.conditionId,
    this.imageUrl,
  });

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

  factory Cloth.fromMap(Map<String, dynamic> map) {
    return Cloth(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      statusId: map['status_id'],
      conditionId: map['condition_id'],
      imageUrl: map['image_url'],
    );
  }

  Cloth copyWith({
    int? id,
    String? name,
    String? description,
    int? statusId,
    int? conditionId,
    String? imageUrl,
  }) {
    return Cloth(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      statusId: statusId ?? this.statusId,
      conditionId: conditionId ?? this.conditionId,
      imageUrl: imageUrl ?? imageUrl,
    );
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
