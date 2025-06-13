import 'package:equatable/equatable.dart';

class NewCategoryDTO extends Equatable {
  final String name;

  const NewCategoryDTO({required this.name});

  factory NewCategoryDTO.fromMap(Map<String, dynamic> map) {
    return NewCategoryDTO(
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  @override
  List<Object> get props => [name];
}
