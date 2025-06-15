import 'dart:async';

// import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:ready_go_project/util/date_util.dart';
import 'package:ready_go_project/util/intl_utils.dart';
import 'package:ready_go_project/util/localizations_util.dart';
import 'package:ready_go_project/util/statistics_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../domain/entities/provider/account_provider.dart';
import '../../domain/entities/provider/admob_provider.dart';
import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../util/admob_util.dart';

class AccountBookPage extends StatefulWidget {
  final PlanModel plan;

  const AccountBookPage({super.key, required this.plan});

  @override
  State<AccountBookPage> createState() => _AccountBookPageState();
}

class _AccountBookPageState extends State<AccountBookPage> {
  // 경비 추가
  final TextEditingController _totalDaysController = TextEditingController(text: "1");
  final TextEditingController _totalAmountController = TextEditingController();

  // 수정 및 지출
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _usedTypeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _payAmountController = TextEditingController();

  // 일차 선택 index
  int _selectedDay = 0;

  final logger = Logger();

  // final TextEditingController _editDetailController = TextEditingController(text: amount.title);
  // final TextEditingController _editAmountController = TextEditingController(text: amount.amount.toString());
  // final TextEditingController _editCategoryController = TextEditingController();
  // final PageController _expandController = PageController(initialPage: 0);
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  Timer? _debounce;

  // _onChanged(String value) {
  //   if (_debounce?.isActive ?? false) {
  //     _debounce?.cancel();
  //   }
  //   _debounce = Timer(const Duration(milliseconds: 500), () {});
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AdmobProvider>().loadAdBanner());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kReleaseMode) {
        final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
        if (!isRemove) {
          context.read<AdmobProvider>().interstitialAd!.show();
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
    _daysController.dispose();
    _titleController.dispose();
    _payAmountController.dispose();
    _usedTypeController.dispose();
    _categoryController.dispose();

    _totalAmountController.dispose();
    _totalDaysController.dispose();
    // _expandController.dispose();
    _debounce?.cancel();
    _admobUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final AccountModel info = context.watch<AccountProvider>().accountInfo!;
    final isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final double bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("여행경비"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: height,
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                height: height - bannerHei - 40,
                child: _page1(context, height - bannerHei - 40, isDarkMode),
                // child: ExpandablePageView(controller: _expandController, physics: const BouncingScrollPhysics(), children: [
                //   _page1(context, height - bannerHei - 40, isDarkMode),
                //   // _page2(context, height - bannerHei - 40, info, isDarkMode)
                // ]),
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
      ),
    );
  }

  Widget _page1(BuildContext context, double hei, bool isDarkMode) {
    return SizedBox(
      height: hei,
      child: Column(
        children: [
          _totalInfoSection(context, hei, isDarkMode),

          // SizedBox(
          //   width: 140,
          //   height: 50,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         _expandController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
          //       },
          //       style: ElevatedButton.styleFrom(
          //           backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
          //           side: BorderSide(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //           padding: EdgeInsets.zero),
          //       child: Text(
          //         "사용내역 보기",
          //         style:
          //             TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
          //       )),
          // )
        ],
      ),
    );
  }

  // Widget _page2(BuildContext context, double hei, AccountModel info, bool isDarkMode) {
  //   // final hei = GetIt.I.get<ResponsiveHeightProvider>().resHeight!;
  //   // final bannerHei = _admobUtil.bannerAd!.size.height;
  //   return SizedBox(
  //       height: hei,
  //       child: Column(
  //         children: [
  //           SizedBox(
  //             height: 40,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   "사용내역",
  //                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
  //                 ),
  //                 SizedBox(
  //                   width: 100,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () {
  //                       _addAmountDialog(context, null, null, null, isDarkMode);
  //                     },
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
  //                       padding: EdgeInsets.zero,
  //                     ),
  //                     label: Text(
  //                       "지출",
  //                       style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
  //                     ),
  //                     icon: Icon(Icons.remove, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
  //                     iconAlignment: IconAlignment.end,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           const Gap(10),
  //           Container(
  //             height: 60,
  //             width: MediaQuery.sizeOf(context).width,
  //             decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
  //             child: Flex(
  //               direction: Axis.horizontal,
  //               children: [
  //                 // 잔여 경비
  //                 Expanded(
  //                     flex: 1,
  //                     child: Container(
  //                       decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
  //                       child: Flex(
  //                         direction: Axis.horizontal,
  //                         children: [
  //                           Expanded(
  //                               flex: 1,
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                     color: Theme.of(context).colorScheme.primary,
  //                                     border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline)),
  //                                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
  //                                 child: const Column(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Text(
  //                                       "잔액",
  //                                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  //                                     ),
  //                                     Text(
  //                                       "(환전)",
  //                                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               )),
  //                           Expanded(
  //                               flex: 2,
  //                               child: Container(
  //                                 padding: const EdgeInsets.all(5),
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.end,
  //                                   children: [
  //                                     Text(
  //                                       IntlUtils.stringIntAddComma(info.balance ?? 0),
  //                                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //                                     )
  //                                   ],
  //                                 ),
  //                               ))
  //                         ],
  //                       ),
  //                     )),
  //                 // 총 사용 금액
  //                 Expanded(
  //                     flex: 1,
  //                     child: Flex(
  //                       direction: Axis.horizontal,
  //                       children: [
  //                         Expanded(
  //                             flex: 1,
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                   color: Theme.of(context).colorScheme.primary,
  //                                   border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
  //                               child: const Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Text(
  //                                     "총 지출",
  //                                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  //                                   ),
  //                                   Text(
  //                                     "(환전)",
  //                                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
  //                                   )
  //                                 ],
  //                               ),
  //                             )),
  //                         Expanded(
  //                             flex: 2,
  //                             child: Container(
  //                               padding: const EdgeInsets.all(10),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   Text(
  //                                     IntlUtils.stringIntAddComma(info.useExchangeMoney ?? 0),
  //                                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //                                   )
  //                                 ],
  //                               ),
  //                             ))
  //                       ],
  //                     )),
  //               ],
  //             ),
  //           ),
  //           const Gap(10),
  //           info.usageHistory == null || info.usageHistory!.isEmpty
  //               ? SizedBox(
  //                   width: MediaQuery.sizeOf(context).width,
  //                   height: hei - 120,
  //                   child: const Center(
  //                     child: Text("사용내역이 없습니다."),
  //                   ),
  //                 )
  //               : SizedBox(
  //                   height: hei - 130,
  //                   child: Column(
  //                     children: [
  //                       Expanded(
  //                         child: ListView.separated(
  //                           shrinkWrap: true,
  //                           physics: const ClampingScrollPhysics(),
  //                           itemBuilder: (context, fidx) {
  //                             List<List<AmountModel>?> amountList = info.usageHistory!;
  //                             return Container(
  //                               width: MediaQuery.sizeOf(context).width - 40,
  //                               decoration: BoxDecoration(
  //                                   border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
  //                               child: Column(
  //                                 children: [
  //                                   Row(
  //                                     mainAxisAlignment: MainAxisAlignment.start,
  //                                     children: [
  //                                       // date section
  //                                       Container(
  //                                           height: 40,
  //                                           width: MediaQuery.sizeOf(context).width - 42,
  //                                           padding: const EdgeInsets.symmetric(horizontal: 10),
  //                                           decoration: BoxDecoration(
  //                                               color: Theme.of(context).colorScheme.primary,
  //                                               border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline)),
  //                                               borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
  //                                           child: Column(
  //                                             mainAxisAlignment: MainAxisAlignment.center,
  //                                             crossAxisAlignment: CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 "${amountList[fidx]!.first.usageTime!.month}월 ${amountList[fidx]!.first.usageTime!.day}일(${amountList[fidx]!.first.id}일차)",
  //                                                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
  //                                               ),
  //                                             ],
  //                                           )),
  //                                     ],
  //                                   ),
  //                                   // title menu
  //                                   Container(
  //                                     height: 40,
  //                                     decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline))),
  //                                     child: Row(
  //                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                                       children: [
  //                                         SizedBox(
  //                                             width: (MediaQuery.sizeOf(context).width - 42) * 0.2,
  //                                             child: const Center(
  //                                                 child: Text(
  //                                               "종류",
  //                                               style: TextStyle(fontWeight: FontWeight.w600),
  //                                             ))),
  //                                         Container(
  //                                             width: (MediaQuery.sizeOf(context).width - 42) * 0.5,
  //                                             decoration: BoxDecoration(
  //                                                 border: Border.symmetric(vertical: BorderSide(color: Theme.of(context).colorScheme.outline))),
  //                                             child: const Center(
  //                                                 child: Text(
  //                                               "사용 내역",
  //                                               style: TextStyle(fontWeight: FontWeight.w600),
  //                                             ))),
  //                                         SizedBox(
  //                                             width: (MediaQuery.sizeOf(context).width - 42) * 0.3,
  //                                             child: const Center(
  //                                                 child: Text(
  //                                               "금액",
  //                                               style: TextStyle(fontWeight: FontWeight.w600),
  //                                             ))),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   // use detail
  //                                   ListView.builder(
  //                                     shrinkWrap: true,
  //                                     physics: const NeverScrollableScrollPhysics(),
  //                                     itemBuilder: (context, idx) {
  //                                       List<AmountModel> list = amountList[fidx]!;
  //                                       return Container(
  //                                         decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline))),
  //                                         child: Column(
  //                                           children: [
  //                                             Column(
  //                                               children: [
  //                                                 GestureDetector(
  //                                                   onTap: () {
  //                                                     _usedAmountEdit(context, info.usageHistory, fidx, idx);
  //                                                   },
  //                                                   child: Row(
  //                                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                                                     children: [
  //                                                       SizedBox(
  //                                                           height: 40,
  //                                                           width: (MediaQuery.sizeOf(context).width - 42) * 0.2,
  //                                                           child: Center(child: Text(list[idx].category == 0 ? "현금" : "카드"))),
  //                                                       Container(
  //                                                           height: 40,
  //                                                           width: (MediaQuery.sizeOf(context).width - 42) * 0.5,
  //                                                           decoration: BoxDecoration(
  //                                                               border: Border.symmetric(
  //                                                                   vertical: BorderSide(color: Theme.of(context).colorScheme.outline))),
  //                                                           child: Center(child: Text("${list[idx].title}"))),
  //                                                       SizedBox(
  //                                                           height: 40,
  //                                                           width: (MediaQuery.sizeOf(context).width - 42) * 0.3,
  //                                                           child: Center(
  //                                                               child: Text(
  //                                                             IntlUtils.stringIntAddComma(list[idx].amount ?? 0),
  //                                                             style: TextStyle(
  //                                                                 fontWeight: FontWeight.w600,
  //                                                                 color: list[idx].type == AmountType.add
  //                                                                     ? Colors.blueAccent
  //                                                                     : (list[idx].category == 0 ? Colors.redAccent : Colors.green)),
  //                                                           ))),
  //                                                     ],
  //                                                   ),
  //                                                 )
  //                                               ],
  //                                             )
  //                                           ],
  //                                         ),
  //                                       );
  //                                     },
  //                                     itemCount: amountList[fidx]!.length,
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                           separatorBuilder: (context, fidx) => const Gap(20),
  //                           itemCount: info.usageHistory!.length,
  //                         ),
  //                       ),
  //                       const Gap(10),
  //                       SizedBox(
  //                         width: 120,
  //                         height: 50,
  //                         child: ElevatedButton(
  //                             onPressed: () {
  //                               _expandController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  //                             },
  //                             style: ElevatedButton.styleFrom(
  //                                 side: BorderSide(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
  //                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //                                 padding: EdgeInsets.zero),
  //                             child: const Text(
  //                               "경비내역 보기",
  //                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //                             )),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //         ],
  //       ));
  // }

  Widget _totalInfoSection(BuildContext context, double hei, bool isDarkMode) {
    final wid = MediaQuery.sizeOf(context).width;
    final unit = widget.plan.unit;

    final isKor = Localizations.localeOf(context).languageCode == "ko";
    final localization = AppLocalizations.of(context)!;
    return SizedBox(
      child: Column(
        children: [
          //add / minus buttons
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 50) / 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _setTotalAmountDialog(context, localization, isDarkMode, isKor);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    label: Text(
                      localization.addExpenses,
                      style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                    ),
                    icon: Icon(Icons.add, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 50) / 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _addAmountDialog(context, localization, null, null, isDarkMode, isKor);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                      padding: EdgeInsets.zero,
                    ),
                    label: Text(
                      localization.spent,
                      style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Theme.of(context).colorScheme.secondary : Colors.red),
                    ),
                    icon: Icon(Icons.remove, color: isDarkMode ? Theme.of(context).colorScheme.secondary : Colors.red),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          // total infos
          SizedBox(
            height: (hei - 70) * 0.1,
            width: wid - 40,
            // padding: const EdgeInsets.symmetric(vertical: 10),
            // decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  // height: 60,
                  width: wid - 40,
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                              width: (wid - 40) / 2,
                              child: Column(
                                children: [
                                  Text(
                                    localization.travelExpenses,
                                    style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Selector<AccountProvider, int>(selector: (context, provider) {
                                    if (provider.accountInfo != null) {
                                      return provider.accountInfo!.totalExchangeCost ?? 0;
                                    } else {
                                      return 0;
                                    }
                                  }, builder: (context, total, child) {
                                    return RichText(
                                      text: TextSpan(
                                          text: IntlUtils.stringIntAddComma(total),
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                                          children: [
                                            TextSpan(
                                                text: " $unit",
                                                style: GoogleFonts.notoSans(
                                                    fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary))
                                          ]),
                                    );
                                  })
                                ],
                              ))),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                              width: (wid - 40) / 2,
                              child: Column(
                                children: [
                                  Text(
                                    localization.remainExpenses,
                                    style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Selector<AccountProvider, int>(selector: (context, provider) {
                                    if (provider.accountInfo != null) {
                                      return provider.accountInfo!.balance ?? 0;
                                    }
                                    return 0;
                                  }, builder: (context, balance, child) {
                                    return RichText(
                                      text: TextSpan(
                                          text: IntlUtils.stringIntAddComma(balance),
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                                          children: [
                                            TextSpan(
                                                text: " $unit",
                                                style: GoogleFonts.notoSans(
                                                    fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary))
                                          ]),
                                    );
                                  })
                                ],
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),

          // total usage Info
          SizedBox(
            height: (hei - 70) * 0.8,
            // padding: const EdgeInsets.all(10),
            // decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                // day index
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, idx) {
                        final scheduleDay = widget.plan.schedule![0]!.add(Duration(days: idx));
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDay = idx;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: _selectedDay == idx
                                    ? (isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).primaryColor)
                                    : (isDarkMode ? Theme.of(context).primaryColor : Colors.white),
                                border: Border.all(
                                    color: _selectedDay == idx
                                        ? (isDarkMode ? Colors.transparent : Colors.white)
                                        : (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary)),
                                borderRadius: BorderRadius.circular(24)),
                            child: Text(
                              isKor
                                  ? "${scheduleDay.month}월${scheduleDay.day}일 (${idx + 1}일차)"
                                  : "${scheduleDay.month}.${scheduleDay.day} (${localization.day} ${idx + 1})",
                              style: LocalizationsUtil.setTextStyle(isKor,
                                  color: _selectedDay == idx ? Colors.white : (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                  fontWeight: _selectedDay == idx ? FontWeight.w600 : FontWeight.w400),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, idx) => const Gap(5),
                      itemCount: DateUtil.datesDifference(widget.plan.schedule!) + 1),
                ),
                const Gap(10),
                Expanded(
                  child: Selector<AccountProvider, List<AmountModel>?>(selector: (context, provider) {
                    if (provider.accountInfo != null) {
                      return provider.accountInfo!.usageHistory![_selectedDay];
                    } else {
                      return [];
                    }
                  }, builder: (context, info, child) {
                    if (info == null || info.isEmpty) {
                      return SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localization.accountEmptyTitle,
                              style: LocalizationsUtil.setTextStyle(isKor, size: isKor ? 20 : 18, fontWeight: FontWeight.w600),
                            ),
                            const Gap(24),
                            RichText(
                                text: TextSpan(
                                    text: isKor ? "${_selectedDay + 1} ${localization.day} " : "${localization.day} ${_selectedDay + 1}",
                                    style: LocalizationsUtil.setTextStyle(isKor,
                                        fontWeight: FontWeight.w600, size: 16, color: isDarkMode ? Colors.white : Colors.black87),
                                    children: [
                                  TextSpan(
                                      text: localization.accountEmptyDesc,
                                      style: LocalizationsUtil.setTextStyle(isKor,
                                          size: 14, fontWeight: FontWeight.w400, color: isDarkMode ? Colors.white : Colors.black87))
                                ])),
                          ],
                        ),
                      );
                    }
                    return SizedBox(
                      width: MediaQuery.sizeOf(context).width - 40,
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, idx) {
                            return Card(
                              // height: 60,
                              // width: wid - 60,
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // title + amount
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                        width: (wid - 60) * 0.6,
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              info[idx].title!,
                                              style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: IntlUtils.stringIntAddComma(info[idx].amount!),
                                                  style: LocalizationsUtil.setTextStyle(isKor,
                                                      size: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: info[idx].type == AmountType.add
                                                          ? Colors.blueAccent
                                                          : (info[idx].category == 0 ? Colors.redAccent : Colors.green)),
                                                  children: [
                                                    TextSpan(
                                                        text: " $unit",
                                                        style: GoogleFonts.notoSans(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                            color: info[idx].type == AmountType.add
                                                                ? Colors.blueAccent
                                                                : (info[idx].category == 0 ? Colors.redAccent : Colors.green)))
                                                  ]),
                                            )
                                          ],
                                        )),
                                  ),
                                  // Flexible(
                                  //   flex: 2,
                                  //   child: SizedBox(
                                  //     width: (wid - 60) * 0.2,
                                  //     height: 40,
                                  //     child: Car≥d(
                                  //       // color: items[firstIdx]![secondIdx].category == 0 ? Colors.redAccent : Colors.green,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(8)
                                  //       ),
                                  //         child: Center(child: Text(items[firstIdx]![secondIdx].category == 0 ? "현금" : "카드",
                                  //         style: TextStyle(color: items[firstIdx]![secondIdx].category == 0 ? Colors.redAccent : Colors.green),))),
                                  //   ),
                                  // ),
                                  Flexible(
                                    flex: 3,
                                    child: SizedBox(
                                      width: (wid - 60) * 0.3,
                                      height: 45,
                                      child: info[idx].type == AmountType.add
                                          ? const Center(child: Text("-"))
                                          : Card(
                                              color: StatisticsUtil.getCardColor(info[idx].methodType ?? MethodType.ect),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                              child: Center(
                                                  child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text(
                                                  StatisticsUtil.conversionMethodTypeToString(
                                                      Localizations.localeOf(context).languageCode, info[idx].methodType ?? MethodType.ect),
                                                  style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              )),
                                            ),
                                    ),
                                  ),
                                  // Flexible(
                                  //     flex: 1,
                                  //     child: SizedBox(
                                  //       width: (wid - 60) * 0.2,
                                  //     )),
                                  Flexible(
                                      flex: 1,
                                      child: SizedBox(
                                        height: 50,
                                        width: (wid - 60) * 0.1,
                                        child: PopupMenuButton(
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(value: "edit", child: Text(localization.modify)),
                                              PopupMenuItem(value: "delete", child: Text(localization.delete)),
                                            ];
                                          },
                                          onSelected: (value) {
                                            if (value == "edit") {
                                              _addAmountDialog(context, localization, info[idx], idx, isDarkMode, isKor);
                                            } else {
                                              context.read<AccountProvider>().removeAmountItem(_selectedDay, idx, widget.plan.id!);
                                            }
                                          },
                                        ),
                                      ))
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, idx) => const Gap(5),
                          itemCount: info.length),
                    );
                  }),
                ),
              ],
            ),
          ),
          const Gap(10),
          // use method info
          SizedBox(
            height: (hei - 70) * 0.1,
            // decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: (hei - 70) * 0.1,
                  width: wid - 40,
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                              width: (wid - 40) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localization.totalCost,
                                    style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
                                  ),
                                  Selector<AccountProvider, AccountModel>(selector: (context, provider) {
                                    if (provider.accountInfo != null) {
                                      return provider.accountInfo!;
                                    } else {
                                      return AccountModel()
                                        ..totalExchangeCost = 0
                                        ..balance = 0
                                        ..useExchangeMoney = 0
                                        ..useCard = 0
                                        ..useKoCash = 0
                                        ..usageHistory = [];
                                    }
                                  }, builder: (context, item, child) {
                                    var total = (item.useExchangeMoney ?? 0) + (item.useCard ?? 0);
                                    return RichText(
                                      text: TextSpan(
                                          text: IntlUtils.stringIntAddComma(total),
                                          style: LocalizationsUtil.setTextStyle(isKor,
                                              size: 16,
                                              fontWeight: FontWeight.w600,
                                              color: isDarkMode ? Theme.of(context).colorScheme.secondary : Colors.brown),
                                          children: [
                                            TextSpan(
                                                text: " $unit",
                                                style: GoogleFonts.notoSans(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDarkMode ? Theme.of(context).colorScheme.secondary : Colors.brown))
                                          ]),
                                    );
                                  })
                                ],
                              ))),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                              width: (wid - 40) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localization.cashUsed,
                                    style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
                                  ),
                                  Selector<AccountProvider, int>(selector: (context, provider) {
                                    if (provider.accountInfo != null) {
                                      return provider.accountInfo!.useExchangeMoney ?? 0;
                                    } else {
                                      return 0;
                                    }
                                  }, builder: (context, exchange, child) {
                                    return RichText(
                                      text: TextSpan(
                                          text: IntlUtils.stringIntAddComma(exchange),
                                          style:
                                              LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600, color: Colors.redAccent),
                                          children: [
                                            TextSpan(
                                                text: " $unit",
                                                style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.redAccent))
                                          ]),
                                    );
                                  })
                                ],
                              ))),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                              width: (wid - 40) / 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    localization.cardUsed,
                                    style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
                                  ),
                                  Selector<AccountProvider, int>(selector: (context, provider) {
                                    if (provider.accountInfo != null) {
                                      return provider.accountInfo!.useCard ?? 0;
                                    } else {
                                      return 0;
                                    }
                                  }, builder: (context, card, child) {
                                    return RichText(
                                      text: TextSpan(
                                          text: IntlUtils.stringIntAddComma(card),
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                                          children: [
                                            TextSpan(
                                                text: " $unit",
                                                style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green))
                                          ]),
                                    );
                                  })
                                ],
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addAmountDialog(BuildContext context, AppLocalizations localization, AmountModel? item, int? itemIdx, bool isDarkMode, bool isKor) {
    // AmountModel newAmount = AmountModel();
    // final info = context.read<AccountProvider>().accountInfo!;
    // int selectDayInit = 0;
    if (item != null) {
      // selectDayInit = firstIdx! + 1;
      _titleController.text = item.title!;
      _payAmountController.text = IntlUtils.stringIntAddComma(item.amount!);
      _categoryController.text =
          StatisticsUtil.conversionMethodTypeToString(Localizations.localeOf(context).languageCode, item.methodType ?? MethodType.ect);
      _usedTypeController.text = item.category == 0 ? localization.cash : localization.card;
    }
    // else {
    //   if (info.usageHistory != null && info.usageHistory!.isNotEmpty) {
    //     selectDayInit = info.usageHistory!.length;
    //     // titleController.text = info.usageHistory![daysController.text]
    //   } else {
    //     selectDayInit = 1;
    //   }
    // }

    return showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                item == null
                                    ? (isKor ? "지출 (${_selectedDay + 1}일차)" : "${localization.day} ${_selectedDay + 1} ${localization.spent}")
                                    : localization.modify,
                                style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      const Gap(10),
                      if (item == null || item.type == AmountType.use)
                        // 카테고리 선택
                        SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // 일차 선택
                              // Flexible(
                              //   flex: 4,
                              //   child: SizedBox(
                              //     width: (MediaQuery.sizeOf(context).width - 80) * 0.4,
                              //     height: 60,
                              //     child: DropdownMenu(
                              //       controller: _daysController,
                              //       dropdownMenuEntries: List.generate(DateUtil.datesDifference(widget.plan.schedule!) + 2, (int idx) {
                              //         if (idx == 0) {
                              //           return DropdownMenuEntry(value: idx, label: "일차선택");
                              //         }
                              //         return DropdownMenuEntry(value: idx, label: "$idx 일차");
                              //       }),
                              //       initialSelection: selectDayInit,
                              //       width: 130,
                              //       menuHeight: 200,
                              //       onSelected: (value) {},
                              //     ),
                              //   ),
                              // ),
                              // 카테고리 선택
                              Flexible(
                                flex: 5,
                                child: SizedBox(
                                  width: (MediaQuery.sizeOf(context).width - 80) * 0.5,
                                  height: 60,
                                  child: DropdownMenu(
                                    controller: _categoryController,
                                    dropdownMenuEntries: List.generate(MethodType.values.length + 1, (idx) {
                                      if (idx == 0) {
                                        return DropdownMenuEntry(
                                            value: AppLocalizations.of(context)!.select, label: AppLocalizations.of(context)!.select);
                                      }
                                      String value = "";
                                      value = StatisticsUtil.conversionMethodTypeToString(
                                          Localizations.localeOf(context).languageCode, MethodType.values[idx - 1]);
                                      return DropdownMenuEntry(value: value, label: value);
                                    }),
                                    initialSelection: item == null
                                        ? localization.select
                                        : StatisticsUtil.conversionMethodTypeToString(
                                            Localizations.localeOf(context).languageCode, item.methodType ?? MethodType.ect),
                                    width: 160,
                                    menuHeight: 200,
                                    onSelected: (value) {
                                      _categoryController.text = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const Gap(10),
                      // 타이틀
                      SizedBox(
                        height: 60,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: TextField(
                            controller: _titleController,
                            // onChanged: _onChanged,
                            decoration: InputDecoration(
                                label: Text(localization.details,
                                    style: isKor ? null : LocalizationsUtil.setTextStyle(isKor, size: 12, color: isDarkMode ? Colors.white : Colors.black87)),
                                counterText: ""),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const Gap(10),
                      // 금액 옵션
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 사용금액
                            Flexible(
                              flex: 6,
                              child: SizedBox(
                                height: 60,
                                width: (MediaQuery.sizeOf(context).width - 80) * 0.6,
                                child: TextField(
                                  controller: _payAmountController,
                                  // onChanged: _onChanged,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      label: Text(localization.amount,
                                      style: isKor ? null : LocalizationsUtil.setTextStyle(isKor,  size: 12, color: isDarkMode ? Colors.white : Colors.black87),),
                                  ),
                                  maxLines: 1,
                                  maxLength: 13,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.end,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _payAmountController.text = IntlUtils.stringIntAddComma(int.parse(value));
                                    }
                                  },
                                ),
                              ),
                            ),
                            const Gap(10),
                            // 통화 선택
                            Flexible(
                              flex: 4,
                              child: SizedBox(
                                height: 60,
                                width: (MediaQuery.sizeOf(context).width - 80) * 0.4,
                                child: DropdownMenu(
                                  controller: _usedTypeController,
                                  initialSelection: item == null ? localization.cash : (item.category == 0 ? localization.cash : localization.card),
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(value: localization.cash, label: localization.cash),
                                    DropdownMenuEntry(value: localization.card, label: localization.card)
                                  ],
                                  onSelected: (value) {
                                    _usedTypeController.text = value.toString();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      // buttons
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    _titleController.clear();
                                    _payAmountController.clear();
                                    _usedTypeController.text = localization.cash;
                                    _categoryController.clear();
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero),
                                  child: Text(
                                    localization.close,
                                    style: LocalizationsUtil.setTextStyle(isKor,
                                        color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                  )),
                            ),
                            const Gap(20),
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    // if (_daysController.text == "일차선택") {
                                    //   Get.snackbar("일차를 선택해 주세요.", "일차는 빈 값으로 저장 할 수 없습니다.",
                                    //       colorText: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                    //       backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white);
                                    //   return;
                                    // }
                                    if (_titleController.text.isEmpty) {
                                      Get.snackbar("사용 상세 내역을 입력해 주세요.", "사용 상세 내용은 빈 값으로 저장 할 수 없습니다.",
                                          colorText: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white);
                                      return;
                                    }
                                    if (_payAmountController.text.isEmpty) {
                                      Get.snackbar("사용금액을 입력해 주세요.", "사용 금액은 빈 값으로 저장 할 수 없습니다.",
                                          colorText: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white);
                                      return;
                                    }
                                    if (_categoryController.text.isEmpty) {
                                      Get.snackbar("카테고리를 선택해 주세요", "카테고리는 빈 값으로 저장 할 수 없습니다.",
                                          colorText: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                          backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white);
                                      return;
                                    }

                                    AmountModel newAmount = AmountModel();
                                    if (item != null) {
                                      newAmount.id = _daysController.text.split(" ").first;
                                      newAmount.title = _titleController.text;
                                      newAmount.amount = IntlUtils.removeComma(_payAmountController.text);
                                      newAmount.category = _usedTypeController.text == localization.cash ? 0 : 2;
                                      newAmount.methodType = StatisticsUtil.conversionStringToMethodType(
                                          Localizations.localeOf(context).languageCode, _categoryController.text);
                                      newAmount.type = item.type;
                                      // newAmount.usageTime = item.usageTime;
                                      // int day = int.parse(_daysController.text.split(" ").first);
                                      if (_selectedDay == 0) {
                                        newAmount.usageTime = widget.plan.schedule!.first;
                                      } else {
                                        newAmount.usageTime = widget.plan.schedule!.first!.add(Duration(days: _selectedDay));
                                      }

                                      if (newAmount.id == item.id &&
                                          newAmount.title == item.title &&
                                          newAmount.amount == item.amount &&
                                          newAmount.category == item.category &&
                                          newAmount.methodType == item.methodType) {
                                        Get.snackbar("수정 내용을 확인해 주세요", "변경 사항이 존재하지 않아 수정 할 수 없습니다.",
                                            colorText: Theme.of(context).colorScheme.onSurface,
                                            backgroundColor: Theme.of(context).colorScheme.surface);
                                        return;
                                      }
                                      // _daysController.clear();
                                      _titleController.clear();
                                      _payAmountController.clear();
                                      _usedTypeController.clear();
                                      _categoryController.clear();
                                      context.read<AccountProvider>().editeAmountItem(_selectedDay, itemIdx!, newAmount, widget.plan.id!);

                                      Get.back();
                                    } else {
                                      newAmount.id = _selectedDay.toString();
                                      newAmount.methodType = StatisticsUtil.conversionStringToMethodType(
                                          Localizations.localeOf(context).languageCode, _categoryController.text);
                                      newAmount.title = _titleController.text;
                                      newAmount.type = AmountType.use;
                                      newAmount.amount = IntlUtils.removeComma(_payAmountController.text);
                                      newAmount.category = _usedTypeController.text == localization.cash ? 0 : 2;
                                      // int day = int.parse(_daysController.text.split(" ").first);
                                      if (_selectedDay == 0) {
                                        newAmount.usageTime = widget.plan.schedule!.first;
                                      } else {
                                        newAmount.usageTime = widget.plan.schedule!.first!.add(Duration(days: _selectedDay));
                                      }

                                      context.read<AccountProvider>().addAmount(newAmount, _selectedDay, widget.plan.id!);
                                      // _daysController.clear();
                                      _titleController.clear();
                                      _payAmountController.clear();
                                      _usedTypeController.text = localization.cash;
                                      // _categoryController.clear();
                                      // Get.back();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero),
                                  child: Text(
                                    item != null ? localization.modify : localization.add,
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  Future<void> _setTotalAmountDialog(BuildContext context, AppLocalizations localization, bool isDarkMode, bool isKor) {
    final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                // height: 300,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 일 차 선택
                          SizedBox(
                            child: Text(
                              localization.addExpenses,
                              style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, size: 20),
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              isKor ? "(${_selectedDay + 1}${localization.day})" : "(${localization.day} ${_selectedDay + 1})",
                              style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, size: 20),
                            ),
                          ),
                          // SizedBox(
                          //   height: 60,
                          //   child: DropdownMenu(
                          //     controller: _totalDaysController,
                          //     dropdownMenuEntries: List.generate(DateUtil.datesDifference(widget.plan.schedule!) + 2, (int idx) {
                          //       if (idx == 0) {
                          //         return DropdownMenuEntry(value: "$idx", label: "일차선택");
                          //       }
                          //       return DropdownMenuEntry(value: "$idx 일차", label: "$idx 일차");
                          //     }),
                          //     initialSelection: "0",
                          //     width: 1≥30,
                          //     menuHeight: 200,
                          //     onSelected: (value) {
                          //       _totalDaysController.text = value.toString();
                          //     },
                          //   ),
                          // ),
                          // 카테고리 고정 (경비추가)
                          // SizedBox(
                          //   height: 60,
                          //   child: DropdownMenu(
                          //     enabled: false,
                          //     dropdownMenuEntries: const [DropdownMenuEntry(value: 0, label: "경비추가")],
                          //     initialSelection: 0,
                          //     width: 160,
                          //     menuHeight: 200,
                          //     onSelected: (value) {},
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    // 추가 금액 입력
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: _totalAmountController,
                        // onChanged: _onChanged,
                        decoration: InputDecoration(labelText: localization.amountToAdd),
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.end,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _totalAmountController.text = IntlUtils.stringIntAddComma(int.parse(value));
                          }
                        },
                      ),
                    ),
                    const Gap(20),
                    // buttons
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 취소
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    // backgroundColor: Theme.of(context).colorScheme.primary,
                                    side: isDarkMode ? const BorderSide(color: Colors.white) : null,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  localization.cancel,
                                )),
                          ),
                          const Gap(20),
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_totalAmountController.text.isEmpty) {
                                    Get.snackbar("추가경비 입력 확인", "추가 경비를 입력해 주세요.",
                                        colorText: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                        backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white);
                                    return;
                                  }
                                  if (_totalDaysController.text == "일차선택") {
                                    Get.snackbar("일 차 선택을 해주세요.", "경비 추가 일차를 선택해 주세요.",
                                        colorText: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                        backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white);
                                    return;
                                  }
                                  int amount = IntlUtils.removeComma(_totalAmountController.text);
                                  String title = "";
                                  if (Localizations.localeOf(context).languageCode == "ko") {
                                    title = "경비 추가";
                                  } else if (Localizations.localeOf(context).languageCode == "ja") {
                                    title = "経費追加";
                                  } else {
                                    title = "Additional expenses";
                                  }
                                  // int days = int.parse(_totalDaysController.text.split(" ").first);

                                  if (kReleaseMode && !isRemove) {
                                    context.read<AdmobProvider>().interstitialAd!.show();
                                  }

                                  context.read<AccountProvider>().addTotalAmount(title, amount, _selectedDay, widget.plan.id!);
                                  _totalAmountController.clear();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  localization.add,
                                  style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

// Future<void> _usedAmountEdit(BuildContext context, List<List<AmountModel>?>? history, int fIdx, int sInd) {
//   var amount = history![fIdx]![sInd];
//
//   return showDialog(
//       context: context,
//       builder: (context) {
//         final TextEditingController detailController = TextEditingController(text: amount.title);
//         final TextEditingController amountController = TextEditingController(text: amount.amount.toString());
//         final TextEditingController categoryController =
//             TextEditingController(text: StatisticsUtil.conversionMethodTypeToString(amount.methodType ?? MethodType.ect));
//
//         return Dialog(
//           child: Container(
//               width: MediaQuery.sizeOf(context).width - 60,
//               height: 360,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Column(
//                 children: [
//                   //title
//                   const SizedBox(
//                     height: 60,
//                     child: Center(
//                       child: Text(
//                         "수정 & 삭제",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                   const Divider(),
//                   Container(
//                       height: 250,
//                       padding: const EdgeInsets.only(top: 20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                               child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // category
//                                   SizedBox(
//                                     height: 60,
//                                     child: DropdownMenu(
//                                         controller: categoryController,
//                                         initialSelection: amount.category,
//                                         enabled: amount.type == AmountType.add ? false : true,
//                                         dropdownMenuEntries: const [
//                                           DropdownMenuEntry(value: 0, label: "환전"),
//                                           DropdownMenuEntry(value: 2, label: "카드")
//                                         ]),
//                                   ),
//                                   // amount
//                                   SizedBox(
//                                     width: 120,
//                                     child: TextField(
//                                       controller: amountController,
//                                       textAlign: TextAlign.end,
//                                       decoration: const InputDecoration(
//                                         labelText: "사용금액",
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               const Gap(20),
//                               // detail
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     height: 60,
//                                     child: TextField(
//                                       controller: detailController,
//                                       decoration: const InputDecoration(labelText: "사용내역"),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           )),
//                           SizedBox(
//                             height: 50,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 SizedBox(
//                                   width: 80,
//                                   child: ElevatedButton(
//                                       onPressed: () {
//                                         categoryController.dispose();
//                                         amountController.dispose();
//                                         detailController.dispose();
//                                         Get.back();
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                           padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                                       child: const Text("닫기")),
//                                 ),
//                                 SizedBox(
//                                   width: 80,
//                                   child: ElevatedButton(
//                                       onPressed: () {
//                                         AmountModel newAmount = AmountModel();
//                                         newAmount.id = amount.id;
//                                         newAmount.amount = int.tryParse(amountController.text);
//                                         newAmount.category = categoryController.text == "환전" ? 0 : 2;
//                                         newAmount.title = detailController.text;
//                                         newAmount.type = amount.type;
//                                         newAmount.usageTime = amount.usageTime;
//
//                                         if (newAmount.title == amount.title &&
//                                             newAmount.amount == amount.amount &&
//                                             newAmount.category == amount.category) {
//                                           Get.snackbar("수정 내용을 확인해 주세요", "변경 사항이 존재하지 않아 수정 할 수 없습니다.",
//                                               colorText: Theme.of(context).colorScheme.onSurface,
//                                               backgroundColor: Theme.of(context).colorScheme.surface);
//                                           return;
//                                         }
//
//                                         context.read<AccountProvider>().editeAmountItem(fIdx, sInd, newAmount, widget.plan.id!);
//
//                                         // categoryController.dispose();
//                                         // amountController.dispose();
//                                         // detailController.dispose();
//
//                                         Get.back();
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                           padding: EdgeInsets.zero,
//                                           backgroundColor: Colors.black87,
//                                           side: BorderSide(color: Theme.of(context).colorScheme.secondary),
//                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                                       child: const Text(
//                                         "수정",
//                                         style: TextStyle(color: Colors.white),
//                                       )),
//                                 ),
//                                 SizedBox(
//                                   width: 80,
//                                   child: ElevatedButton(
//                                       onPressed: () {
//                                         context.read<AccountProvider>().removeAmountItem(fIdx, sInd, widget.plan.id!);
//                                         categoryController.dispose();
//                                         amountController.dispose();
//                                         detailController.dispose();
//                                         Get.back();
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                           padding: EdgeInsets.zero,
//                                           backgroundColor: Theme.of(context).colorScheme.secondary,
//                                           side: BorderSide(color: Theme.of(context).colorScheme.secondary),
//                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//                                       child: Text(
//                                         "삭제",
//                                         style: TextStyle(color: Theme.of(context).colorScheme.surface),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       )),
//                 ],
//               )),
//         );
//       });
// }
}
