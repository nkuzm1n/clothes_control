import 'package:equatable/equatable.dart';

class ConditionDTO extends Equatable {
  final int id;
  final String name;

  const ConditionDTO({required this.id, required this.name});

  factory ConditionDTO.fromMap(Map<String, dynamic> map) {
    return ConditionDTO(
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
