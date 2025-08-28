import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_event.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_state.dart';
import '../../core/constants/app_colors.dart';

import '../widgets/summary_card.dart';
import '../widgets/item_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: RefreshIndicator(
        onRefresh: () async => context.read<ItemBloc>().add(ItemsRefreshed()),
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading || state is ItemInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ItemFailure) {
              return _ErrorState(message: state.message);
            }
            if (state is ItemLoaded) {
              final s = state.summary;
              final items = state.items;
              if (items.isEmpty) {
                return _EmptyState(onAdd: () => _openAdd(context));
              }
              // Show only last 5 tasks
              final recentTasks = items.length > 5
                  ? items.sublist(items.length - 5)
                  : items;

              //List view recent items
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.8,
                    //Summary Cards
                    children: [
                      SummaryCard(
                        title: 'Total Items',
                        value: s.total.toString(),
                        icon: Icons.all_inbox,
                      ),
                      SummaryCard(
                        title: 'Completed',
                        value: s.completed.toString(),
                        icon: Icons.check_circle,
                        // ignore: deprecated_member_use
                        chipColor: AppColors.success.withOpacity(.2),
                      ),
                      SummaryCard(
                        title: 'Pending',
                        value: s.pending.toString(),
                        icon: Icons.pending_actions,
                        // ignore: deprecated_member_use
                        chipColor: AppColors.danger.withOpacity(.2),
                      ),
                      SummaryCard(
                        title: 'Last Updated',
                        value: _relativeNow(),
                        icon: Icons.update,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recent Tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  //Recent task calling
                  ...recentTasks.map(
                    (e) => ItemCard(
                      item: e,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/detail',
                        arguments: e.id,
                      ),
                      onDelete: () =>
                          context.read<ItemBloc>().add(ItemDeleted(e.id)),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _openAdd(context),
      //   backgroundColor: AppColors.primary,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  void _openAdd(BuildContext context) => Navigator.pushNamed(context, '/add');

  String _relativeNow() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 64),
          const SizedBox(height: 12),
          const Text('No items yet'),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add your first item'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 12),
            Text('Something went wrong\n$message', textAlign: TextAlign.center),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => context.read<ItemBloc>().add(ItemsStarted()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
