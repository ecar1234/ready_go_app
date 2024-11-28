
import 'package:get_it/get_it.dart';

import 'package:ready_go_project/domain/use_cases/accommodation_data_use_case.dart';
import 'package:ready_go_project/domain/use_cases/account_data_use_case.dart';
import 'package:ready_go_project/domain/use_cases/image_data_use_case.dart';
import 'package:ready_go_project/domain/use_cases/plan_data_use_case.dart';
import 'package:ready_go_project/domain/use_cases/roaming_data_use_case.dart';
import 'package:ready_go_project/domain/use_cases/supplies_data_use_case.dart';

import 'data/data_source/preference/preference_provider.dart';

final _getIt = GetIt.instance;

PreferenceProvider get pref => PreferenceProvider.singleton;
Future<void> serviceLocator()async{

  // _getIt.registerSingleton<PlanListProvider>(PlanListProvider());
  // _getIt.registerSingleton<ImagesProvider>(ImagesProvider());
  // _getIt.registerSingleton<SuppliesProvider>(SuppliesProvider());
  // _getIt.registerSingleton<RoamingProvider>(RoamingProvider());
  // _getIt.registerSingleton<AccountProvider>(AccountProvider());
  // _getIt.registerSingleton<AccommodationProvider>(AccommodationProvider());

  _getIt.registerSingleton<PlanDataUseCase>(PlanDataUseCase());
  _getIt.registerSingleton<ImageDataUseCase>(ImageDataUseCase());
  _getIt.registerSingleton<SuppliesDataUseCase>(SuppliesDataUseCase());
  _getIt.registerSingleton<RoamingDataUseCase>(RoamingDataUseCase());
  _getIt.registerSingleton<AccountDataUseCase>(AccountDataUseCase());
  _getIt.registerSingleton<AccommodationDataUseCase>(AccommodationDataUseCase());

}