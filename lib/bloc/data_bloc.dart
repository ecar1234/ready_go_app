import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/use_cases/plan_data_use_case.dart';

part 'data_event.dart';

part 'data_state.dart';


class DataBloc extends Bloc<DataEvent, DataState> {
  final GetIt _getIt = GetIt.I;

  DataBloc() : super(DataState(state: DataStatus.beforePlanList)) {
    on<DataLoadingPlanListEvent>((event, emit) async {
      emit(DataState(state: DataStatus.loadedPlanList));
    });

    on<DataLoadingPlanEvent>((event, emit) {
      emit(DataState(state: DataStatus.loadedPlan));
    });

  }
}
