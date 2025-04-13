
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/presentation/plan_menus/plan_menu_page.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/data_bloc.dart';
import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/plan_favorites_provider.dart';
import '../domain/entities/provider/plan_list_provider.dart';
import '../domain/entities/provider/responsive_height_provider.dart';
import '../domain/entities/provider/theme_mode_provider.dart';
import '../util/date_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logger = Logger();

  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)=> _loadBanner());
  }

  void _loadBanner() {
    _admobUtil.loadBannerAd(
      onAdLoaded: () {
        setState(() {
          _isLoaded = true;
        });
      },
      onAdFailed: () {
        setState(() {
          _isLoaded = false;
        });
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _admobUtil.dispose();
    super.dispose();
  }
    @override
    Widget build(BuildContext context) {
      bool isDarkMode = context
          .watch<ThemeModeProvider>()
          .isDarkMode;
      return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        final favoriteList = context
            .watch<PlanFavoritesProvider>()
            .favoriteList;
        final height = GetIt.I
            .get<ResponsiveHeightProvider>()
            .resHeight ?? MediaQuery
            .sizeOf(context)
            .height - 120;
        // logger.d("body height : $height");
        return Container(
          height: height - 80,
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _favoritePlanListContainer(context, favoriteList, isDarkMode, state),
                  _infoCardContainer(context, isDarkMode),
                  _batteryInfoButton(context, isDarkMode),
                ],
              ),

              if (_isLoaded && _admobUtil.bannerAd != null) const Gap(10),
              if (_isLoaded && _admobUtil.bannerAd != null)
                SizedBox(
                  height: _admobUtil.bannerAd!.size.height.toDouble(),
                  width: _admobUtil.bannerAd!.size.width.toDouble(),
                  child: _admobUtil.getBannerAdWidget(),
                ),

            ],
          ),
        );
      });
    }

    Widget _favoritePlanListContainer(BuildContext context, List<PlanModel> favoriteList, bool isDarkMode, DataState state) {
      if (favoriteList.isEmpty) {
        return SizedBox(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                child: Text(
                  "즐겨찾기",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const Gap(10),
              Container(
                height: 120,
                decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text("즐겨찾기 여행이 없습니다."),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox(
        height: 50 + favoriteList.length * 130,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery
                  .sizeOf(context)
                  .width,
              height: 40,
              child: Text(
                "즐겨찾기 (${favoriteList.length} / 2)",
                style: const TextStyle(
                  // color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      if (state.state == DataStatus.endPlan) {
                        context.read<DataBloc>().add(DataLoadingPlanListEvent());
                      }
                      Get.to(() => PlanMenuPage(plan: favoriteList[idx]));
                    },
                    child: Container(
                      // width: MediaQuery.sizeOf(context).width - 36,
                      height: 120,
                      decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xff283C63) : Colors.white,
                          border: isDarkMode ? null : Border.all(),
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
                                  width: MediaQuery
                                      .sizeOf(context)
                                      .width - 122,
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
                                                favoriteList[idx].favorites = false;
                                                context.read<PlanListProvider>().changePlan(favoriteList[idx]);
                                                context.read<PlanFavoritesProvider>().removeFavoriteList(favoriteList[idx].id!);
                                              },
                                              style: IconButton.styleFrom(padding: EdgeInsets.zero),
                                              icon: favoriteList[idx].favorites == false
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
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              child: Text(
                                                "${favoriteList[idx].nation} (${DateUtil.datesDifference(favoriteList[idx].schedule!) + 1}일)",
                                                style: const TextStyle(
                                                  // color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600),
                                              )),
                                          const Gap(10),
                                          Expanded(
                                            child: SizedBox(
                                                child: Text(
                                                  "주제: ${favoriteList[idx].subject}",
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    // color: Colors.white,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontWeight: FontWeight.w600),
                                                )),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        child: Text(
                                          "${DateUtil.dateToString(favoriteList[idx].schedule?.first ?? DateTime.now())} ~ ${DateUtil.dateToString(favoriteList[idx].schedule?.last ?? DateTime.now())}",
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
                                        DateUtil.planState(favoriteList[idx].schedule!.first!, favoriteList[idx].schedule!.last!),
                                        style: const TextStyle(
                                          // color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
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
                                      // dashColor: Colors.white,
                                      dashRadius: 0.0,
                                      dashGapLength: 4.0,
                                    ),
                                  ))
                            ]),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, idx) => const Gap(10),
                itemCount: favoriteList.length),
            const Gap(20),
          ],
        ),
      );
    }

    Widget _infoCardContainer(BuildContext context, bool isDarkMode) {
      final planeList = [
        {"assets/images/logo_korean.png": "https://www.koreanair.com/contents/plan-your-travel/baggage/checked-baggage/free-baggage"},
        {"assets/images/logo_asiana.png": "https://flyasiana.com/C/KR/KO/contents/free-baggage"},
        {"assets/images/logo_jinair.png": "https://www.jinair.com/ready/freeBaggage?snsLang=ko_KR&ctrCd=KOR"},
        {"assets/images/logo_tway.png": "https://www.twayair.com/app/serviceInfo/contents/1148"},
        {"assets/images/logo_airbusan.png": "https://m.airbusan.com/mc/common/service/baggage/free"},
        {"assets/images/logo_airseoul.png": "https://flyairseoul.com/CM/ko/destinations01.do"},
        {"assets/images/logo_jeju.png": "https://www.jejuair.net/ko/linkService/boardingProcessGuide/trustBaggage.do"},
        {"assets/images/logo_aerok.png": "https://www.aerok.com/service/free"},
      ];
      return SizedBox(
        height: 200,
        child: GridView(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: [
            GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse("https://www.airport.kr/ap_ko/905/subview.do"));
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: isDarkMode ? Theme
                      .of(context)
                      .colorScheme
                      .primary : Colors.white,
                  child: Stack(
                    children: [
                      Image.asset("assets/images/trolley_case.jpeg", fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white38, // 위쪽은 반투명 흰색
                              isDarkMode ? Theme
                                  .of(context)
                                  .colorScheme
                                  .primary : Colors.white, // 아래쪽은 투명
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '인천공항',
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 14),
                            ),
                            Text(
                              '기내반입 규정',
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        final hei = GetIt.I
                            .get<ResponsiveHeightProvider>()
                            .resHeight!;
                        return Container(
                            height: hei * 0.5,
                            width: MediaQuery
                                .sizeOf(context)
                                .width,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                            decoration: const BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 20, mainAxisExtent: 50),
                              itemBuilder: (context, idx) {
                                return ElevatedButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(planeList[idx].values.toList()[0]));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Stack(children: [
                                      SizedBox(
                                          height: 25,
                                          child: Image.asset(
                                            planeList[idx].keys.toList()[0],
                                            fit: BoxFit.cover,
                                          )),
                                      Positioned(
                                          top: 0,
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Container(
                                            height: 50,
                                            color: Colors.white24,
                                          ))
                                    ]));
                              },
                              itemCount: planeList.length,
                            ));
                      });
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: isDarkMode ? Theme
                      .of(context)
                      .colorScheme
                      .primary : Colors.white,
                  child: Stack(
                    children: [
                      Image.asset("assets/images/plane.jpeg", fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white38, // 위쪽은 반투명 흰색
                              isDarkMode ? Theme
                                  .of(context)
                                  .colorScheme
                                  .primary : Colors.white, // 아래쪽은 투명
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '항공사 별',
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 14),
                            ),
                            Text(
                              '수화물 규정',
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );
    }

    Widget _batteryInfoButton(BuildContext context, bool isDarkMode) {
      return SizedBox(
        height: 50,
        width: MediaQuery
            .sizeOf(context)
            .width,
        child: ElevatedButton.icon(
          onPressed: () {
            launchUrl(Uri.parse(
                "https://www.airport.kr/ap_ko/1011/subview.do?enc=Zm5jdDF8QEB8JTJGYmJzJTJGYXBfa28lMkYxNzUlMkYxMzg1ODAlMkZhcnRjbFZpZXcuZG8lM0ZwYWdlJTNEMSUyNmZpbmRUeXBlJTNEJTI2ZmluZFdvcmQlM0QlMjZmaW5kQ2xTZXElM0QlMjZmaW5kT3Bud3JkJTNEJTI2cmdzQmduZGVTdHIlM0QlMjZyZ3NFbmRkZVN0ciUzRCUyNnBhc3N3b3JkJTNEJTI2dGVtcFJvdyUzRCUyNg%3D%3D"
            ));
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          label: const Text("보조배터리 및 전자담배 기내반입 규정"),
          icon: Image.asset("assets/images/battery.png"),
        ),
      );
    }
  }
