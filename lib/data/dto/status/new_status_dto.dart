import 'package:equatable/equatable.dart';

class NewStatusDTO extends Equatable {
  final String name;
  final String color;

  const NewStatusDTO({
    required this.name,
    required this.color,
  });

  factory NewStatusDTO.fromMap(Map<String, dynamic> map) {
    return NewStatusDTO(
      name: map['name'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color,
    };
  }

  @override
  List<Object?> get props => [name, color];
}
