import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ready_go_project/data/data_source/preference/analytics_preference.dart';
import 'package:ready_go_project/domain/entities/accommodation_entity.dart';
import 'package:ready_go_project/domain/entities/account_entity.dart';
import 'package:ready_go_project/domain/entities/image_entity.dart';
import 'package:ready_go_project/domain/entities/plan_entity.dart';
import 'package:ready_go_project/domain/entities/roaming_entity.dart';
import 'package:ready_go_project/domain/entities/supplies_entity.dart';
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
  _getIt.registerSingleton<AccommodationUseCase>(AccommodationUseCase());
  _getIt.registerSingleton<AccountUseCase>(AccountUseCase());
  _getIt.registerSingleton<ImageUseCase>(ImageUseCase());
  _getIt.registerSingleton<PlanUseCase>(PlanUseCase());
  _getIt.registerSingleton<RoamingUseCase>(RoamingUseCase());
  _getIt.registerSingleton<SuppliesUseCase>(SuppliesUseCase());

  //entities
  _getIt.registerSingleton<AccommodationEntity>(AccommodationEntity());
  _getIt.registerSingleton<AccountEntity>(AccountEntity());
  _getIt.registerSingleton<ImageEntity>(ImageEntity());
  _getIt.registerSingleton<PlanEntity>(PlanEntity());
  _getIt.registerSingleton<RoamingEntity>(RoamingEntity());
  _getIt.registerSingleton<SuppliesEntity>(SuppliesEntity());

  FlutterNativeSplash.remove();
}
