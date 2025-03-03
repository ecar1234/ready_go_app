import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ready_go_project/data/data_source/plan_data_impl.dart';
import 'package:ready_go_project/data/data_source/preference/analytics_preference.dart';
import 'package:ready_go_project/data/data_source/accommodation_data_impl.dart';
import 'package:ready_go_project/data/data_source/account_data_impl.dart';
import 'package:ready_go_project/data/data_source/image_data_impl.dart';
import 'package:ready_go_project/data/data_source/roaming_data_impl.dart';
import 'package:ready_go_project/data/data_source/supplies_data_impl.dart';
import 'package:ready_go_project/data/repositories/accommodation_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/account_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/image_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/roaming_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/supplies_local_data_repo.dart';
import 'package:ready_go_project/domain/repositories/accommodation_repo.dart';
import 'package:ready_go_project/domain/repositories/account_repo.dart';
import 'package:ready_go_project/domain/repositories/image_repo.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';
import 'package:ready_go_project/domain/repositories/roaming_repo.dart';
import 'package:ready_go_project/domain/repositories/supplies_repo.dart';

import 'package:ready_go_project/domain/use_cases/accommodation_use_case.dart';
import 'package:ready_go_project/domain/use_cases/account_use_case.dart';
import 'package:ready_go_project/domain/use_cases/image_use_case.dart';
import 'package:ready_go_project/domain/use_cases/plan_use_case.dart';
import 'package:ready_go_project/domain/use_cases/roaming_use_case.dart';
import 'package:ready_go_project/domain/use_cases/supplies_use_case.dart';
import 'package:ready_go_project/firebase/firebase_options.dart';

final _getIt = GetIt.instance;

AnalyticsPreference get pref => AnalyticsPreference.singleton;

Future<void> serviceLocator() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await pref.checkIsFirst();
  await MobileAds.instance.initialize();

  //useCases
  _getIt.registerSingleton<AccommodationRepo>(AccommodationUseCase());
  _getIt.registerSingleton<AccountRepo>(AccountUseCase());
  _getIt.registerSingleton<ImageRepo>(ImageUseCase());
  _getIt.registerSingleton<PlanRepo>(PlanUseCase());
  _getIt.registerSingleton<RoamingRepo>(RoamingUseCase());
  _getIt.registerSingleton<SuppliesRepo>(SuppliesUseCase());

  //data
  _getIt.registerLazySingleton<AccommodationLocalDateRepo>(() => AccommodationDataImpl());
  _getIt.registerLazySingleton<AccountLocalDataRepo>(() => AccountDataImpl());
  _getIt.registerLazySingleton<ImageLocalDataRepo>(() => ImageDataImpl());
  _getIt.registerLazySingleton<PlanLocalDataRepo>(() => PlanDataImpl());
  _getIt.registerLazySingleton<RoamingLocalDataRepo>(() => RoamingDataImpl());
  _getIt.registerLazySingleton<SuppliesLocalDataRepo>(() => SuppliesDataImpl());
  Future.delayed(const Duration(seconds: 2));

  FlutterNativeSplash.remove();
}
