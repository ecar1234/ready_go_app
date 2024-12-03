import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/presentation/main_page.dart';
import 'package:ready_go_project/provider/theme_mode_provider.dart';
import 'package:ready_go_project/service_locator.dart';

import 'provider/Roaming_provider.dart';
import 'provider/accommodation_provider.dart';
import 'provider/account_provider.dart';
import 'provider/images_provider.dart';
import 'provider/plan_list_provider.dart';
import 'provider/supplies_provider.dart';


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
      ChangeNotifierProvider(create: (_) => ThemeModeProvider())
    ],
    child: const MainPage(),)
  );
}
