import 'package:equatable/equatable.dart';

class StatusDTO extends Equatable {
  final int id;
  final String name;
  final String color;

  const StatusDTO({
    required this.id,
    required this.name,
    required this.color,
  });

  factory StatusDTO.fromMap(Map<String, dynamic> map) {
    return StatusDTO(
      id: map['id'],
      name: map['name'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }

  StatusDTO copyWith({int? id, String? name, String? color}) {
    return StatusDTO(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, name, color];
}
