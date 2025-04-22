
part of 'data_bloc.dart';
class DataEvent {}

class CheckPurchases extends DataEvent {
  BuildContext context;
  CheckPurchases({required this.context});
}

class DataLoadingEvent extends DataEvent {
  BuildContext context;
  DataLoadingEvent({required this.context});
}
class DataLoadingPlanListEvent extends DataEvent {

}
class PlanDataLoadingEvent extends DataEvent {
  BuildContext context;
  int planId;
  PlanDataLoadingEvent({required this.context, required this.planId});
  // int planId;
  // DataLoadingPlanEvent({required this.planId});
}
class DataResetEvent extends DataEvent {}