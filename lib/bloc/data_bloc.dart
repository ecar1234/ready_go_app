import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../domain/entities/provider/purchase_manager.dart';
import '../domain/entities/provider/accommodation_provider.dart';
import '../domain/entities/provider/account_provider.dart';
import '../domain/entities/provider/expectation_provider.dart';
import '../domain/entities/provider/images_provider.dart';
import '../domain/entities/provider/passport_provider.dart';
import '../domain/entities/provider/plan_list_provider.dart';
import '../domain/entities/provider/roaming_provider.dart';
import '../domain/entities/provider/supplies_provider.dart';
import '../domain/use_cases/statistics_use_case.dart';

part 'data_event.dart';

part 'data_state.dart';


class DataBloc extends Bloc<DataEvent, DataState> {
  final logger = Logger();
  DataBloc() : super(DataState(state: DataStatus.beforeCheckPurchases)) {

    on<CheckPurchases>((event, emit) async {
      Set<String> productIds = {'remove_ad.in_app_purchase.cash_3300'};
      event.context.read<PurchaseManager>().loadPurchase();
      event.context.read<PurchaseManager>().loadPastPurchases();
      event.context.read<PurchaseManager>().getPurchases();
      event.context.read<PurchaseManager>().queryProducts(productIds);
      logger.i("service local Data loaded");
      emit(DataState(state: DataStatus.beforeDataLoading));
      add(DataLoadingEvent(context: event.context));
    });

    on<DataLoadingEvent>((event, emit) async {
      // event.context.read<DataBloc>().add(DataLoadingPlanListEvent());
      event.context.read<PlanListProvider>().getPlanList();
      event.context.read<PassportProvider>().getPassImg();
      event.context.read<AccountProvider>().getTotalUseAccountInfo();
      event.context.read<StatisticsUseCase>().getStatisticsData();
      logger.i("service local Data loaded");
      emit(DataState(state: DataStatus.loadedPlanList));
    });

    on<DataLoadingPlanListEvent>((event, emit){
      emit(DataState(state: DataStatus.loadedPlanList));
    });

    on<PlanDataLoadingEvent>((event, emit) {
      event.context.read<ImagesProvider>().getImgList(event.planId);
      event.context.read<SuppliesProvider>().getList(event.planId);
      event.context.read<RoamingProvider>().getRoamingDate(event.planId);
      event.context.read<AccountProvider>().getAccountInfo(event.planId);
      event.context.read<AccommodationProvider>().getAccommodationList(event.planId);
      event.context.read<ExpectationProvider>().getExpectationData(event.planId);
      logger.i("plan Data loaded : plan id ${event.planId}");
      emit(DataState(state: DataStatus.loadedPlan));
    });
    on<DataResetEvent>((event, emit) async {
      emit(DataState(state: DataStatus.endPlan));
    });
  }
}
