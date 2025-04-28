import 'package:equatable/equatable.dart';

class StatusDTO extends Equatable {
  final int id;
  final String name;

  const StatusDTO({required this.id, required this.name});

  factory StatusDTO.fromMap(Map<String, dynamic> map) {
    return StatusDTO(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
