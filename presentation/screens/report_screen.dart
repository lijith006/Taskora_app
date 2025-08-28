import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskora/data/data_sources/export_services.dart';
import 'package:taskora/domain/entities/item_entity.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_bloc.dart';
import 'package:taskora/presentation/blocs/item/bloc/item_state.dart';
import 'package:taskora/presentation/blocs/report_bloc/bloc/report_state.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportsState _state = ReportsState.initial();
  final _exportService = ExportService();

  //  filters
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _state = _state.copyWith(selectedDate: picked);
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _state = ReportsState.initial();
    });
  }

  List<ItemEntity> _applyFilters(List<ItemEntity> items) {
    var filtered = items;

    if (_state.statusFilter != "All") {
      filtered = filtered
          .where(
            (e) => e.status.toLowerCase() == _state.statusFilter.toLowerCase(),
          )
          .toList();
    }

    if (_state.selectedDate != null) {
      filtered = filtered.where((e) {
        return e.createdDate.year == _state.selectedDate!.year &&
            e.createdDate.month == _state.selectedDate!.month &&
            e.createdDate.day == _state.selectedDate!.day;
      }).toList();
    }

    return filtered;
  }

  void _toggleSelectAll(List<ItemEntity> items) {
    setState(() {
      final newSelectAll = !_state.selectAll;
      _state = _state.copyWith(
        selectAll: newSelectAll,
        selectedIds: newSelectAll ? items.map((e) => e.id).toSet() : <String>{},
      );
    });
  }

  void _toggleTask(String taskId) {
    final newIds = Set<String>.from(_state.selectedIds);
    if (newIds.contains(taskId)) {
      newIds.remove(taskId);
    } else {
      newIds.add(taskId);
    }
    setState(() {
      _state = _state.copyWith(selectedIds: newIds);
    });
  }

  // export options
  void _openExportOptions(List<ItemEntity> selectedItems) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("Export as PDF"),
              onTap: () async {
                Navigator.pop(context);
                final path = await _exportService.exportPDF(selectedItems);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("PDF exported: $path")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text("Export as CSV"),
              onTap: () async {
                Navigator.pop(context);
                final path = await _exportService.exportCSV(selectedItems);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("CSV exported: $path")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on),
              title: const Text("Export as Excel"),
              onTap: () async {
                Navigator.pop(context);
                final path = await _exportService.exportExcel(selectedItems);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Excel exported: $path")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //  UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        // Clear
        actions: [
          if (_state.selectedDate != null || _state.statusFilter != "All")
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear, color: Colors.red),
              label: const Text("Clear", style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading || state is ItemInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ItemLoaded) {
            final filtered = _applyFilters(state.items);

            if (filtered.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No tasks available"),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.clear),
                      label: const Text("Clear Filters"),
                      onPressed: _clearFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }

            final selectedItems = filtered
                .where((e) => _state.selectedIds.contains(e.id))
                .toList();

            return Column(
              children: [
                // Filters Row
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _state.selectedDate == null
                              ? "Date"
                              : DateFormat.yMMMd().format(_state.selectedDate!),
                        ),
                      ),
                      DropdownButton<String>(
                        value: _state.statusFilter,
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
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _state = _state.copyWith(statusFilter: v);
                            });
                          }
                        },
                      ),
                      //  Clear Filters in the filter row -if filters are active
                      if (_state.selectedDate != null ||
                          _state.statusFilter != "All")
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(Icons.clear),
                          label: const Text("Clear"),
                          onPressed: _clearFilters,
                        ),
                    ],
                  ),
                ),

                //  Select All
                CheckboxListTile(
                  value: _state.selectAll,
                  onChanged: (_) => _toggleSelectAll(filtered),
                  title: const Text("Select All"),
                ),

                //  List with Checkboxes
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final task = filtered[i];
                      final isChecked = _state.selectedIds.contains(task.id);
                      return CheckboxListTile(
                        value: isChecked,
                        onChanged: (_) => _toggleTask(task.id),
                        title: Text(task.title),
                        subtitle: Text(
                          "${task.status} • ${DateFormat.yMMMd().format(task.createdDate)}",
                        ),
                      );
                    },
                  ),
                ),

                //  Export Button
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text("Export"),
                    onPressed: selectedItems.isEmpty
                        ? null
                        : () => _openExportOptions(selectedItems),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// import 'dart:io';
// import 'package:csv/csv.dart';
// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import '../../domain/entities/item_entity.dart';
// import '../../presentation/blocs/item/bloc/item_bloc.dart';
// import '../../presentation/blocs/item/bloc/item_state.dart';
// import '../../presentation/widgets/custom_button.dart';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {
//   final Set<String> _selectedIds = {}; // track selected tasks..
//   bool _selectAll = false;

//   // filters
//   String _statusFilter = "All";
//   DateTime? _selectedDate;

//   void _toggleSelectAll(List<ItemEntity> items) {
//     setState(() {
//       _selectAll = !_selectAll;
//       if (_selectAll) {
//         _selectedIds.addAll(items.map((e) => e.id));
//       } else {
//         _selectedIds.clear();
//       }
//     });
//   }

//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   List<ItemEntity> _applyFilters(List<ItemEntity> items) {
//     var filtered = items;

//     // status filter
//     if (_statusFilter != "All") {
//       filtered = filtered
//           .where((e) => e.status.toLowerCase() == _statusFilter.toLowerCase())
//           .toList();
//     }

//     // date filter
//     if (_selectedDate != null) {
//       filtered = filtered.where((e) {
//         return e.createdDate.year == _selectedDate!.year &&
//             e.createdDate.month == _selectedDate!.month &&
//             e.createdDate.day == _selectedDate!.day;
//       }).toList();
//     }

//     return filtered;
//   }

//   // Export Methods

//   Future<void> _exportPDF(List<ItemEntity> items) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Table.fromTextArray(
//           headers: ['ID', 'Title', 'Status', 'Date'],
//           data: items.map((e) {
//             return [
//               e.id,
//               e.title,
//               e.status,
//               DateFormat.yMMMd().format(e.createdDate),
//             ];
//           }).toList(),
//         ),
//       ),
//     );

//     final bytes = await pdf.save();
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File("${dir.path}/report.pdf");
//     await file.writeAsBytes(bytes);

//     await Printing.sharePdf(bytes: bytes, filename: 'report.pdf');
//   }

//   Future<void> _exportCSV(List<ItemEntity> items) async {
//     final data = [
//       ['ID', 'Title', 'Status', 'Date'],
//       ...items.map(
//         (e) => [
//           e.id,
//           e.title,
//           e.status,
//           DateFormat.yMMMd().format(e.createdDate),
//         ],
//       ),
//     ];

//     String csvData = const ListToCsvConverter().convert(data);

//     final dir = await getApplicationDocumentsDirectory();
//     final file = File("${dir.path}/report.csv");
//     await file.writeAsString(csvData);

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("CSV Exported: ${file.path}")));
//   }

//   Future<void> _exportExcel(List<ItemEntity> items) async {
//     var excel = Excel.createExcel();
//     Sheet sheet = excel['Report'];

//     sheet.appendRow(['ID', 'Title', 'Status', 'Date']);
//     for (var e in items) {
//       sheet.appendRow([
//         e.id,
//         e.title,
//         e.status,
//         DateFormat.yMMMd().format(e.createdDate),
//       ]);
//     }

//     final dir = await getApplicationDocumentsDirectory();
//     final file = File("${dir.path}/report.xlsx");
//     await file.writeAsBytes(excel.encode()!);

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text("Excel Exported: ${file.path}")));
//   }

//   void _openExportOptions(List<ItemEntity> selectedItems) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.picture_as_pdf),
//               title: const Text("Export as PDF"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _exportPDF(selectedItems);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.table_chart),
//               title: const Text("Export as CSV"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _exportCSV(selectedItems);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.grid_on),
//               title: const Text("Export as Excel"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _exportExcel(selectedItems);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------- UI Build ----------

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Reports")),
//       body: BlocBuilder<ItemBloc, ItemState>(
//         builder: (context, state) {
//           if (state is ItemLoading || state is ItemInitial) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ItemLoaded) {
//             var items = _applyFilters(state.items);

//             if (items.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("No tasks available"),
//                     const SizedBox(height: 12),
//                     ElevatedButton.icon(
//                       icon: const Icon(Icons.clear),
//                       label: const Text("Clear Filters"),
//                       onPressed: () {
//                         setState(() {
//                           _statusFilter = "All";
//                           _selectedDate = null;
//                           _selectAll = false;
//                           _selectedIds.clear();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             }

//             final selectedItems = items
//                 .where((e) => _selectedIds.contains(e.id))
//                 .toList();

//             return Column(
//               children: [
//                 // 🔹 Filters row
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: _pickDate,
//                         icon: const Icon(Icons.date_range),
//                         label: Text(
//                           _selectedDate == null
//                               ? "Date"
//                               : DateFormat.yMMMd().format(_selectedDate!),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       DropdownButton<String>(
//                         value: _statusFilter,
//                         items: const [
//                           DropdownMenuItem(value: "All", child: Text("All")),
//                           DropdownMenuItem(
//                             value: "Completed",
//                             child: Text("Completed"),
//                           ),
//                           DropdownMenuItem(
//                             value: "Pending",
//                             child: Text("Pending"),
//                           ),
//                         ],
//                         onChanged: (v) {
//                           if (v != null) {
//                             setState(() => _statusFilter = v);
//                           }
//                         },
//                       ),
//                       const SizedBox(width: 8),

//                       // 🔹  Clear Filters button (always visible)
//                       if (_selectedDate != null || _statusFilter != "All")
//                         ElevatedButton.icon(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                           ),
//                           icon: const Icon(Icons.clear),
//                           label: const Text("Clear"),
//                           onPressed: () {
//                             setState(() {
//                               _statusFilter = "All";
//                               _selectedDate = null;
//                               _selectAll = false;
//                               _selectedIds.clear();
//                             });
//                           },
//                         ),
//                     ],
//                   ),
//                 ),

//                 // 🔹 Select All
//                 CheckboxListTile(
//                   value: _selectAll,
//                   onChanged: (_) => _toggleSelectAll(items),
//                   title: const Text("Select All"),
//                 ),

//                 // 🔹 Task list with checkboxes
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (_, i) {
//                       final task = items[i];
//                       final isChecked = _selectedIds.contains(task.id);
//                       return CheckboxListTile(
//                         value: isChecked,
//                         onChanged: (val) {
//                           setState(() {
//                             if (val == true) {
//                               _selectedIds.add(task.id);
//                             } else {
//                               _selectedIds.remove(task.id);
//                             }
//                           });
//                         },
//                         title: Text(task.title),
//                         subtitle: Text(
//                           "${task.status} • ${DateFormat.yMMMd().format(task.createdDate)}",
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 // 🔹 Export Button
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: CustomButton(
//                     text: "Export",
//                     onPressed: selectedItems.isEmpty
//                         ? null
//                         : () => _openExportOptions(selectedItems),
//                     backgroundColor: selectedItems.isEmpty
//                         ? Colors.grey
//                         : Colors.black87,
//                     isLoading: false,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.download, color: Colors.white),
//                         SizedBox(width: 8),
//                         Text("Export"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }
//-------------------------------------------------------------------------------
