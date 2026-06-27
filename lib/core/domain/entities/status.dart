import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final int id;
  final String name;
  final String color;
  final String? createdAt;
  final String? updatedAt;

  const Status({
    required this.id,
    required this.name,
    required this.color,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'updated_at': updatedAt,
      'created_at': createdAt,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        createdAt,
        updatedAt,
      ];
}
