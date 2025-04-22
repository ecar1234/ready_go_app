
part of 'data_bloc.dart';

enum DataStatus {beforeCheckPurchases, beforeDataLoading, beforePlanList, loadedPlanList, beforePlan, loadedPlan, endPlan, loadError}

class DataState {
  DataStatus state;
  DataState({this.state = DataStatus.beforePlanList});
}

// class BeforePlanListLoadingState extends DataState {}
// class PlanListLoadedState extends DataState {}
// class BeforePlanLoadingState extends DataState {}
// class PlanDataLoadedState extends DataState {}
// class EndPlanState extends DataState {}