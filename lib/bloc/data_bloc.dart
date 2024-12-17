import 'package:flutter_bloc/flutter_bloc.dart';

part 'data_event.dart';

part 'data_state.dart';


class DataBloc extends Bloc<DataEvent, DataState> {

  DataBloc() : super(DataState(state: DataStatus.beforePlanList)) {
    on<DataLoadingPlanListEvent>((event, emit) async {
      emit(DataState(state: DataStatus.loadedPlanList));
    });

    on<DataLoadingPlanEvent>((event, emit) {
      emit(DataState(state: DataStatus.loadedPlan));
    });
    on<DataResetEvent>((event, emit) async {
      emit(DataState(state: DataStatus.endPlan));
    });
  }
}
