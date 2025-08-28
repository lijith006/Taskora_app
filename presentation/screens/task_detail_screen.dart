import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/domain/entities/item_entity.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_event.dart';

class TaskDetailScreen extends StatefulWidget {
  final ItemEntity task;

  const TaskDetailScreen({super.key, required this.task});

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
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _isCompleted = widget.task.status.toLowerCase() == 'completed';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveChanges() {
    final updated = ItemEntity(
      id: widget.task.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _isCompleted ? 'completed' : 'pending',
      createdDate: widget.task.createdDate,
    );

    context.read<ItemBloc>().add(ItemUpdated(updated));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Task updated successfully")));

    setState(() => _isEditing = false);
  }

  void _deleteTask() {
    context.read<ItemBloc>().add(ItemDeleted(widget.task.id));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Task deleted"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Edit Task" : "Task Details"),
        actions: [
          if (!_isEditing)
            IconButton(icon: const Icon(Icons.edit), onPressed: _toggleEdit),
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteTask,
            ),
          if (_isEditing)
            IconButton(icon: const Icon(Icons.save), onPressed: _saveChanges),
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
                        decoration: const InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Text(
                        widget.task.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                const SizedBox(height: 16),
                _isEditing
                    ? TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                        ),
                      )
                    : Text(
                        widget.task.description,
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
                        "Created: ${widget.task.createdDate.day}/${widget.task.createdDate.month}/${widget.task.createdDate.year}",
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
}
