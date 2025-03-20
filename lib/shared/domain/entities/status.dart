import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final int id;
  final String name;

  const Status({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  List<Object?> get props => [id, name];
}
