import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/provider/purchase_manager.dart';
import 'package:ready_go_project/domain/entities/provider/expectation_provider.dart';
import 'package:ready_go_project/domain/entities/provider/plan_favorites_provider.dart';
import 'package:ready_go_project/domain/entities/provider/schedule_provider.dart';
import 'package:ready_go_project/domain/entities/provider/supplies_template_provider.dart';
import 'package:ready_go_project/domain/use_cases/statistics_use_case.dart';
import 'package:ready_go_project/presentation/main_page.dart';

import 'domain/entities/provider/accommodation_provider.dart';
import 'domain/entities/provider/account_provider.dart';
import 'domain/entities/provider/admob_provider.dart';
import 'domain/entities/provider/images_provider.dart';
import 'domain/entities/provider/passport_provider.dart';
import 'domain/entities/provider/plan_list_provider.dart';
import 'domain/entities/provider/roaming_provider.dart';
import 'domain/entities/provider/supplies_provider.dart';
import 'domain/entities/provider/theme_mode_provider.dart';
import 'service_locator.dart';



void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await serviceLocator();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => PlanListProvider()),
      ChangeNotifierProvider(create: (_) => ImagesProvider()),
      ChangeNotifierProvider(create: (_) => SuppliesProvider()),
      ChangeNotifierProvider(create: (_) => RoamingProvider()),
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => AccommodationProvider()),
      ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
      ChangeNotifierProvider(create: (_) => AdmobProvider()),
      ChangeNotifierProvider(create: (_) => PassportProvider()),
      ChangeNotifierProvider(create: (_) => SuppliesTemplateProvider()),
      ChangeNotifierProvider(create: (_) => PlanFavoritesProvider()),
      ChangeNotifierProvider(create: (_) => StatisticsUseCase()),
      ChangeNotifierProvider(create: (_) => ExpectationProvider()),
      ChangeNotifierProvider(create: (_) => PurchaseManager()),
      ChangeNotifierProvider(create: (_) => ScheduleProvider()),

      // ChangeNotifierProvider(create: (_) => ResponsiveHeightProvider())
    ],
    child: const MainPage(),)
  );
}
