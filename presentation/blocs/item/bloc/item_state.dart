import 'package:equatable/equatable.dart';
import 'package:taskora/domain/entities/item_entity.dart';

class ItemSummary extends Equatable {
  final int total;
  final int completed;
  final int pending;
  const ItemSummary({
    required this.total,
    required this.completed,
    required this.pending,
  });
  @override
  List<Object?> get props => [total, completed, pending];
  factory ItemSummary.from(List<ItemEntity> items) {
    final completed = items
        .where((e) => e.status.toLowerCase() == 'completed')
        .length;
    final pending = items.length - completed;
    return ItemSummary(
      total: items.length,
      completed: completed,
      pending: pending,
    );
  }
}

abstract class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<ItemEntity> items;
  final ItemSummary summary;
  final bool fromCache;
  ItemLoaded({
    required this.items,
    required this.summary,
    this.fromCache = false,
  });
  @override
  List<Object?> get props => [items, summary, fromCache];
}

class ItemFailure extends ItemState {
  final String message;
  ItemFailure(this.message);
  @override
  List<Object?> get props => [message];
}
