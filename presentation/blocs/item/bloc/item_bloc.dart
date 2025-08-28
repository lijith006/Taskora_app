import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/domain/entities/item_entity.dart';
import 'package:taskora/domain/usecases/get_items.dart';
import 'package:taskora/domain/usecases/mutate_items.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_event.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final WatchItems watchItems;
  final FetchItemsOnce fetchOnce;
  final AddItem addItem;
  final UpdateItem updateItem;
  final DeleteItem deleteItem;

  StreamSubscription<List<ItemEntity>>? _sub;

  ItemBloc({
    required this.watchItems,
    required this.fetchOnce,
    required this.addItem,
    required this.updateItem,
    required this.deleteItem,
  }) : super(ItemInitial()) {
    on<ItemsStarted>(_onStarted);
    on<ItemsRefreshed>(_onRefreshed);
    on<ItemAdded>(_onAdded);
    on<ItemUpdated>(_onUpdated);
    on<ItemDeleted>(_onDeleted);
    on<ItemsUpdated>(_onUpdatedFromStream);
  }

  Future<void> _onStarted(ItemsStarted event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    await _sub?.cancel();
    _sub = watchItems().listen(
      (items) {
        add(ItemsUpdated(items));
      },
      onError: (e) {
        addError(e); // optional
      },
    );
  }

  Future<void> _onUpdatedFromStream(
    ItemsUpdated event,
    Emitter<ItemState> emit,
  ) async {
    final summary = ItemSummary.from(event.items);
    emit(ItemLoaded(items: event.items, summary: summary));
  }

  Future<void> _onRefreshed(
    ItemsRefreshed event,
    Emitter<ItemState> emit,
  ) async {
    //  force fetch once -will populate cache & show latest
    try {
      final items = await fetchOnce();
      final summary = ItemSummary.from(items);
      emit(ItemLoaded(items: items, summary: summary));
    } catch (_) {
      // Keep current state; Firestore offline cache will still feed the stream
    }
  }

  Future<void> _onAdded(ItemAdded event, Emitter<ItemState> emit) async {
    final entity = ItemEntity(
      id: '',
      title: event.title,
      description: event.description,
      status: event.status,
      createdDate: DateTime.now(),
    );
    await addItem(entity);
  }

  // Future<void> _onUpdated(ItemUpdated event, Emitter<ItemState> emit) async {
  //   await updateItem(event.item);
  // }
  Future<void> _onUpdated(ItemUpdated event, Emitter<ItemState> emit) async {
    await updateItem(event.item);

    //  updates UI
    if (state is ItemLoaded) {
      final current = state as ItemLoaded;

      final updatedItems = current.items.map((item) {
        return item.id == event.item.id ? event.item : item;
      }).toList();

      emit(
        ItemLoaded(
          items: updatedItems,
          summary: ItemSummary.from(updatedItems),
          fromCache: current.fromCache,
        ),
      );
    }
  }

  Future<void> _onDeleted(ItemDeleted event, Emitter<ItemState> emit) async {
    await deleteItem(event.id);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
