import 'package:equatable/equatable.dart';

class NewStatusDTO extends Equatable {
  final String name;

  const NewStatusDTO({required this.name});

  factory NewStatusDTO.fromMap(Map<String, dynamic> map) {
    return NewStatusDTO(
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
