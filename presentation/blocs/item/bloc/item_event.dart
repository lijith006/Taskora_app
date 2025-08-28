import 'package:equatable/equatable.dart';
import 'package:taskora/domain/entities/item_entity.dart';

abstract class ItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemsStarted extends ItemEvent {}

class ItemsRefreshed extends ItemEvent {}

class ItemAdded extends ItemEvent {
  final String title;
  final String description;
  final String status;
  ItemAdded(this.title, this.description, this.status);
}

class ItemUpdated extends ItemEvent {
  final ItemEntity item;
  ItemUpdated(this.item);
}

class ItemDeleted extends ItemEvent {
  final String id;
  ItemDeleted(this.id);
}

class ItemsUpdated extends ItemEvent {
  final List<ItemEntity> items;
  ItemsUpdated(this.items);
}
