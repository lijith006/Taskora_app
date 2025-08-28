import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_state.dart';
import 'package:taskora/presentation/widgets/custom_button.dart';
import '../../domain/entities/item_entity.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final Set<String> _selectedIds = {}; // track selected tasks
  bool _selectAll = false;

  void _toggleSelectAll(List<ItemEntity> items) {
    setState(() {
      _selectAll = !_selectAll;
      if (_selectAll) {
        _selectedIds.addAll(items.map((e) => e.id));
      } else {
        _selectedIds.clear();
      }
    });
  }

  void _openExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Export as PDF"),
              onTap: () {
                Navigator.pop(context);
                _export("pdf");
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text("Export as CSV"),
              onTap: () {
                Navigator.pop(context);
                _export("csv");
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on),
              title: const Text("Export as Excel"),
              onTap: () {
                Navigator.pop(context);
                _export("excel");
              },
            ),
          ],
        ),
      ),
    );
  }

  void _export(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Exporting ${_selectedIds.length} tasks as $format..."),
      ),
    );
    // TODO: implement actual export logic using pdf, csv, or excel package
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading || state is ItemInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ItemLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const Center(child: Text("No tasks available"));
            }

            return Column(
              children: [
                // 🔹 Filters placeholder
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {}, // TODO: Date filter
                        icon: const Icon(Icons.date_range),
                        label: const Text("Date"),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: "All",
                        items: const [
                          DropdownMenuItem(value: "All", child: Text("All")),
                          DropdownMenuItem(
                            value: "Completed",
                            child: Text("Completed"),
                          ),
                          DropdownMenuItem(
                            value: "Pending",
                            child: Text("Pending"),
                          ),
                        ],
                        onChanged: (v) {},
                      ),
                    ],
                  ),
                ),

                // 🔹 Select All
                CheckboxListTile(
                  value: _selectAll,
                  onChanged: (_) => _toggleSelectAll(items),
                  title: const Text("Select All"),
                ),

                // 🔹 Task list with checkboxes
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final task = items[i];
                      final isChecked = _selectedIds.contains(task.id);
                      return CheckboxListTile(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedIds.add(task.id);
                            } else {
                              _selectedIds.remove(task.id);
                            }
                          });
                        },
                        title: Text(task.title),
                        subtitle: Text(task.status),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),

      // 🔹 Sticky Export Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          text: "Export",
          onPressed: _selectedIds.isEmpty
              ? null
              : () => _openExportOptions(context),
          backgroundColor: _selectedIds.isEmpty ? Colors.grey : Colors.black87,
          isLoading: false,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.download, color: Colors.white),
              SizedBox(width: 8),
              Text("Export"),
            ],
          ),
        ),
      ),
    );
  }
}
