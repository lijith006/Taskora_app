import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status; // 'pending' | 'completed'
  final DateTime createdDate;

  const ItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  @override
  List<Object?> get props => [id, title, description, status, createdDate];
}
