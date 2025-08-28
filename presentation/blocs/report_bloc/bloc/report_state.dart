// application/reports/reports_state.dart

class ReportsState {
  final String statusFilter;
  final DateTime? selectedDate;
  final Set<String> selectedIds;
  final bool selectAll;

  ReportsState({
    required this.statusFilter,
    required this.selectedDate,
    required this.selectedIds,
    required this.selectAll,
  });

  factory ReportsState.initial() => ReportsState(
    statusFilter: "All",
    selectedDate: null,
    selectedIds: {},
    selectAll: false,
  );

  ReportsState copyWith({
    String? statusFilter,
    DateTime? selectedDate,
    Set<String>? selectedIds,
    bool? selectAll,
  }) {
    return ReportsState(
      statusFilter: statusFilter ?? this.statusFilter,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedIds: selectedIds ?? this.selectedIds,
      selectAll: selectAll ?? this.selectAll,
    );
  }
}
