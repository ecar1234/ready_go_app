import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/domain/entities/provider/plan_favorites_provider.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/presentation/add_plan_page.dart';
import 'package:ready_go_project/presentation/plan_menus/plan_menu_page.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:ready_go_project/util/localizations_util.dart';
import 'package:ready_go_project/util/date_util.dart';
import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/plan_list_provider.dart';
import '../domain/entities/provider/purchase_manager.dart';
import '../domain/entities/provider/theme_mode_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class PlanMainPage extends StatefulWidget {
//   const PlanMainPage({super.key});
//
//   @override
//   State<PlanMainPage> createState() => _PlanMainPageState();
// }
//
// class _PlanMainPageState extends State<PlanMainPage> {
//   final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
//
//   ThemeData darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     useMaterial3: true,
//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFF5B89C3),
//       onPrimary: Colors.black87,
//       secondary: Color(0xFF80CBC4),
//       onSecondary: Colors.black87,
//       surface: Color(0xFF192A56), // 앱 배경색 및 카드/다이얼로그 배경색
//       onSurface: Colors.white, // 카드/다이얼로그 위 텍스트/아이콘 색상
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       labelStyle: TextStyle(color: Colors.white),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.white, // 원하는 색상
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.white, // 원하는 색상
//             width: 1.0,
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//     ),
//     textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
//     fontFamily: 'Nanum',
//   );
//
//   ThemeData lightTheme = ThemeData(
//     brightness: Brightness.light,
//     useMaterial3: true,
//     colorScheme: const ColorScheme.light(
//       primary: Color(0xFF007AFF),
//       onPrimary: Colors.white,
//       secondary: Color(0xFFFFCC80), // 보조 색상 추가 (예시)
//       onSecondary: Colors.black87,
//       surface: Colors.white, // 앱 배경색 및 카드/다이얼로그 배경색
//       onSurface: Colors.black87, // 카드/다이얼로그 위 텍스트/아이콘 색상
//     ),
//     inputDecorationTheme: const InputDecorationTheme(
//       labelStyle: TextStyle(color: Colors.black87),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black87, // 원하는 색상
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.black87, // 원하는 색상
//             width: 1.0,
//           ),
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//     ),
//     textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black87),
//     fontFamily: 'Nanum',
//   );
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.microtask(() => {
//       loadSetting()
//     });
//   }
//
//   void loadSetting()async {
//     context.read<ThemeModeProvider>().getThemeMode();
//     final provider = GetIt.I.get<ResponsiveHeightProvider>();
//     provider.setHeight(context);
//     while (provider.resHeight == null) {
//       await Future.delayed(const Duration(milliseconds: 10));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
//     return BlocProvider(
//       create: (_) => DataBloc(),
//       child: GetMaterialApp(
//           navigatorObservers: [FirebaseAnalyticsObserver(analytics: _analytics)],
//           debugShowCheckedModeBanner: false,
//           theme: lightTheme,
//           darkTheme: darkTheme,
//           themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
//           home: const MainPage2()),
//     );
//   }
// }

class PlanMainPage extends StatefulWidget {
  const PlanMainPage({super.key});

  @override
  State<PlanMainPage> createState() => _PlanMainPageState();
}

class _PlanMainPageState extends State<PlanMainPage> {
  ImagePicker picker = ImagePicker();
  final AdmobUtil _admobUtil = AdmobUtil();
  final logger = Logger();
  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kReleaseMode) {
        final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
        if (!isRemove) {
          _admobUtil.loadBannerAd(onAdLoaded: () {
            setState(() {
              _isLoaded = true;
            });
          }, onAdFailed: () {
            setState(() {
              _isLoaded = false;
              logger.e("banner is not loaded");
            });
          });
        }
      }
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
    // File? passImg = context.watch<PassportProvider>().passport;
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      final list = context.watch<PlanListProvider>().planList;
      final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
      // logger.d("body height : $height");
      final double bannerHeight = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;

      final isKor = Localizations.localeOf(context).languageCode == "ko";
      return Container(
        height: height - 80, // height - 하단바 높이 - gap(10) => body 크기
        // color: const Color(0xff192a56),
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                // button + Listview
                height: height - 100 - bannerHeight,
                child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  // 여행 생성 버튼
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const AddPlanPage()),
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, backgroundColor: isDarkMode ? const Color(0xff283C63) : Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.flight_takeoff,
                            size: 25,
                            color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                          ),
                          Text(
                            AppLocalizations.of(context)!.createNewPlan,
                            style: isKor ? TextStyle(
                              color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)
                            : GoogleFonts.notoSans(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                  // ListView
                  const Gap(20),
                  LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    return list.isEmpty
                        ? SizedBox(
                            height: height * 0.75,
                            width: constraints.maxWidth > 640
                                ? (constraints.maxWidth > 800 ? 650 : 520)
                                : 320,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "✨ ${AppLocalizations.of(context)!.planMainDesc}!",
                                    style: isKor ? TextStyle(fontWeight: FontWeight.w600, fontSize: constraints.maxWidth > 640 ? 34 : 22)
                                    : GoogleFonts.notoSans(fontWeight: FontWeight.w600, fontSize: constraints.maxWidth > 640 ? 34 : 22),
                                  ),
                                ),
                                Gap(isKor ? 20 : 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "✅ ${AppLocalizations.of(context)!.expectedMenu}",
                                      style: isKor ? TextStyle(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600)
                                      : GoogleFonts.notoSans(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(AppLocalizations.of(context)!.expectedDesc)
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("✅ ${AppLocalizations.of(context)!.eTicketMenu}",
                                        style: isKor ? TextStyle(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600)
                                        : GoogleFonts.notoSans(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                    Text(AppLocalizations.of(context)!.eTicketDesc)
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("✅ ${AppLocalizations.of(context)!.checkListMenu}",
                                        style: isKor ? TextStyle(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600)
                                        : GoogleFonts.notoSans(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                    Text(AppLocalizations.of(context)!.checkListDesc)
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("✅ ${AppLocalizations.of(context)!.eSimMenu}",
                                        style: isKor ? TextStyle(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600)
                                            : GoogleFonts.notoSans(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                    Text(AppLocalizations.of(context)!.eSimDesc)
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("✅ ${AppLocalizations.of(context)!.expenseMenu}",
                                        style: isKor ? TextStyle(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600)
                                        : GoogleFonts.notoSans(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                    Text(AppLocalizations.of(context)!.expenseDesc)
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("✅ ${AppLocalizations.of(context)!.accommodationMenu}",
                                        style: isKor ? TextStyle(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600)
                                        : GoogleFonts.notoSans(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                    Text(AppLocalizations.of(context)!.accommodationDesc)
                                  ],
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("✅ ${AppLocalizations.of(context)!.scheduleMenu}",
                                        style: isKor ? TextStyle(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600)
                                            : GoogleFonts.notoSans(fontSize: constraints.maxWidth > 640 ? 24 : 16, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                    Text(AppLocalizations.of(context)!.scheduleDesc)
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: height - 180 - bannerHeight, // height - button+gap(100) + banner(50) + bottom(70)
                            child: _planListSection(context, list, isDarkMode, state, isKor));
                  }),
                ]),
              ),
              if (_isLoaded && _admobUtil.bannerAd != null)
                SizedBox(
                  height: _admobUtil.bannerAd!.size.height.toDouble(),
                  width: _admobUtil.bannerAd!.size.width.toDouble(),
                  child: _admobUtil.getBannerAdWidget(),
                )
            ]),
      );
    });
  }

  Widget _planListSection(BuildContext context, List<PlanModel> list, bool isDarkMode, DataState state, bool isKor) {
    double? height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final favoriteList = context.read<PlanFavoritesProvider>().favoriteList;
    // if(favorite > 0){
    //   height = height - ((favorite * 120)+80) - 100;
    // }
    return SizedBox(
      height: height - 300,
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
                Get.to(() => PlanMenuPage(plan: list[idx]));
              },
              child: Slidable(
                endActionPane: ActionPane(extentRatio: 0.5, motion: const ScrollMotion(), children: [
                  SlidableAction(
                      icon: Icons.edit,
                      label: "수정",
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) {
                        Get.to(() => AddPlanPage(
                              plan: list[idx],
                            ));
                      }),
                  SlidableAction(
                      icon: Icons.delete,
                      label: "삭제",
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                      onPressed: (context) {
                        context.read<DataBloc>().add(PlanAllDataRemoveEvent(context: context, planId: list[idx].id!));

                      }),
                ]),
                child: Container(
                  // width: MediaQuery.sizeOf(context).width - 36,
                  height: 120,
                  decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xff283C63) : Colors.white,
                      border: isDarkMode ? null : Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(10)),
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
                              decoration: BoxDecoration(
                                  color: isDarkMode ? const Color(0xff5B89C3) : const Color(0xff007AFF),
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Icon(
                                          Icons.local_airport,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Gap(6),
                                      Text(
                                        "TRAVEL",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: 30,
                                      width: 50,
                                      child: IconButton(
                                          onPressed: () {
                                            if (list[idx].favorites == true) {
                                              if (favoriteList.isNotEmpty) {
                                                context.read<PlanFavoritesProvider>().removeFavoriteList(list[idx].id!);
                                              }
                                              list[idx].favorites = false;
                                              context.read<PlanListProvider>().changePlan(list[idx]);
                                            } else {
                                              if (favoriteList.length == 2) {
                                                Get.snackbar("즐겨찾기에 추가 할 수 없습니다.", "즐겨찾기는 최대 2개의 플랜만 추가가 가능합니다.",
                                                    backgroundColor: Theme.of(context).colorScheme.surface);
                                                return;
                                              }
                                              list[idx].favorites = true;
                                              context.read<PlanFavoritesProvider>().addFavoriteList(list[idx]);
                                              context.read<PlanListProvider>().changePlan(list[idx]);
                                            }
                                          },
                                          style: IconButton.styleFrom(padding: EdgeInsets.zero),
                                          icon: list[idx].favorites == false
                                              ? const Icon(Icons.label_important_outline)
                                              : const Icon(
                                                  Icons.label_important,
                                                  color: Colors.amberAccent,
                                                )))
                                ],
                              ),
                            ),
                            // 여행 목적 / 여행 기간
                            Container(
                              height: 80,
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          child: Text(
                                        "${list[idx].nation} (${DateUtil.datesDifference(list[idx].schedule!) + 1}${AppLocalizations.of(context)!.days})",
                                        style: LocalizationsUtil.setTextStyle(isKor,  // color: Colors.white,
                                            size: 18,
                                            fontWeight: FontWeight.w600)
                                      )),
                                      const Gap(4),
                                      const SizedBox(
                                        child: Icon(Icons.arrow_right),
                                      ),
                                      const Gap(4),
                                      Expanded(
                                        child: SizedBox(
                                            child: Text(
                                          "${list[idx].subject}",
                                          maxLines: 1,
                                          style: LocalizationsUtil.setTextStyle(isKor,
                                                fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    child: Text(
                                      "${DateUtil.dateToString(list[idx].schedule?.first ?? DateTime.now())} ~ ${DateUtil.dateToString(list[idx].schedule?.last ?? DateTime.now())}",
                                      // style: const TextStyle(color: Colors.white)
                                    ),
                                  ),
                                ],
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
                                decoration: BoxDecoration(
                                    color: isDarkMode ? const Color(0xff5B89C3) : const Color(0xff007AFF),
                                    borderRadius: const BorderRadius.only(topRight: Radius.circular(10))),
                                child: const Center(
                                  child: Text(
                                    "Departure",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              // D-Day
                              Expanded(
                                child: Center(
                                  child: Text(
                                    DateUtil.planState(list[idx].schedule!.first!, list[idx].schedule!.last!),
                                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
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
                                  dashColor: isDarkMode ? Colors.white : Colors.black87,
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
}
