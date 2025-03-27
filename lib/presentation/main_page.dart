import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
import 'package:ready_go_project/domain/entities/provider/plan_favorites_provider.dart';
import 'package:ready_go_project/presentation/home_page.dart';
import 'package:ready_go_project/presentation/option_page.dart';
import 'package:ready_go_project/presentation/plan_main_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/data_bloc.dart';
import '../domain/entities/provider/passport_provider.dart';
import '../domain/entities/provider/plan_list_provider.dart';
import '../domain/entities/provider/responsive_height_provider.dart';
import '../domain/entities/provider/theme_mode_provider.dart';
import 'components/custom_accordion_tile.dart';
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
  List<Widget> pageOption = [const HomePage(), const PlanMainPage()];

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setFavoriteList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataStatus.beforePlanList) {
        context.read<PlanListProvider>().getPlanList();
        context.read<DataBloc>().add(DataLoadingPlanListEvent());
        context.read<PassportProvider>().getPassImg();
      }
      File? passImg = context.watch<PassportProvider>().passport;
      final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          // backgroundColor: const Color(0xff192a56),
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu));
          }),
          leadingWidth: 60,
          actions: [
            Stack(children: [
              IconButton(
                  onPressed: () {
                    final render = context.findRenderObject() as RenderBox;
                    final local = render.globalToLocal(const Offset(0, 0));
                    showMenu(context: context, position: RelativeRect.fromLTRB(local.dy + 40, local.dy + 110, local.dx, local.dy), items: [
                      PopupMenuItem(
                        child: const Text("여권 등록 및 수정"),
                        onTap: () {
                          final provider = context.read<PassportProvider>();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("이미지 선택"),
                                content: const Text("갤러리 또는 카메라 중 하나를 선택하세요."),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                      final XFile? image = await picker.pickImage(source: ImageSource.camera); // 카메라에서 이미지 선택
                                      if (image != null) {
                                        provider.setPassImg(image);
                                      }
                                    },
                                    child: const Text("카메라"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                      final XFile? image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
                                      if (image != null) {
                                        provider.setPassImg(image);
                                      }
                                    },
                                    child: const Text("갤러리"),
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
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.cyan),
                child: Center(
                    child: Column(
                  children: [
                    SizedBox(child: Image.asset("assets/images/logo.png")),
                    const Text(
                      "여행 준비를 한번에",
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                )),
              ),
              Scrollbar(
                child: CustomAccordionTile(title: "항공 수화물 규정", children: [
                  ListTile(
                    title: const Text(
                      "인천공항 제한물품",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://www.koreanair.com/contents/plan-your-travel/baggage/checked-baggage/free-baggage"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "대한항공",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://flyasiana.com/C/KR/KO/contents/free-baggage"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "아시아나",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://flyasiana.com/C/KR/KO/contents/free-baggage"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "진 에어",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://www.jinair.com/ready/freeBaggage?snsLang=ko_KR&ctrCd=KOR"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "티웨이",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://www.twayair.com/app/serviceInfo/contents/1148"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "에어부산",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://m.airbusan.com/mc/common/service/baggage/free"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "에어서울",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://flyairseoul.com/CM/ko/destinations01.do"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "제주항공",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://www.jejuair.net/ko/linkService/boardingProcessGuide/trustBaggage.do"));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      "에어로 K",
                      style: TextStyle(fontSize: 13),
                    ),
                    onTap: () {
                      launchUrl(Uri.parse("https://www.aerok.com/service/free"));
                    },
                  ),
                ]),
              )
            ],
          ),
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
                items: [
                  {"홈": Icons.home},
                  {"여행": Icons.airplane_ticket}
                ],
              )
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(items: [],onTap: (idx){},),
      ));
    });
  }
}
