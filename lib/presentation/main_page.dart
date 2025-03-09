import 'dart:io';

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
import 'package:provider/provider.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/presentation/add_plan_page.dart';
import 'package:ready_go_project/presentation/option_page.dart';
import 'package:ready_go_project/presentation/plan_page.dart';
import 'package:ready_go_project/util/admob_util.dart';
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
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<AdmobProvider>().loadAdBanner();
    // });
    _admobUtil.loadBannerAd(onAdLoaded: () {
      setState(() {
        _isLoaded = true;
      });
    }, onAdFailed: () {
      setState(() {
        _isLoaded = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // context.read<AdmobProvider>().bannerAdDispose();
    _admobUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    File? passImg = context.watch<PassportProvider>().passport;

    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataStatus.beforePlanList) {
        context.read<PlanListProvider>().getPlanList();
        context.read<DataBloc>().add(DataLoadingPlanListEvent());
        context.read<PassportProvider>().getPassImg();
      }

      return SafeArea(
        child: Scaffold(
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
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 40,
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xff666666)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "여행기록",
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          context.read<AdmobProvider>().loadAdInterstitialAd();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const AddPlanPage()),
                          );
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        label: Text(
                          "기록추가",
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        iconAlignment: IconAlignment.end,
                      )
                    ],
                  ),
                ),
                const Gap(10),
                LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  final list = context.select<PlanListProvider, List<PlanModel>?>((p) => p.planList);
                  if (constraints.maxWidth <= 660) {
                    return SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 550,
                        child: list!.isEmpty
                            ? SizedBox(
                                height: MediaQuery.sizeOf(context).height - 300,
                                child: const Center(child: Text("생성된 여행이 없습니다.")),
                              )
                            : _planListSection(context, list, isDarkMode, state));
                  } else {
                    return SizedBox(
                        width: 840,
                        height: 540,
                        child: list!.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("생성된 여행이 없습니다."),
                                ],
                              )
                            : _planListSection(context, list, isDarkMode, state));
                  }
                }),
              ]),
              const Gap(20),
              if (_isLoaded && _admobUtil.bannerAd != null)
                SizedBox(
                  height: _admobUtil.bannerAd!.size.height.toDouble(),
                  width: _admobUtil.bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: _admobUtil.bannerAd!),
                )
            ]),
          ),
        ),
      );
    });
  }

  Widget _planListSection(BuildContext context, List<PlanModel> list, bool isDarkMode, DataState state) {
    return SizedBox(
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
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
                      Flexible(
                        flex: 3,
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
                      Flexible(
                        flex: 1,
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
                                    style: TextStyle(color: Color(0xff444444), fontSize: 12, fontWeight: FontWeight.w500),
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
                          Positioned(
                              left: 0,
                              child: SizedBox(
                                height: 140,
                                child: DottedLine(
                                  direction: Axis.vertical,
                                  alignment: WrapAlignment.center,
                                  lineLength: double.infinity,
                                  lineThickness: 1.0,
                                  dashLength: 4.0,
                                  dashColor: isDarkMode ? Colors.white : Colors.black,
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
          itemCount: list.length),
    );
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
