import 'package:equatable/equatable.dart';

class Cloth extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int? statusId;
  final String? imageUrl;
  final String? createdAt;
  final String? updatedAt;

  const Cloth({
    required this.id,
    required this.name,
    this.description,
    this.statusId,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status_id': statusId,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Cloth.fromMap(Map<String, dynamic> map) {
    return Cloth(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      statusId: map['status_id'],
      imageUrl: map['image_url'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Cloth copyWith({
    int? id,
    String? name,
    String? description,
    int? statusId,
    String? imageUrl,
  }) {
    return Cloth(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      statusId: statusId ?? this.statusId,
      imageUrl: imageUrl ?? imageUrl,
      createdAt: createdAt ?? createdAt,
      updatedAt: updatedAt ?? updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        statusId,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}
