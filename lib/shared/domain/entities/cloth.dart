import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:equatable/equatable.dart';

class Cloth extends Equatable {
  final int id;
  final String name;
  final String? description;
  final Status status;
  final Condition condition;
  final String? imageUrl;

  const Cloth({
    required this.id,
    required this.name,
    this.description,
    required this.status,
    required this.condition,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status_id': status.id, // Сохраняем только ID статуса
      'condition_id': condition.id, // Сохраняем только ID состояния
      'image_url': imageUrl,
    };
  }

  factory Cloth.fromMap(Map<String, dynamic> map) {
    return Cloth(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      status: Status(
        id: map['status_id'],
        name: map['status_name'],
      ),
      condition: Condition(
        id: map['condition_id'],
        name: map['condition_name'],
      ),
      imageUrl: map['image_url'],
    );
  }

  Cloth copyWith({
    int? id,
    String? name,
    String? description,
    Status? status,
    Condition? condition,
    String? imageUrl,
  }) {
    return Cloth(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      imageUrl: imageUrl ?? imageUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        status,
        condition,
        imageUrl,
      ];
}
