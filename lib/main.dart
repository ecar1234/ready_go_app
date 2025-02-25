import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
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
      ChangeNotifierProvider(create: (_) => PassportProvider())
    ],
    child: const MainPage(),)
  );
}
