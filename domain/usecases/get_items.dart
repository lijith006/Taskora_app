import 'package:taskora/data/repositories/item_repositort.dart';

import '../entities/item_entity.dart';

class WatchItems {
  final ItemRepository repo;
  WatchItems(this.repo);
  Stream<List<ItemEntity>> call() => repo.watchAll();
}

class FetchItemsOnce {
  final ItemRepository repo;
  FetchItemsOnce(this.repo);
  Future<List<ItemEntity>> call() => repo.fetchOnce();
}
