// application/reports/reports_event.dart

import 'package:taskora/domain/entities/item_entity.dart';

abstract class ReportsEvent {}

class ReportsFilterChanged extends ReportsEvent {
  final String? statusFilter;
  final DateTime? selectedDate;
  ReportsFilterChanged({this.statusFilter, this.selectedDate});
}

class ReportsClearFilters extends ReportsEvent {}

class ReportsToggleSelectAll extends ReportsEvent {
  final List<ItemEntity> items;
  ReportsToggleSelectAll(this.items);
}

class ReportsTaskToggled extends ReportsEvent {
  final String taskId;
  ReportsTaskToggled(this.taskId);
}
