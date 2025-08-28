import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/domain/entities/item_entity.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_event.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_state.dart';
import 'package:taskora/presentation/widgets/confirmation_dialogue.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isCompleted;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _isCompleted = false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEdit() => setState(() => _isEditing = !_isEditing);

  void _saveChanges(ItemEntity task) {
    final updated = ItemEntity(
      id: task.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _isCompleted ? 'completed' : 'pending',
      createdDate: task.createdDate,
    );

    context.read<ItemBloc>().add(ItemUpdated(updated));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Task updated successfully")));

    setState(() => _isEditing = false);
  }

  void _deleteTask(String id) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: "Delete Task",
      message: "Are you sure you want to delete this task?",
      confirmText: "Delete",
      cancelText: "Cancel",
      confirmColor: Colors.red,
    );

    if (confirmed == true) {
      context.read<ItemBloc>().add(ItemDeleted(id));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task deleted"),
          behavior: SnackBarBehavior.floating,

          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemLoaded) {
          final task = state.items.firstWhere((t) => t.id == widget.taskId);

          //  controllers synced with bloc updates- if not editing
          if (!_isEditing) {
            _titleController.text = task.title;
            _descriptionController.text = task.description;
            _isCompleted = task.status.toLowerCase() == 'completed';
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(_isEditing ? "Edit Task" : "Task Details"),
              actions: [
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _toggleEdit,
                  ),
                if (!_isEditing)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(task.id),
                  ),
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () => _saveChanges(task),
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isEditing
                          ? TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: "Title",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black54,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              task.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                      const SizedBox(height: 16),
                      _isEditing
                          ? TextField(
                              controller: _descriptionController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: "Description",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.black54,
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              task.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text("Pending"),
                            selected: !_isCompleted,
                            onSelected: _isEditing
                                ? (selected) =>
                                      setState(() => _isCompleted = !selected)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text("Completed"),
                            selected: _isCompleted,
                            onSelected: _isEditing
                                ? (selected) =>
                                      setState(() => _isCompleted = selected)
                                : null,
                          ),
                          const Spacer(),
                          Flexible(
                            child: Text(
                              "Created: ${task.createdDate.day}/${task.createdDate.month}/${task.createdDate.year}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
