import 'package:taskora/data/repositories/item_repositort.dart';

import '../../domain/entities/item_entity.dart';
import '../data_sources/item_remote_data_source.dart';
import '../models/item_model.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemRemoteDataSource remote;
  ItemRepositoryImpl(this.remote);

  @override
  Stream<List<ItemEntity>> watchAll() => remote.watchItems();

  @override
  Future<List<ItemEntity>> fetchOnce() => remote.fetchItems();

  @override
  Future<void> add(ItemEntity item) => remote.addItem(_toModel(item));

  @override
  Future<void> delete(String id) => remote.deleteItem(id);

  @override
  Future<void> update(ItemEntity item) => remote.updateItem(_toModel(item));

  ItemModel _toModel(ItemEntity e) => ItemModel(
    id: e.id,
    title: e.title,
    description: e.description,
    status: e.status,
    createdDate: e.createdDate,
  );
}
