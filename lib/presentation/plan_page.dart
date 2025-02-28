import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/presentation/accommodation_page.dart';
import 'package:ready_go_project/presentation/account_book_page.dart';
import 'package:ready_go_project/presentation/air_ticket_page.dart';
import 'package:ready_go_project/presentation/roaming_page.dart';
import 'package:ready_go_project/presentation/supplies_page.dart';


import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/accommodation_provider.dart';
import '../domain/entities/provider/account_provider.dart';
import '../domain/entities/provider/admob_provider.dart';
import '../domain/entities/provider/images_provider.dart';
import '../domain/entities/provider/roaming_provider.dart';
import '../domain/entities/provider/supplies_provider.dart';
import '../domain/entities/provider/theme_mode_provider.dart';
import '../util/date_util.dart';

class PlanPage extends StatefulWidget {
  final PlanModel plan;

  const PlanPage({super.key, required this.plan});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  List<String> itemList = ["항공권", "준비물", "로밍 & ESIM", "여행 경비", "숙소"];

  // List<String> itemList = ["항공권", "준비물", "로밍 & ESIM", "여행 경비", "숙소", "일정"];

  @override
  Widget build(BuildContext context) {
    // PlanModel plan = ModalRoute.of(context)!.settings.arguments as PlanModel;
    if (kReleaseMode) {
      context.watch<AdmobProvider>().loadAdBanner();
    }
    DataState state = context
        .watch<DataBloc>()
        .state;
    if (state.state == DataStatus.loadedPlanList) {
      context.read<ImagesProvider>().getImgList(widget.plan.id!);
      context.read<SuppliesProvider>().getList(widget.plan.id!);
      context.read<RoamingProvider>().getRoamingDate(widget.plan.id!);
      context.read<AccountProvider>().getAccountInfo(widget.plan.id!);
      context.read<AccommodationProvider>().getAccommodationList(widget.plan.id!);

      // context.read<ImagesProvider>().getImgList(widget.plan.id!);
      context.read<DataBloc>().add(DataLoadingPlanEvent());
    }
    bool isDarkMode = context
        .watch<ThemeModeProvider>()
        .isDarkMode;
    return Scaffold(
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
      body: Stack(children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              Center(
                child: Container(
                  height: MediaQuery
                      .sizeOf(context)
                      .height - 100,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.plan.nation}",
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const Gap(5),
                          Text(
                            "${DateUtil.dateToString(widget.plan.schedule!.first!)} ~ ${DateUtil.dateToString(
                                widget.plan.schedule!.last!)}",
                            style: const TextStyle(wordSpacing: 15),
                          ),
                          const Gap(5),
                          const Divider()
                        ],
                      ),
                      Container(
                        width: constraints.maxWidth <= 600 ? MediaQuery
                            .sizeOf(context)
                            .width : 840,
                        // height: (itemList.length * 70) + 60,
                        padding: const EdgeInsets.all(20),
                        child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, idx) {
                              return SizedBox(
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    switch (itemList[idx]) {
                                      case "항공권":
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AirTicketPage(planId: widget.plan.id!)));
                                      case "준비물":
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuppliesPage(planId: widget.plan.id!)));
                                      case "로밍 & ESIM":
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoamingPage(planId: widget.plan.id!)));
                                      case "여행 경비":
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountBookPage(plan: widget.plan)));
                                      case "숙소":
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccommodationPage(plan: widget.plan)));
                                    // case "일정":
                                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => TourPage(plan: widget.plan)));
                                      default:
                                        return;
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .surface,
                                      side: BorderSide(color: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    )
                                  ),
                                  label: Text(
                                    itemList[idx],
                                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                                  ),
                                  iconAlignment: IconAlignment.end,
                                  icon: _iconSelector(idx),
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
        ),
        Builder(builder: (context) {
          final BannerAd? bannerAd = context
              .watch<AdmobProvider>()
              .bannerAd;
          final logger = Logger();
          if (bannerAd != null) {
            return Positioned(
                left: 20,
                right: 20,
                bottom: 30,
                child: SizedBox(
                  width: bannerAd.size.width.toDouble(),
                  height: bannerAd.size.height.toDouble(),
                  child: AdWidget(
                    ad: bannerAd,
                  ),
                ));
          } else {
            logger.d("banner is null on plan page");
            return const SizedBox();
          }
        })
      ]),
    );
  }
  Widget _iconSelector(int idx){
    switch(idx){
      case 0:
        return const Icon(Icons.airplane_ticket);
      case 1:
        return const Icon(Icons.shopping_bag_rounded);
      case 2:
        return const Icon(Icons.sim_card);
      case 3:
        return const Icon(Icons.attach_money);
      case 4:
        return const Icon(Icons.hotel);

      default: return const Icon(Icons.abc);
    }
  }
}
