import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_event.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_state.dart';
import '../widgets/item_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Tasks')),
      body: RefreshIndicator(
        onRefresh: () async => context.read<ItemBloc>().add(ItemsRefreshed()),
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading || state is ItemInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ItemFailure) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is ItemLoaded) {
              final items = state.items;
              if (items.isEmpty) {
                return Center(child: Text('No tasks available'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final e = items[index];
                  return ItemCard(
                    item: e,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: e.id,
                    ),
                    onDelete: () =>
                        context.read<ItemBloc>().add(ItemDeleted(e.id)),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
