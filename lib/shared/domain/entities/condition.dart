import 'package:equatable/equatable.dart';

class Condition extends Equatable {
  final int id;
  final String name;

  const Condition({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Condition.fromMap(Map<String, dynamic> map) {
    return Condition(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
