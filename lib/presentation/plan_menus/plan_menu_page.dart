
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/domain/entities/provider/expectation_provider.dart';
import 'package:ready_go_project/presentation/plan_menus/accommodation_page.dart';
import 'package:ready_go_project/presentation/plan_menus/account_book_page.dart';
import 'package:ready_go_project/presentation/plan_menus/air_ticket_page.dart';
import 'package:ready_go_project/presentation/plan_menus/expectation_page.dart';
import 'package:ready_go_project/presentation/plan_menus/roaming_page.dart';
import 'package:ready_go_project/presentation/plan_menus/supplies_page/supplies_page.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../domain/entities/provider/accommodation_provider.dart';
import '../../domain/entities/provider/account_provider.dart';
import '../../domain/entities/provider/images_provider.dart';
import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../domain/entities/provider/roaming_provider.dart';
import '../../domain/entities/provider/supplies_provider.dart';
import '../../domain/entities/provider/theme_mode_provider.dart';
import '../../util/admob_util.dart';
import '../../util/date_util.dart';

class PlanMenuPage extends StatefulWidget {
  final PlanModel plan;

  const PlanMenuPage({super.key, required this.plan});

  @override
  State<PlanMenuPage> createState() => _PlanMenuPageState();
}

class _PlanMenuPageState extends State<PlanMenuPage> {
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  List<String> itemList = ["예상 경비", "항공권", "준비물", "로밍(E-SIM)", "사용 경비", "숙소"];
  // List<String> itemList = ["항공권", "준비물", "로밍(E-SIM)", "사용 경비", "숙소"];
  // List<String> itemList = ["항공권", "준비물", "로밍 & ESIM", "여행 경비", "숙소", "일정"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AdmobProvider>().loadAdBanner());
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
    DataState state = context.watch<DataBloc>().state;
    if (state.state == DataStatus.loadedPlanList) {
      context.read<ImagesProvider>().getImgList(widget.plan.id!);
      context.read<SuppliesProvider>().getList(widget.plan.id!);
      context.read<RoamingProvider>().getRoamingDate(widget.plan.id!);
      context.read<AccountProvider>().getAccountInfo(widget.plan.id!);
      context.read<AccommodationProvider>().getAccommodationList(widget.plan.id!);
      context.read<ExpectationProvider>().getExpectationData(widget.plan.id!);
      // context.read<ImagesProvider>().getImgList(widget.plan.id!);
      context.read<DataBloc>().add(DataLoadingPlanEvent());
    }
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height -120;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("여행준비"),
          leading: IconButton(
            onPressed: () {
              Get.back();
              context.read<DataBloc>().add(DataResetEvent());
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Container(
          height: height,
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
                height: height - 100,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width - 40,
                      height: 80,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                          border: Border.all(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(10),
                        boxShadow:isDarkMode ? null : [
                          BoxShadow(
                            offset: const Offset(0, 7.0),
                            spreadRadius: 1.0,
                            blurRadius: 7.0,
                            color: Colors.grey[400]!,
                            // blurStyle: BlurStyle.solid
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.plan.nation}",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const Gap(10),
                          Text(
                            "${DateUtil.dateToString(widget.plan.schedule!.first!)} ~ ${DateUtil.dateToString(widget.plan.schedule!.last!)}",
                            style: const TextStyle(wordSpacing: 15),
                          ),
                        ],
                      ),
                    ),
                    const Gap(40),
                    SizedBox(
                      height: 70 * itemList.length.toDouble(),
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, idx) {
                            return Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  switch (itemList[idx]) {
                                    case "예상 경비":
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpectationPage(planId: widget.plan.id)));
                                    case "항공권":
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AirTicketPage(planId: widget.plan.id!)));
                                    case "준비물":
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuppliesPage(planId: widget.plan.id!)));
                                    case "로밍(E-SIM)":
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoamingPage(planId: widget.plan.id!)));
                                    case "여행 경비":
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountBookPage(plan: widget.plan)));
                                    case "숙소":
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccommodationPage(plan: widget.plan)));
                                    case "사용 경비":
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountBookPage(plan: widget.plan)));
                                    // case "일정":
                                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => TourPage(plan: widget.plan)));
                                    default:
                                      return;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                    side: BorderSide(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                label: Text(
                                  itemList[idx],
                                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                                ),
                                iconAlignment: IconAlignment.end,
                                icon: _iconSelector(idx, isDarkMode),
                              ),
                            );
                          },
                          separatorBuilder: (context, idx) => const Gap(20),
                          itemCount: itemList.length),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoaded && _admobUtil.bannerAd != null)
              SizedBox(
                height: _admobUtil.bannerAd!.size.height.toDouble(),
                width: _admobUtil.bannerAd!.size.width.toDouble(),
                child: _admobUtil.getBannerAdWidget(),
              )
          ]),
        ),
      ),
    );
  }

  Widget _iconSelector(int idx, bool isDarkMode) {
    switch (idx) {
      case 0:
        return  Icon(Icons.bar_chart, color: isDarkMode ? Colors.white : Colors.black87,);
      case 1:
        return  Icon(Icons.airplane_ticket, color: isDarkMode ? Colors.white : Colors.black87,);
      case 2:
        return  Icon(Icons.shopping_bag_rounded, color: isDarkMode ? Colors.white : Colors.black87,);
      case 3:
        return  Icon(Icons.sim_card, color: isDarkMode ? Colors.white : Colors.black87,);
      case 4:
        return  Icon(Icons.attach_money, color: isDarkMode ? Colors.white : Colors.black87,);
      case 5:
        return  Icon(Icons.hotel, color: isDarkMode ? Colors.white : Colors.black87,);
      default:
        return  Icon(Icons.abc, color: isDarkMode ? Colors.white : Colors.black87,);
    }
  }
}
