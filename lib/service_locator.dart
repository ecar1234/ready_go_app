import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ready_go_project/data/data_source/purchases_data_impl.dart';
import 'package:ready_go_project/data/repositories/purchases_local_data_repo.dart';
import 'package:ready_go_project/domain/entities/provider/purchase_manager.dart';
import 'package:ready_go_project/data/data_source/expectation_data_impl.dart';
import 'package:ready_go_project/data/data_source/plan_data_impl.dart';
import 'package:ready_go_project/data/data_source/preference/analytics_preference.dart';
import 'package:ready_go_project/data/data_source/accommodation_data_impl.dart';
import 'package:ready_go_project/data/data_source/account_data_impl.dart';
import 'package:ready_go_project/data/data_source/image_data_impl.dart';
import 'package:ready_go_project/data/data_source/roaming_data_impl.dart';
import 'package:ready_go_project/data/data_source/supplies_data_impl.dart';
import 'package:ready_go_project/data/data_source/supplies_temp_data_impl.dart';
import 'package:ready_go_project/data/repositories/accommodation_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/account_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/expectation_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/image_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/roaming_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/supplies_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/supplies_temp_local_repo.dart';
import 'package:ready_go_project/domain/entities/provider/plan_favorites_provider.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/domain/repositories/accommodation_repo.dart';
import 'package:ready_go_project/domain/repositories/account_repo.dart';
import 'package:ready_go_project/domain/repositories/expectation_repo.dart';
import 'package:ready_go_project/domain/repositories/image_repo.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';
import 'package:ready_go_project/domain/repositories/purchases_repo.dart';
import 'package:ready_go_project/domain/repositories/roaming_repo.dart';
import 'package:ready_go_project/domain/repositories/supplies_repo.dart';
import 'package:ready_go_project/domain/repositories/supplies_temp_repo.dart';

import 'package:ready_go_project/domain/use_cases/accommodation_use_case.dart';
import 'package:ready_go_project/domain/use_cases/account_use_case.dart';
import 'package:ready_go_project/domain/use_cases/expectation_use_case.dart';
import 'package:ready_go_project/domain/use_cases/image_use_case.dart';
import 'package:ready_go_project/domain/use_cases/plan_use_case.dart';
import 'package:ready_go_project/domain/use_cases/purchases_manager_use_case.dart';
import 'package:ready_go_project/domain/use_cases/roaming_use_case.dart';
import 'package:ready_go_project/domain/use_cases/statistics_use_case.dart';
import 'package:ready_go_project/domain/use_cases/supplies_temp_use_case.dart';
import 'package:ready_go_project/domain/use_cases/supplies_use_case.dart';
import 'package:ready_go_project/firebase/firebase_options.dart';

final _getIt = GetIt.instance;

AnalyticsPreference get pref => AnalyticsPreference.singleton;
final Logger logger = Logger();
Future<void> serviceLocator() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await pref.checkIsFirst();
  await MobileAds.instance.initialize();
  FirebaseRemoteConfig remote = FirebaseRemoteConfig.instance;
  await remote.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remote.fetchAndActivate();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  debugPrint("app name : $appName");
  debugPrint("packageName : $packageName");
  debugPrint("version : $version");
  debugPrint("buildNumber : $buildNumber");


  //useCases
  _getIt.registerSingleton<AccommodationRepo>(AccommodationUseCase());
  _getIt.registerSingleton<AccountRepo>(AccountUseCase());
  _getIt.registerSingleton<ImageRepo>(ImageUseCase());
  _getIt.registerSingleton<PlanRepo>(PlanUseCase());
  _getIt.registerSingleton<RoamingRepo>(RoamingUseCase());
  _getIt.registerSingleton<SuppliesRepo>(SuppliesUseCase());
  _getIt.registerSingleton<SuppliesTempRepo>(SuppliesTempUseCase());
  _getIt.registerSingleton<ExpectationRepo>(ExpectationUseCase());
  _getIt.registerSingleton<PurchasesRepo>(PurchasesManagerUseCase());

  //data
  _getIt.registerLazySingleton<AccommodationLocalDateRepo>(() => AccommodationDataImpl());
  _getIt.registerLazySingleton<AccountLocalDataRepo>(() => AccountDataImpl());
  _getIt.registerLazySingleton<ImageLocalDataRepo>(() => ImageDataImpl());
  _getIt.registerLazySingleton<PlanLocalDataRepo>(() => PlanDataImpl());
  _getIt.registerLazySingleton<RoamingLocalDataRepo>(() => RoamingDataImpl());
  _getIt.registerLazySingleton<SuppliesLocalDataRepo>(() => SuppliesDataImpl());
  _getIt.registerLazySingleton<SuppliesTempLocalRepo>(() => SuppliesTempDataImpl());
  _getIt.registerLazySingleton<ExpectationLocalDataRepo>(() => ExpectationDataImpl());
  _getIt.registerLazySingleton<PurchasesLocalDataRepo>(() => PurchasesDataImpl());

  // favorite
  _getIt.registerLazySingleton<PlanFavoritesProvider>(() => PlanFavoritesProvider());
  // body hei
  _getIt.registerLazySingleton<ResponsiveHeightProvider>(() => ResponsiveHeightProvider());
  // statistics
  // _getIt.registerLazySingleton<StatisticsUseCase>(() => StatisticsUseCase());

  FlutterNativeSplash.remove();
}
