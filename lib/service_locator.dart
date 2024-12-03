
import 'package:get_it/get_it.dart';
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

final _getIt = GetIt.instance;
Future<void> serviceLocator()async{
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

}