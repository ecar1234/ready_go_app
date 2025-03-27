import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/presentation/plan_menu_page.dart';

import '../bloc/data_bloc.dart';
import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/passport_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      final favoriteList = context.watch<PlanFavoritesProvider>().favoriteList;
      final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
      logger.d("body height : $height");
      return Container(
        height: height - 80,
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          children: [
            _favoritePlanListContainer(context, favoriteList, isDarkMode, state),
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
      height: 50 + favoriteList.length * 140,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
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
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
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
                                    SizedBox(
                                        child: Text(
                                      "${favoriteList[idx].nation}",
                                      style: TextStyle(
                                          color: isDarkMode ? Colors.white : Colors.black87,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    SizedBox(
                                      child: Text(
                                        "${DateUtil.dateToString(favoriteList[idx].schedule?.first ?? DateTime.now())} ~ ${DateUtil.dateToString(favoriteList[idx].schedule?.last ?? DateTime.now())}",
                                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87,)
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
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10))),
                                  child: const Center(
                                    child: Text(
                                      "Departure",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
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

}
