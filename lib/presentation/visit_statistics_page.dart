import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/entities/provider/plan_list_provider.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ready_go_project/domain/use_cases/statistics_use_case.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:ready_go_project/util/intl_utils.dart';
import 'package:ready_go_project/util/statistics_util.dart';

import '../data/models/plan_model/plan_model.dart';

class VisitStatisticsPage extends StatefulWidget {
  const VisitStatisticsPage({super.key});

  @override
  State<VisitStatisticsPage> createState() => _VisitStatisticsPageState();
}

class _VisitStatisticsPageState extends State<VisitStatisticsPage> {
  final _admobUtil = AdmobUtil();
  bool _isLoaded = false;

  int selectIdx = 0;
  int nationTouchedIndex = -1;
  int accountTouchedIndex = -1;
  List<Color> nationColors = [
    const Color(0xffCD5C5C),
    const Color(0xffB22222),
    const Color(0xffEE82EE),
    const Color(0xff7B68EE),
    const Color(0xffFF4500),
    const Color(0xffC71585),
    const Color(0xffB8860B),
    const Color(0xffFFD700),
    const Color(0xffF5F5DC),
    const Color(0xffCD5C5C),
    const Color(0xffFFA07A),
    const Color(0xffFFDAB9),
  ];
  List<Color> accountColors = [
    const Color(0xff228B22),
    const Color(0xff006400),
    const Color(0xff00FA9A),
    const Color(0xff20B2AA),
    const Color(0xff008B8B),
    const Color(0xff00BFFF),
    const Color(0xff4169E1),
    const Color(0xff7B68EE),
    const Color(0xffEE82EE),
    const Color(0xffCD5C5C),
    const Color(0xffFFA07A),
    const Color(0xffFFDAB9),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().resHeight! - 80;
    final wid = MediaQuery.sizeOf(context).width;
    final planList = context.read<PlanListProvider>().planList;
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height + 10 : 0;
    List<PlanModel> completedPlanList = planList.where((item) => item.schedule!.last!.isBefore(DateTime.now())).toList();

    return SizedBox(
        height: hei,
        width: wid,
        child: Column(
          children: [
            // 통계표 영역
            Container(
              height: hei * 0.5,
              width: wid,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: selectIdx == 0 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: hei * 0.4,
                          width: wid,
                          child: selectIdx == 0
                              ? _nationChartContainer(context, completedPlanList, isDarkMode)
                              : _accountChartContainer(context, completedPlanList, isDarkMode)),
                    ],
                  ),
                  Positioned(
                      top: 5,
                      right: 0,
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration:
                            BoxDecoration(color: isDarkMode ? Theme.of(context).primaryColor : Colors.white, borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: IconButton(
                                  onPressed: () {
                                    if (selectIdx == 0) {
                                      return;
                                    }
                                    setState(() {
                                      selectIdx = 0;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.map,
                                    color: selectIdx == 0 ? (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary) : Colors.grey,
                                  )),
                            ),
                            SizedBox(
                              width: 60,
                              child: IconButton(
                                  onPressed: () {
                                    if (selectIdx == 1) {
                                      return;
                                    }
                                    setState(() {
                                      selectIdx = 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.money,
                                    color: selectIdx == 1 ? (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary) : Colors.grey,
                                  )),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
            // 통계 데이터 영역
            Container(
              height: (hei * 0.5) - bannerHei,
              width: wid,
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              // color: Colors.green,
              child: Column(
                children: [
                  SizedBox(
                    width: wid,
                    child: selectIdx == 0
                        ? _nationStatistics(context, completedPlanList, isDarkMode, (hei * 0.5) - bannerHei)
                        : _accountStatistics(context, completedPlanList, isDarkMode, (hei * 0.5) - bannerHei),
                  )
                ],
              ),
            ),
            // if (_isLoaded && _admobUtil.bannerAd != null) const Gap(10),
            if (_isLoaded && _admobUtil.bannerAd != null)
              SizedBox(
                height: _admobUtil.bannerAd!.size.height.toDouble(),
                width: _admobUtil.bannerAd!.size.width.toDouble(),
                child: _admobUtil.getBannerAdWidget(),
              )
          ],
        ));
  }

  Widget _nationChartContainer(BuildContext context, List<PlanModel> list, bool isDarkMode) {
    return list.isEmpty
        ? const SizedBox(
            child: Center(
                child: Text(
              "완료된 여행 기록이 아직 없습니다.",
              style: TextStyle(color: Colors.white),
            )),
          )
        : AspectRatio(
            aspectRatio: 1.0,
            child: PieChart(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          nationTouchedIndex = -1;
                          return;
                        }
                        nationTouchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 5,
                  centerSpaceRadius: 40,
                  sections: nationSection(context, list, isDarkMode),
                )),
          );
  }

  List<PieChartSectionData> nationSection(BuildContext context, List<PlanModel> list, bool isDarkMode) {
    List<Map<String, int>> nationsList = context.read<StatisticsUseCase>().nations??[];

    return List.generate(nationsList.length, (idx) {
      final isTouched = idx == nationTouchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final widgetSize = isTouched ? 55.0 : 10.0;
      final offset = isTouched ? 1.4 : 1.1;

      return PieChartSectionData(
          title: "${((nationsList[idx].values.first / list.length) * 100).toStringAsFixed(1)}%",
          value: (nationsList[idx].values.first / list.length) * 100,
          color: nationColors[idx],
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: widgetSize,
              height: widgetSize,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: nationColors[idx],
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white),
              child: Center(
                child: Text(
                  nationsList[idx].keys.first,
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              )),
          badgePositionPercentageOffset: offset,
          radius: radius);
    });
  }

  Widget _accountChartContainer(BuildContext context, List<PlanModel> list, bool isDarkMode) {
    return list.isEmpty
        ? const SizedBox(
            child: Center(
                child: Text(
              "완료된 여행 기록이 아직 없습니다.",
              style: TextStyle(color: Colors.white),
            )),
          )
        : AspectRatio(
            aspectRatio: 1.0,
            child: PieChart(
                duration: const Duration(milliseconds: 600),
                curve: Curves.linear,
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          accountTouchedIndex = -1;
                          return;
                        }
                        accountTouchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 5,
                  centerSpaceRadius: 40,
                  sections: accountSection(context, isDarkMode),
                )),
          );
  }

  List<PieChartSectionData> accountSection(BuildContext context, bool isDarkMode) {
    List<Map<String, List<int>>> accountList = context.read<StatisticsUseCase>().accounts??[];

    return List.generate(accountList.length, (idx) {
      final isTouched = idx == accountTouchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final widgetSize = isTouched ? 55.0 : 10.0;
      final offset = isTouched ? 1.4 : 1.0;

      return PieChartSectionData(
          title: "${StatisticsUtil.getAccountStatistics(accountList, idx)}%",
          value: StatisticsUtil.getAccountValue(accountList, idx),
          color: accountColors[idx],
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: widgetSize,
              height: widgetSize,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: accountColors[idx],
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white),
              child: Center(
                child: Text(
                  accountList[idx].keys.first,
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              )),
          badgePositionPercentageOffset: offset,
          radius: radius);
    });
  }

  Widget _nationStatistics(BuildContext context, List<PlanModel> list, bool isDarkMode, double hei) {
    List<Map<String, int>> nationList = context.read<StatisticsUseCase>().nations??[];

    return SizedBox(
      height: hei - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "방문 통계 데이터",
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const Gap(10),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(10)),
                child: nationList.isEmpty
                    ? const SizedBox(
                        child: Center(
                          child: Text("아직 기록된 여행이 없습니다."),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 40, crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                        itemBuilder: (context, idx) {
                          return SizedBox(
                            child: Row(
                              children: [
                                Text(
                                  nationList[idx].keys.first,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const Gap(10),
                                Text("${nationList[idx].values.first}회 (${(nationList[idx].values.first / list.length) * 100}%)"),
                              ],
                            ),
                          );
                        },
                        itemCount: list.length,
                      )),
          )
        ],
      ),
    );
  }

  Widget _accountStatistics(BuildContext context, List<PlanModel> list, bool isDarkMode, double hei) {
    List<Map<String, List<int>>> accountList = context.read<StatisticsUseCase>().accounts??[];

    return SizedBox(
      height: hei - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "사용 금액 통계(현금 + 카드)",
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const Gap(10),
          Expanded(
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(10)),
                child: accountList.isEmpty
                    ? const SizedBox(
                        child: Center(
                          child: Text("아직 기록된 여행이 없습니다."),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 40, crossAxisCount: 1, mainAxisSpacing: 5),
                        itemBuilder: (context, idx) {
                          return SizedBox(
                            child: Row(
                              children: [
                                Text(
                                  accountList[idx].keys.first,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const Gap(10),
                                Text("${IntlUtils.stringIntAddComma(StatisticsUtil.getPlanTotalAccount(accountList[idx]))}원",
                                  style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,fontSize: 16),
                                ),
                                const Gap(10),
                                Text("(${StatisticsUtil.getAccountStatistics(accountList, idx)}%)"),
                              ],
                            ),
                          );
                        },
                        itemCount: accountList.length,
                      )),
          )
        ],
      ),
    );
  }
}
