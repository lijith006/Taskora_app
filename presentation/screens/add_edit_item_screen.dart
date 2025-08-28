import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_event.dart';
import '../../domain/entities/item_entity.dart';

class AddEditItemScreen extends StatefulWidget {
  final ItemEntity? item;
  const AddEditItemScreen({super.key, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item != null) {
      _title.text = item.title;
      _desc.text = item.description;
      _status = item.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Item' : 'Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Text('Completed'),
                  ),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'pending'),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (isEdit) {
                        final updated = ItemEntity(
                          id: widget.item!.id,
                          title: _title.text.trim(),
                          description: _desc.text.trim(),
                          status: _status,
                          createdDate: widget.item!.createdDate,
                        );
                        context.read<ItemBloc>().add(ItemUpdated(updated));
                      } else {
                        context.read<ItemBloc>().add(
                          ItemAdded(
                            _title.text.trim(),
                            _desc.text.trim(),
                            _status,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isEdit ? 'Save Changes' : 'Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
