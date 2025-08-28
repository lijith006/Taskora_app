import 'package:taskora/domain/entities/item_entity.dart';

abstract class ItemRepository {
  Stream<List<ItemEntity>> watchAll();
  Future<List<ItemEntity>> fetchOnce();
  Future<void> add(ItemEntity item);
  Future<void> update(ItemEntity item);
  Future<void> delete(String id);
}
