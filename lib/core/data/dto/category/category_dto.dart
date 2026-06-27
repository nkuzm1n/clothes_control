import 'package:equatable/equatable.dart';

class CategoryDTO extends Equatable {
  final int id;
  final String name;

  const CategoryDTO({
    required this.id,
    required this.name,
  });

  factory CategoryDTO.fromMap(Map<String, dynamic> map) {
    return CategoryDTO(
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

  CategoryDTO copyWith({int? id, String? name, String? color}) {
    return CategoryDTO(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => [id, name];
}
