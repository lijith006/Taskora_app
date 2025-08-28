import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

abstract class ItemRemoteDataSource {
  Stream<List<ItemModel>> watchItems();
  Future<List<ItemModel>> fetchItems();
  Future<void> addItem(ItemModel model);
  Future<void> updateItem(ItemModel model);
  Future<void> deleteItem(String id);
}

class ItemRemoteDataSourceImpl implements ItemRemoteDataSource {
  final FirebaseFirestore _db;
  ItemRemoteDataSourceImpl(this._db);

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('items');

  @override
  Stream<List<ItemModel>> watchItems() {
    // Firestore offers offline persistence out of the box
    return _col
        .orderBy('createdDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ItemModel.fromDoc).toList());
  }

  @override
  Future<List<ItemModel>> fetchItems() async {
    final snap = await _col.orderBy('createdDate', descending: true).get();
    return snap.docs.map(ItemModel.fromDoc).toList();
  }

  @override
  Future<void> addItem(ItemModel model) async {
    await _col.add(model.toMap());
  }

  @override
  Future<void> updateItem(ItemModel model) async {
    await _col.doc(model.id).update(model.toMap());
  }

  @override
  Future<void> deleteItem(String id) async {
    await _col.doc(id).delete();
  }
}
