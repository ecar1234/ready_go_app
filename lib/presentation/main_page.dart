import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/presentation/add_plan_page.dart';
import 'package:ready_go_project/presentation/option_page.dart';
import 'package:ready_go_project/presentation/plan_page.dart';
import 'package:ready_go_project/util/date_util.dart';

import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/accommodation_provider.dart';
import '../domain/entities/provider/account_provider.dart';
import '../domain/entities/provider/admob_provider.dart';
import '../domain/entities/provider/images_provider.dart';
import '../domain/entities/provider/passport_provider.dart';
import '../domain/entities/provider/plan_list_provider.dart';
import '../domain/entities/provider/roaming_provider.dart';
import '../domain/entities/provider/supplies_provider.dart';
import '../domain/entities/provider/theme_mode_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => {loadTheme()});
  }

  void loadTheme() {
    context.read<ThemeModeProvider>().getThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    return BlocProvider(
      create: (_) => DataBloc(),
      child: GetMaterialApp(
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: _analytics)],
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, tertiary: Colors.grey, brightness: Brightness.light),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
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
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Nanum'),
              backgroundColor: Colors.black87,
              elevation: 0.5,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87, tertiary: Colors.grey, brightness: Brightness.dark),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
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
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Nanum'),
              backgroundColor: Colors.black87,
              elevation: 0.5,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    final list = context.watch<PlanListProvider>().planList;
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    XFile? passImg = context.watch<PassportProvider>().passport;
    context.read<AdmobProvider>().loadAdBanner();

    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataStatus.beforePlanList) {
        context.read<PlanListProvider>().getPlanList();
        context.read<DataBloc>().add(DataLoadingPlanListEvent());
        context.read<PassportProvider>().getPassImg();
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: Image.asset('assets/images/logo_white.png')),
          leadingWidth: 120,
          actions: [
            Stack(children: [
              IconButton(
                  onPressed: () {
                    final render = context.findRenderObject() as RenderBox;
                    final local = render.globalToLocal(const Offset(0, 0));
                    showMenu(context: context, position: RelativeRect.fromLTRB(local.dy + 40, local.dy + 110, local.dx, local.dy), items: [
                      PopupMenuItem(
                        child: Text("여권 등록 및 수정"),
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
                        child: Text("여권 보기"),
                        onTap: () {
                          if (passImg != null) {
                            OpenFile.open(passImg.path);
                          } else {
                            Get.snackbar("여권 이미지 확인", "여권 이미지가 저장된 상황에서만 가능합니다.");
                          }
                        },
                      ),
                      // PopupMenuItem(
                      //   child: Text("여권 삭제"),
                      //   onTap: () {
                      //     context.read<PassportProvider>().deleteTest();
                      //   },
                      // ),
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
        body: Stack(children: [
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth <= 600) {
              return Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height - 120,
                  padding: const EdgeInsets.all(20),
                  child: list.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("생성된 여행이 없습니다."),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child:
                              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [_planListSection(context, list, isDarkMode, state)])));
            } else {
              return Center(
                child: Container(
                    width: 840,
                    height: MediaQuery.sizeOf(context).height - 120,
                    padding: const EdgeInsets.all(20),
                    child: list.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("생성된 여행이 없습니다."),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center, children: [_planListSection(context, list, isDarkMode, state)]))),
              );
            }
          }),
          // if (kReleaseMode)
          Builder(builder: (context) {
            final BannerAd? bannerAd = context.watch<AdmobProvider>().bannerAd;
            final logger = Logger();
            if (bannerAd != null) {
              return Positioned(
                  right: 20,
                  left: 20,
                  bottom: 30,
                  child: SizedBox(
                    height: bannerAd.size.height.toDouble(),
                    width: bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: bannerAd),
                  ));
            } else {
              logger.d("banner is null on main page");
              return const SizedBox();
            }
          })
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.surface,
          child: const Icon(
            Icons.add,
            // color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddPlanPage()),
            );
          },
        ),
      );
    });
  }

  Widget _planListSection(BuildContext context, List<PlanModel> list, bool isDarkMode, DataState state) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, idx) {
          return InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PlanPage(), settings: RouteSettings(arguments: list[idx])));
              if (state.state == DataStatus.endPlan) {
                context.read<DataBloc>().add(DataLoadingPlanListEvent());
              }
              Get.to(() => PlanPage(plan: list[idx]));
            },
            child: Slidable(
              endActionPane: ActionPane(extentRatio: 0.5, motion: const ScrollMotion(), children: [
                SlidableAction(
                    icon: Icons.edit_calendar,
                    label: "수정",
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (context) {
                      Get.to(() => AddPlanPage(
                            plan: list[idx],
                          ));
                    }),
                SlidableAction(
                    icon: Icons.delete,
                    label: "삭제",
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (context) {
                      context.read<PlanListProvider>().removePlanList(list[idx].id!);
                      context.read<AccommodationProvider>().removeAllData(list[idx].id!);
                      context.read<AccountProvider>().removeAllData(list[idx].id!);
                      context.read<ImagesProvider>().removeAllData(list[idx].id!);
                      context.read<RoamingProvider>().removeAllData(list[idx].id!);
                      context.read<SuppliesProvider>().removeAllData(list[idx].id!);
                    }),
              ]),
              child: Container(
                width: MediaQuery.sizeOf(context).width - 36,
                height: 120,
                decoration:
                    BoxDecoration(border: Border.all(color: isDarkMode ? Colors.white : Colors.black87), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - 122,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 상단 바
                          Container(
                            height: 30,
                            width: MediaQuery.sizeOf(context).width - 122,
                            padding: const EdgeInsets.only(left: 5),
                            decoration: const BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.local_airport,
                                    color: Color(0xff444444),
                                  ),
                                ),
                                const Gap(6),
                                const Text(
                                  "TRAVEL",
                                  style: TextStyle(color: Color(0xff444444), fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                          // 여행 목적 / 여행 기간
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      child: Text(
                                    "${list[idx].nation}",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  )),
                                  SizedBox(
                                    child: Text(
                                        "${DateUtil.dateToString(list[idx].schedule?.first ?? DateTime.now())} ~ ${DateUtil.dateToString(list[idx].schedule?.last ?? DateTime.now())}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // D-Day / Departure
                    SizedBox(
                      width: 80,
                      height: 140,
                      child: Stack(children: [
                        Column(
                          children: [
                            // 상단 바
                            Container(
                              height: 30,
                              decoration: const BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.only(topRight: Radius.circular(10))),
                              child: const Center(
                                child: Text(
                                  "Departure",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            // D-Day
                            Expanded(
                              child: Center(
                                child: Text(
                                  planState(list[idx].schedule!.first!, list[idx].schedule!.last!),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 점선
                        const Positioned(
                            left: 0,
                            child: SizedBox(
                              height: 140,
                              child: DottedLine(
                                direction: Axis.vertical,
                                alignment: WrapAlignment.center,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 4.0,
                                dashColor: Colors.black,
                                dashRadius: 0.0,
                                dashGapLength: 4.0,
                              ),
                            ))
                      ]),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, idx) => const Gap(20),
        itemCount: list.length);
  }

  String planState(DateTime first, DateTime end) {
    if (DateUtil.isSameDay(first, DateTime.now())) {
      return "D-Day";
    }
    if (first.isAfter(DateTime.now())) {
      return "D-${first.difference(DateTime.now()).inDays}";
    }
    if (first.isBefore(DateTime.now()) && DateTime.now().isBefore(end)) {
      return "여행중";
    }
    if (DateTime.now().isAfter(end)) {
      return "여행종료";
    }
    return "알 수 없음";
  }
}
