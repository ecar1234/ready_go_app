import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/presentation/add_plan_page.dart';
import 'package:ready_go_project/presentation/option_page.dart';
import 'package:ready_go_project/presentation/plan_page.dart';
import 'package:ready_go_project/provider/Roaming_provider.dart';
import 'package:ready_go_project/provider/accommodation_provider.dart';
import 'package:ready_go_project/provider/account_provider.dart';
import 'package:ready_go_project/provider/admob_provider.dart';
import 'package:ready_go_project/provider/images_provider.dart';
import 'package:ready_go_project/provider/supplies_provider.dart';
import 'package:ready_go_project/provider/theme_mode_provider.dart';
import 'package:ready_go_project/util/date_util.dart';

import '../data/models/plan_model/plan_model.dart';
import '../provider/plan_list_provider.dart';

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
    Future.microtask(() => {context.read<ThemeModeProvider>().getThemeMode()});
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
  @override
  Widget build(BuildContext context) {
    final list = context.watch<PlanListProvider>().planList;
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    if (kReleaseMode) {
      context.read<AdmobProvider>().loadAdBanner();
    }
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataStatus.beforePlanList) {
        context.read<PlanListProvider>().getPlanList();
        context.read<DataBloc>().add(DataLoadingPlanListEvent());
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: Image.asset('assets/images/logo_white.png')),
          leadingWidth: 120,
          actions: [
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
          Container(
              width: Get.width,
              height: Get.height - 120,
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
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [_planListSection(context, list, isDarkMode, state)]))),
          if(kReleaseMode)
          Builder(builder: (context) {
            final BannerAd bannerAd = context.watch<AdmobProvider>().bannerAd!;
            return Positioned(
                right: 20,
                left: 20,
                bottom: 30,
                child: SizedBox(
                  height: bannerAd.size.height.toDouble(),
                  width: bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ));
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
              endActionPane: ActionPane(extentRatio: 0.25, motion: const ScrollMotion(), children: [
                SlidableAction(
                    icon: Icons.delete,
                    label: "삭제",
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                    onPressed: (context) {
                      context.read<PlanListProvider>().removePlanList(list[idx].id!);
                      context.read<AccommodationProvider>().removeAllData(list[idx].id!);
                      context.read<AccountProvider>().removeAllData(list[idx].id!);
                      context.read<ImagesProvider>().removeAllData(list[idx].id!);
                      context.read<RoamingProvider>().removeAllData(list[idx].id!);
                      context.read<SuppliesProvider>().removeAllData(list[idx].id!);
                    })
              ]),
              child: Center(
                child: Container(
                  width: 600,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(border: Border.all(color: isDarkMode ? Colors.white : Colors.black87), borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          child: Text(
                        "${list[idx].nation}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      )),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${DateUtil.dateToString(list[idx].schedule?.first ?? DateTime.now())} ~ ${DateUtil.dateToString(list[idx].schedule?.last ?? DateTime.now())}"),
                            const Gap(10),
                            list[idx].schedule!.last!.isAfter(DateTime.now()) ? const Text("(준비중)") : const Text("(완료)")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, idx) => const Gap(20),
        itemCount: list.length);
  }
}
