import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../domain/entities/item_entity.dart';
import '../../core/constants/app_colors.dart';
import 'confirmation_dialogue.dart';

class ItemCard extends StatelessWidget {
  final ItemEntity item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = item.status.toLowerCase() == 'completed';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Chip(
                    label: Text(isCompleted ? 'Completed' : 'Pending'),
                    backgroundColor:
                        (isCompleted ? AppColors.success : AppColors.danger)
                            .withOpacity(.1),
                    labelStyle: TextStyle(
                      color: isCompleted ? AppColors.success : AppColors.danger,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Created: ${_fmt(item.createdDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final confirm = await ConfirmationDialog.show(
                        context: context,
                        title: "Delete Item",
                        message: "Are you sure you want to delete this item?",
                        confirmText: "Delete",
                        confirmColor: Colors.red,
                      );

                      if (confirm == true) {
                        onDelete(); // Calls the callback func from dashboard.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Item deleted successfully"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Symbols.delete_outline),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
