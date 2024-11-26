import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/Roaming_provider.dart';
import 'package:ready_go_project/domain/entities/accommodation_provider.dart';
import 'package:ready_go_project/domain/entities/account_provider.dart';
import 'package:ready_go_project/domain/entities/plan_list_provider.dart';
import 'package:ready_go_project/domain/entities/supplies_provider.dart';
import 'package:ready_go_project/presentation/main_page.dart';
import 'package:ready_go_project/service_locator.dart';

import 'domain/entities/images_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await serviceLocator();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => PlanListProvider()),
      ChangeNotifierProvider(create: (_) => ImagesProvider()),
      ChangeNotifierProvider(create: (_) => SuppliesProvider()),
      ChangeNotifierProvider(create: (_) => RoamingProvider()),
      ChangeNotifierProvider(create: (_) => AccountProvider()),
      ChangeNotifierProvider(create: (_) => AccommodationProvider())
    ],
    child: const MainPage(),)
  );
}
