import 'package:equatable/equatable.dart';

class NewConditionDTO extends Equatable {
  final String name;

  const NewConditionDTO({required this.name});

  factory NewConditionDTO.fromMap(Map<String, dynamic> map) {
    return NewConditionDTO(
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  @override
  List<Object?> get props => [name];
}
