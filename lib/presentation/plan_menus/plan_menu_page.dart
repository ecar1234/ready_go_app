import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/presentation/plan_menus/accommodation_page.dart';
import 'package:ready_go_project/presentation/plan_menus/account_book_page.dart';
import 'package:ready_go_project/presentation/plan_menus/air_ticket_page.dart';
import 'package:ready_go_project/presentation/plan_menus/expectation_page.dart';
import 'package:ready_go_project/presentation/plan_menus/roaming_page.dart';
import 'package:ready_go_project/presentation/plan_menus/schedule_page/schedule_page.dart';
import 'package:ready_go_project/presentation/plan_menus/supplies_page/supplies_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ready_go_project/util/localizations_util.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../domain/entities/provider/admob_provider.dart';
import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../domain/entities/provider/theme_mode_provider.dart';
import '../../util/admob_util.dart';

class PlanMenuPage extends StatefulWidget {
  final PlanModel plan;

  const PlanMenuPage({super.key, required this.plan});

  @override
  State<PlanMenuPage> createState() => _PlanMenuPageState();
}

class _PlanMenuPageState extends State<PlanMenuPage> {
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  final _logger = Logger();

  // List<String> itemList = ["항공권", "준비물", "로밍(E-SIM)", "사용 경비", "숙소"];
  // List<String> itemList = ["항공권", "준비물", "로밍 & ESIM", "여행 경비", "숙소", "일정"];

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
              _logger.e("banner is not loaded");
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;

    List<String> itemList = [
      AppLocalizations.of(context)!.menuExpensePlan,
      AppLocalizations.of(context)!.menuFlightTicket,
      AppLocalizations.of(context)!.menuCheckList,
      AppLocalizations.of(context)!.menuRoaming,
      AppLocalizations.of(context)!.menuSpentBudget,
      AppLocalizations.of(context)!.menuAccommodation,
      AppLocalizations.of(context)!.menuSchedule
    ];

    List<String> korItemList = ["예상 경비", "체크 리스트", "사용 경비", "숙소", "일정"];
    bool isPlanKor = widget.plan.nation == "대한민국";
    bool isKor = Localizations.localeOf(context).languageCode == "ko";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.planMainTitle),
          leading: IconButton(
            onPressed: () {
              Get.back();
              context.read<DataBloc>().add(DataResetEvent());
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: BlocBuilder<DataBloc, DataState>(
          builder: (context, state){
            if (state.state == DataStatus.loadedPlanList) {
              // context.read<ImagesProvider>().getImgList(widget.plan.id!);
              context.read<DataBloc>().add(PlanDataLoadingEvent(context: context, planId: widget.plan.id!));
            }
            return Center(
              child: Container(
                height: height,
                padding: const EdgeInsets.all(20),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
                      height: height - 100,
                      width: constraints.maxWidth > 800 ? 700 : MediaQuery.sizeOf(context).width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            // height: 70 * itemList.length.toDouble(),
                            child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, idx) {
                                  return Container(
                                    height: 60,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
                                        if (kReleaseMode && !isRemove) {
                                          if (itemList[idx] == AppLocalizations.of(context)!.menuCheckList ||
                                              itemList[idx] == AppLocalizations.of(context)!.menuAccommodation ||
                                              itemList[idx] == AppLocalizations.of(context)!.menuExpensePlan ||
                                              itemList[idx] == AppLocalizations.of(context)!.menuRoaming) {
                                            context.read<AdmobProvider>().loadAdInterstitialAd();
                                            context.read<AdmobProvider>().showInterstitialAd();
                                          }
                                        }
                                        if (isKor && isPlanKor) {
                                          switch (korItemList[idx]) {
                                            case "예상 경비":
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(builder: (context) => ExpectationPage(planId: widget.plan.id)));
                                            case "체크 리스트":
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(builder: (context) => SuppliesPage(planId: widget.plan.id!)));
                                            case "여행 경비":
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountBookPage(plan: widget.plan)));
                                            case "숙소":
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(builder: (context) => AccommodationPage(plan: widget.plan)));
                                            case "사용 경비":
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountBookPage(plan: widget.plan)));
                                            case "일정":
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SchedulePage(plan: widget.plan)));
                                            default:
                                              return;
                                          }
                                        } else {
                                          if (itemList[idx] == AppLocalizations.of(context)!.menuExpensePlan) {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) => ExpectationPage(planId: widget.plan.id)));
                                          } else if (itemList[idx] == AppLocalizations.of(context)!.menuFlightTicket) {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) => AirTicketPage(planId: widget.plan.id!)));
                                          } else if (itemList[idx] == AppLocalizations.of(context)!.menuCheckList) {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) => SuppliesPage(planId: widget.plan.id!)));
                                          } else if (itemList[idx] == AppLocalizations.of(context)!.menuRoaming) {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoamingPage(planId: widget.plan.id!)));
                                          } else if (itemList[idx] == AppLocalizations.of(context)!.menuSpentBudget) {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountBookPage(plan: widget.plan)));
                                          } else if (itemList[idx] == AppLocalizations.of(context)!.menuAccommodation) {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccommodationPage(plan: widget.plan)));
                                          } else {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SchedulePage(plan: widget.plan)));
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                          side: BorderSide(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      label: Text(
                                        isKor && isPlanKor ? korItemList[idx] : itemList[idx],
                                        style: LocalizationsUtil.setTextStyle(isKor,
                                            color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                                      ),
                                      iconAlignment: IconAlignment.end,
                                      icon: _iconSelector(idx, isKor, isPlanKor, isDarkMode),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, idx) => const Gap(20),
                                itemCount: isKor && isPlanKor ? korItemList.length : itemList.length),
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
            );
          },
        ),
      ),
    );
  }

  Widget _iconSelector(int idx, bool isKor, bool isPlanKor, bool isDarkMode) {
    if (isKor && isPlanKor) {
      switch (idx) {
        case 0:
          return Icon(
            Icons.bar_chart,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 1:
          return Icon(
            Icons.shopping_bag_rounded,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 2:
          return Icon(
            Icons.attach_money,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 3:
          return Icon(
            Icons.hotel,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 4:
          return Icon(
            Icons.schedule,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        default:
          return Icon(
            Icons.abc,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
      }
    } else {
      switch (idx) {
        case 0:
          return Icon(
            Icons.bar_chart,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 1:
          return Icon(
            Icons.airplane_ticket,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 2:
          return Icon(
            Icons.shopping_bag_rounded,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 3:
          return Icon(
            Icons.sim_card,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 4:
          return Icon(
            Icons.attach_money,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 5:
          return Icon(
            Icons.hotel,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        case 6:
          return Icon(
            Icons.schedule,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
        default:
          return Icon(
            Icons.abc,
            color: isDarkMode ? Colors.white : Colors.black87,
          );
      }
    }
  }
}
