// application/reports/reports_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/presentation/blocs/report_bloc/bloc/report_event.dart';
import 'package:taskora/presentation/blocs/report_bloc/bloc/report_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(ReportsState.initial()) {
    on<ReportsFilterChanged>(_onFilterChanged);
    on<ReportsClearFilters>(_onClearFilters);
    on<ReportsToggleSelectAll>(_onToggleSelectAll);
    on<ReportsTaskToggled>(_onTaskToggled);
  }

  void _onFilterChanged(
    ReportsFilterChanged event,
    Emitter<ReportsState> emit,
  ) {
    emit(
      state.copyWith(
        statusFilter: event.statusFilter ?? state.statusFilter,
        selectedDate: event.selectedDate ?? state.selectedDate,
      ),
    );
  }

  void _onClearFilters(ReportsClearFilters event, Emitter<ReportsState> emit) {
    emit(
      state.copyWith(
        statusFilter: "All",
        selectedDate: null,
        selectedIds: {},
        selectAll: false,
      ),
    );
  }

  void _onToggleSelectAll(
    ReportsToggleSelectAll event,
    Emitter<ReportsState> emit,
  ) {
    if (state.selectAll) {
      emit(state.copyWith(selectedIds: {}, selectAll: false));
    } else {
      final allIds = event.items.map((e) => e.id).toSet();
      emit(state.copyWith(selectedIds: allIds, selectAll: true));
    }
  }

  void _onTaskToggled(ReportsTaskToggled event, Emitter<ReportsState> emit) {
    final updated = Set<String>.from(state.selectedIds);
    if (updated.contains(event.taskId)) {
      updated.remove(event.taskId);
    } else {
      updated.add(event.taskId);
    }
    emit(state.copyWith(selectedIds: updated));
  }
}
