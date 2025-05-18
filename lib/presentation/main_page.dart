import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
import 'package:ready_go_project/domain/entities/provider/plan_favorites_provider.dart';
import 'package:ready_go_project/presentation/home_page.dart';
import 'package:ready_go_project/presentation/in_app_purchase_page.dart';
import 'package:ready_go_project/presentation/option_page.dart';
import 'package:ready_go_project/presentation/plan_main_page.dart';
import 'package:ready_go_project/presentation/visit_statistics_page.dart';
import 'package:ready_go_project/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/data_bloc.dart';
import '../domain/entities/provider/passport_provider.dart';
import '../domain/entities/provider/plan_list_provider.dart';
import '../domain/entities/provider/responsive_height_provider.dart';
import '../domain/entities/provider/theme_mode_provider.dart';

import 'components/custom_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF5B89C3),
      onPrimary: Colors.black87,
      secondary: Color(0xFF80CBC4),
      onSecondary: Colors.black87,
      surface: Color(0xFF192A56),
      // 앱 배경색 및 카드/다이얼로그 배경색
      onSurface: Colors.white, // 카드/다이얼로그 위 텍스트/아이콘 색상
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white, // 원하는 색상
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white, // 원하는 색상
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
    fontFamily: 'Nanum',
  );

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF007AFF),
      onPrimary: Colors.white,
      secondary: Color(0xFFFFCC80),
      // 보조 색상 추가 (예시)
      onSecondary: Colors.black87,
      surface: Colors.white,
      // 앱 배경색 및 카드/다이얼로그 배경색
      onSurface: Colors.black87, // 카드/다이얼로그 위 텍스트/아이콘 색상
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black87),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black87, // 원하는 색상
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black87, // 원하는 색상
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black87),
    fontFamily: 'Nanum',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => {loadSetting()});
  }

  void loadSetting() async {
    context.read<ThemeModeProvider>().getThemeMode();
    final provider = GetIt.I.get<ResponsiveHeightProvider>();
    provider.setHeight(context);
    while (provider.resHeight == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    return BlocProvider(
      create: (_) => DataBloc(),
      child: GetMaterialApp(
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: _analytics)],
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainPage2()),
    );
  }
}

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  ImagePicker picker = ImagePicker();
  int _selected = 0;
  List<Widget> pageOption = [const HomePage(), const PlanMainPage(), const VisitStatisticsPage(), const InAppPurchasePage()];

  void setFavoriteList(BuildContext context) {
    List<PlanModel> list = context.read<PlanListProvider>().planList;
    if (list.isEmpty) {
      return;
    }
    context.read<PlanFavoritesProvider>().setFavoriteList(list);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setFavoriteList(context);
      final remote = FirebaseRemoteConfig.instance;
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVer = int.parse(packageInfo.buildNumber);

      final iosMinVersion = remote.getInt("ios_min_version");
      final iosVersion = remote.getInt("IOS_version");
      final androidMinVersion = remote.getInt("android_min_version");
      final androidVersion = remote.getInt("Android_version");

      bool update = false;
      debugPrint("min version : $iosMinVersion");
      debugPrint("min version : $iosVersion");
      debugPrint("min version : $androidMinVersion");
      debugPrint("current version : $androidVersion");

      logger.i("ios need update: ${iosMinVersion < iosVersion}");
      logger.i("android need update: ${androidMinVersion < androidVersion}");
      if(Platform.isAndroid){
        if(currentVer-1 >= androidMinVersion){
          update = false;
        }else {
          update = true;
        }
      }else if(Platform.isIOS){
        if(currentVer >= iosMinVersion){
          update = false;
        }else {
          update = true;
        }
      }

      if (update) {
        if(mounted){
          final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                contentPadding: const EdgeInsets.all(20),
                content: const SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "최신 버전으로 업데이트 후",
                        style: TextStyle(fontSize: 16),
                      ),
                      Gap(10),
                      Text(
                        "이용해 주세요.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                actions: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (Platform.isIOS) {
                            await launchUrl(Uri.parse('https://apps.apple.com/app/id6744342927'));
                          } else {
                            await launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.ready_go_project'));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                        child: Text("업데이트", style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary  ),)),
                  )
                ],
                actionsAlignment: MainAxisAlignment.center,
              ),
              barrierDismissible: false);
        }

      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataStatus.beforeCheckPurchases) {
        context.read<DataBloc>().add(CheckPurchases(context: context));
        // context.read<DataBloc>().add(DataLoadingEvent(context: context));
      }
      File? passImg = context.watch<PassportProvider>().passport;
      bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
      final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                icon: isDarkMode
                    ? Image.asset(
                        'assets/images/logo_white.png',
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      )),
            leadingWidth: 120,
            actions: [
              Stack(children: [
                IconButton(
                    onPressed: () {
                      final render = context.findRenderObject() as RenderBox;
                      final local = render.globalToLocal(const Offset(0, 0));
                      showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(local.dy + 40, local.dy + 110, local.dx, local.dy),
                          color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                          items: [
                        PopupMenuItem(
                          child: const Text("여권 등록 및 수정"),
                          onTap: () {
                            final provider = context.read<PassportProvider>();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("여권 이미지 선택"),
                                  content: const Text("갤러리 또는 카메라 중 하나를 선택하세요."),
                                  actions: [
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop(); // 다이얼로그 닫기
                                          final XFile? image = await picker.pickImage(source: ImageSource.camera); // 카메라에서 이미지 선택
                                          if (image != null) {
                                            provider.setPassImg(image);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                        ),
                                        child: Text("카메라", style: TextStyle(
                                          color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary
                                        ),),
                                      ),
                                    ),
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop(); // 다이얼로그 닫기
                                          final XFile? image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
                                          if (image != null) {
                                            provider.setPassImg(image);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                        ),
                                        child: Text("갤러리", style: TextStyle(
                                          color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary
                                        ),),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        PopupMenuItem(
                          child: const Text("여권 보기"),
                          onTap: () async {
                            if (passImg != null) {
                              OpenFile.open(passImg.path);
                            } else {
                              Get.snackbar("여권 이미지 확인", "여권 이미지가 저장된 상황에서만 가능합니다.");
                            }
                          },
                        ),
                      ]);
                    },
                    icon: const Icon(Icons.person_pin_rounded)),
                Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: passImg == null ? Colors.redAccent : Colors.green),
                    ))
              ]),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {
                    Get.to(() => const OptionPage());
                  },
                  icon: const Icon(Icons.settings)),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          body: Container(
            height: height,
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                pageOption[_selected],
                CustomBottomNavigationBar(
                  onTap: (int idx) {
                    setState(() {
                      _selected = idx;
                    });
                  },
                  items: const [
                    {"홈": Icons.home},
                    {"여행": Icons.airplane_ticket},
                    {"방문통계": Icons.pie_chart},
                    {"인앱구매": Icons.sell}
                  ],
                )
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(items: [],onTap: (idx){},),
      );
    });
  }
}
