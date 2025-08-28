import 'package:taskora/data/repositories/item_repositort.dart';

import '../entities/item_entity.dart';

class AddItem {
  final ItemRepository repo;
  AddItem(this.repo);
  Future<void> call(ItemEntity item) => repo.add(item);
}

class UpdateItem {
  final ItemRepository repo;
  UpdateItem(this.repo);
  Future<void> call(ItemEntity item) => repo.update(item);
}

class DeleteItem {
  final ItemRepository repo;
  DeleteItem(this.repo);
  Future<void> call(String id) => repo.delete(id);
}
