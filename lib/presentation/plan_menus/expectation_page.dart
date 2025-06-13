// import 'package:expandable_page_view/expandable_page_view.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';
import 'package:ready_go_project/domain/entities/provider/expectation_provider.dart';
import 'package:ready_go_project/domain/entities/provider/plan_list_provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:ready_go_project/util/intl_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ready_go_project/util/localizations_util.dart';

import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../util/admob_util.dart';
import '../../util/statistics_util.dart';

class ExpectationPage extends StatefulWidget {
  final int? planId;

  const ExpectationPage({super.key, required this.planId});

  @override
  State<ExpectationPage> createState() => _ExpectationPageState();
}

class _ExpectationPageState extends State<ExpectationPage> {
  final logger = Logger();
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;

  // int _chartIdx = -1;

  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // final PageController _expandController = PageController(initialPage: 0);

  final List<Color> chartColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

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
    _admobUtil.dispose();
    _methodController.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final list = context.watch<ExpectationProvider>().expectationList!;
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final wid = MediaQuery.sizeOf(context).width;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height : 0;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.expensePlanTitle),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _page1(context, height, bannerHei, wid, isDarkMode),
              // ExpandablePageView(
              //     controller: _expandController,
              //     physics: const BouncingScrollPhysics(),
              //     children: [_page1(context, height, bannerHei, wid, isDarkMode), _page2(context, height, bannerHei, wid, isDarkMode)]),
              if (_isLoaded && _admobUtil.bannerAd != null)
                SizedBox(
                  height: _admobUtil.bannerAd!.size.height.toDouble(),
                  width: _admobUtil.bannerAd!.size.width.toDouble(),
                  child: _admobUtil.getBannerAdWidget(),
                )
            ],
          ),
        ),
      ),
    ));
  }

  Widget _page1(BuildContext context, double height, int bannerHei, double wid, bool isDarkMode) {
    final plan = context.read<PlanListProvider>().planList.firstWhere((item) => item.id == widget.planId);
    final isNationKor = plan.nation == "대한민국";
    final isKor = Localizations.localeOf(context).languageCode == "ko";
    return SizedBox(
      height: height - bannerHei - 20,
      child: Column(
        children: [
          Container(
            height: (height - bannerHei - 20) * 0.9,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                // 내용 입력
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () {
                              _expectationDialog(context, wid, isDarkMode, null, null);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                            child: Text(
                              AppLocalizations.of(context)!.add,
                              style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                            )),
                      ),
                      // SizedBox(
                      //   height: 50,
                      //   width: 120,
                      //   child: ElevatedButton.icon(
                      //       onPressed: () {
                      //         _expandController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      //       },
                      //       style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                      //       label: Text(
                      //         "통계보기",
                      //         style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                      //       ),
                      //     icon: const Icon(Icons.pie_chart),
                      //     // iconAlignment: IconAlignment.end,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const Gap(10),
                // 예상 경비 리스트
                Expanded(
                  child: Selector<ExpectationProvider, List<ExpectationModel>>(
                    selector: (context, expectation) => expectation.expectationList!,
                    builder: (context, list, child) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: isDarkMode ? Colors.white : Colors.black87), borderRadius: BorderRadius.circular(10)),
                        child: list.isEmpty
                            ? Center(
                                child: Text(
                                  "✨${AppLocalizations.of(context)!.expensePlanDesc}",
                                  style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Colors.black87),
                                ),
                              )
                            : Scrollbar(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, idx) {
                                      // int total = list.fold(0, (prev, ele) => prev + ele.amount!);
                                      return SizedBox(
                                        height: 60,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 6,
                                              child: SizedBox(
                                                width: (wid - 60) * 0.6,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      list[idx].title!,
                                                      style: LocalizationsUtil.setTextStyle(isKor,
                                                          color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, size: 18),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const Gap(4),
                                                    Text(
                                                      "${IntlUtils.stringIntAddComma(list[idx].amount ?? 0)} ${list[idx].unit}",
                                                      style: LocalizationsUtil.setTextStyle(isKor,
                                                          size: 16,
                                                          color: list[idx].unit != plan.unit ? Theme.of(context).colorScheme.primary : Colors.green,
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: Container(
                                                width: (wid - 60) * 0.2,
                                                height: 50,
                                                padding: const EdgeInsets.all(2),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                  color: StatisticsUtil.getCardColor(list[idx].type!),
                                                  child: Center(
                                                    child: Text(
                                                      StatisticsUtil.conversionMethodTypeToString(
                                                          Localizations.localeOf(context).languageCode, list[idx].type!),
                                                      overflow: TextOverflow.ellipsis,
                                                      style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Flexible(
                                            //     flex: 1,
                                            //     child: SizedBox(
                                            //       width: (wid - 60) * 0.1,
                                            //     )),
                                            Flexible(
                                              flex: 2,
                                              child: SizedBox(
                                                  width: (wid - 60) * 0.2,
                                                  child: PopupMenuButton(
                                                    iconColor: isDarkMode ? Colors.white : Colors.black87,
                                                    padding: EdgeInsets.zero,
                                                    color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(value: 0, child: Text(AppLocalizations.of(context)!.modify)),
                                                      PopupMenuItem(value: 1, child: Text(AppLocalizations.of(context)!.delete)),
                                                    ],
                                                    onSelected: (value) {
                                                      if (value == 0) {
                                                        ExpectationModel item = list[idx];
                                                        _expectationDialog(context, wid, isDarkMode, item, idx);
                                                      } else if (value == 1) {
                                                        context.read<ExpectationProvider>().removeExpectationData(idx, widget.planId!);
                                                      }
                                                    },
                                                  )),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, idx) => const Gap(10),
                                    itemCount: list.length),
                              ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          // 하단 total 정보
          Container(
            height: 60,
            width: wid,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              // decoration: BoxDecoration(border: Border.all()),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: isNationKor ? wid - 40 : (wid - 40) / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.ownCurrency,
                            style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
                          ),
                          Selector<ExpectationProvider, List<ExpectationModel>>(
                            selector: (context, expectation) {
                              final ownList = expectation.expectationList!.where((item) {
                                if(isKor){
                                  return item.unit == "₩";
                                }else if(Localizations.localeOf(context).languageCode == "ja"){
                                  return item.unit == "¥";
                                }
                                else {
                                  return item.unit == "\$";
                                }
                              }).toList();
                              return ownList;
                            },
                            builder: (context, list, child) {
                              int totalAmount = 0;
                              for (var item in list) {
                                totalAmount += item.amount!;
                              }
                              // print(totalAmount);
                              if (list.isNotEmpty) {
                                return Text(
                                  "${IntlUtils.stringIntAddComma(totalAmount)} ${list[0].unit}",
                                  style: TextStyle(
                                      color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                );
                              } else {
                                return Text(
                                  isNationKor && isKor ? "0 ₩" :
                                  (Localizations.localeOf(context).languageCode == "ja" ? "0 ¥" : "0 \$"),
                                  style: TextStyle(
                                      color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  if (!isNationKor)
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: (wid - 40) / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.foreignCurrency,
                              style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
                            ),
                            Selector<ExpectationProvider, List<ExpectationModel>>(
                              selector: (context, expectation) {
                                final foreignList = expectation.expectationList!.where((item) {
                                  if(isKor){
                                    return item.unit != "₩";
                                  }else if(Localizations.localeOf(context).languageCode == "ja"){
                                    return item.unit != "¥";
                                  }else {
                                    return item.unit != "\$";
                                }
                                }).toList();
                                return foreignList;
                              },
                              builder: (context, list, child) {
                                int totalAmount = 0;
                                for (var item in list) {
                                  totalAmount += item.amount!;
                                }
                                if (list.isNotEmpty) {
                                  return RichText(
                                    text: TextSpan(
                                        text: IntlUtils.stringIntAddComma(totalAmount),
                                        style: const TextStyle(fontFamily: "Nanum", color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
                                        children: [
                                          TextSpan(
                                            text: " ${list[0].unit}",
                                            style: GoogleFonts.notoSans(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
                                          )
                                        ]),
                                  );
                                } else {
                                  return RichText(
                                    text: TextSpan(
                                        text: "0",
                                        style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
                                        children: [
                                          TextSpan(
                                            text: " ${plan.unit}",
                                            style: GoogleFonts.notoSans(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
                                          )
                                        ]),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Widget _page2(BuildContext context, double height, int bannerHei, double wid, bool isDarkMode) {
  //   return SizedBox(
  //     height: height - bannerHei - 20,
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: height * 0.45,
  //           // color: Colors.deepPurpleAccent,
  //           child: _expectationChart(context, isDarkMode, height),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _expectationChart(BuildContext context, bool isDarkMode, double hei) {
  //   return Selector<ExpectationProvider, List<ExpectationModel>>(
  //       selector: (context, expectation) => expectation.expectationList!,
  //       builder: (context, list, child) {
  //         return list.isEmpty
  //             ? SizedBox(
  //                 height: hei * 0.45,
  //                 width: MediaQuery.sizeOf(context).width * 0.7,
  //                 child: Center(
  //                   child: Text(
  //                     "✨예상 경비를 미리 계획해 보세요",
  //                     style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
  //                   ),
  //                 ))
  //             : PieChart(
  //                 duration: const Duration(milliseconds: 600),
  //                 curve: Curves.easeOut,
  //                 PieChartData(
  //                   pieTouchData: PieTouchData(
  //                     touchCallback: (FlTouchEvent event, pieTouchResponse) {
  //                       setState(() {
  //                         if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
  //                           _chartIdx = -1;
  //                           return;
  //                         }
  //                         _chartIdx = pieTouchResponse.touchedSection!.touchedSectionIndex;
  //                       });
  //                     },
  //                   ),
  //                   borderData: FlBorderData(
  //                     show: false,
  //                   ),
  //                   sectionsSpace: 5,
  //                   centerSpaceRadius: 40,
  //                   sections: _planAmountChartSection(context, list, isDarkMode),
  //                 ));
  //       });
  // }

  // List<PieChartSectionData> _planAmountChartSection(BuildContext context, List<ExpectationModel> list, bool isDarkMode) {
  //   final mergeList = mergeByType(list);
  //   // logger.d(mergeList);
  //   return List.generate(mergeList.length, (idx) {
  //     final isTouched = idx == _chartIdx;
  //     final fontSize = isTouched ? 20.0 : 16.0;
  //     final radius = isTouched ? 70.0 : 60.0;
  //     final widgetSize = isTouched ? 65.0 : 10.0;
  //     final offset = isTouched ? 1.4 : 1.0;
  //
  //     final color = chartColors[idx % chartColors.length];
  //     final title = StatisticsUtil.conversionMethodTypeToString(mergeList[idx].type ?? MethodType.ect);
  //     final value = double.tryParse(StatisticsUtil.getExpectationTotalAccount(mergeList, idx));
  //     return PieChartSectionData(
  //         title: value! > 5.0 ? title : "",
  //         value: value,
  //         color: color,
  //         titleStyle: TextStyle(
  //           fontSize: fontSize,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //         ),
  //         badgeWidget: AnimatedContainer(
  //             duration: const Duration(milliseconds: 300),
  //             width: widgetSize,
  //             height: widgetSize,
  //             padding: const EdgeInsets.all(5),
  //             decoration: BoxDecoration(
  //                 border: Border.all(
  //                   width: 2,
  //                   color: color,
  //                 ),
  //                 shape: BoxShape.circle,
  //                 color: Colors.white),
  //             child: Center(
  //               child: Text(
  //                 "${StatisticsUtil.getExpectationTotalAccount(mergeList, idx)}%",
  //                 maxLines: 1,
  //                 style: TextStyle(
  //                   overflow: TextOverflow.ellipsis,
  //                   color: isDarkMode ? Colors.white : Colors.black87,
  //                 ),
  //               ),
  //             )),
  //         badgePositionPercentageOffset: offset,
  //         radius: radius);
  //   });
  // }

  void _expectationDialog(BuildContext context, double wid, bool isDarkMode, ExpectationModel? cur, int? idx) {
    final plan = context.read<PlanListProvider>().planList.firstWhere((item) => item.id == widget.planId);
    final isNationKor = plan.nation == "대한민국";
    final isKor = Localizations.localeOf(context).languageCode == "ko";

    if (cur != null) {
      _amountController.text = cur.amount!.toString();
      _titleController.text = cur.title!;
      _currencyController.text = cur.unit ?? "-";
      if (cur.type == null) {
        _methodController.text = AppLocalizations.of(context)!.others;
      } else {
        _methodController.text = StatisticsUtil.conversionMethodTypeToString(Localizations.localeOf(context).languageCode, cur.type!);
      }
    }
    showDialog(
        context: context,
        builder: (context) {
          final currency = context.read<PlanListProvider>().planList.firstWhere((item) => item.id == widget.planId).unit;
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Dialog(
                insetPadding: const EdgeInsets.all(20),
                child: Container(
                  height: 240,
                  width: wid,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          // method menu
                          SizedBox(
                            height: 60,
                            child: DropdownMenu(
                              dropdownMenuEntries: List.generate(MethodType.values.length + 1, (idx) {
                                if (idx == 0) {
                                  return DropdownMenuEntry(value: AppLocalizations.of(context)!.select, label: AppLocalizations.of(context)!.select);
                                }
                                String value = "";
                                value = StatisticsUtil.conversionMethodTypeToString(
                                    Localizations.localeOf(context).languageCode, MethodType.values[idx - 1]);
                                return DropdownMenuEntry(value: value, label: value);
                              }),
                              width: 100,
                              controller: _methodController,
                              menuHeight: 300,
                              initialSelection: cur != null ? _methodController.text : AppLocalizations.of(context)!.select,
                              menuStyle: MenuStyle(
                                  backgroundColor: WidgetStatePropertyAll<Color>(isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white)),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: TextField(
                                controller: _titleController,
                                maxLength: 40,
                                maxLines: 1,
                                decoration: InputDecoration(counterText: '', labelText: AppLocalizations.of(context)!.details),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      SizedBox(
                        height: 60,
                        width: wid,
                        child: Row(
                          children: [
                            // subject
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: TextField(
                                  controller: _amountController,
                                  decoration: InputDecoration(counterText: "", labelText: AppLocalizations.of(context)!.amount),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.end,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _amountController.text = IntlUtils.stringIntAddComma(int.parse(value));
                                    }
                                  },
                                ),
                              ),
                            ),
                            const Gap(10),
                            // currency unit
                            SizedBox(
                              height: 60,
                              child: DropdownMenu(
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(
                                      value: "₩",
                                      label: isKor && isNationKor
                                          ? "₩"
                                          : Localizations.localeOf(context).languageCode == "ja"
                                              ? "¥"
                                              : "\$"),
                                  DropdownMenuEntry(value: "$currency", label: "$currency")
                                ],
                                width: 100,
                                controller: _currencyController,
                                // menuHeight: 300,
                                initialSelection: "₩",
                                menuStyle: MenuStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _methodController.text = AppLocalizations.of(context)!.select;
                                  _titleController.clear();
                                  _amountController.clear();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(AppLocalizations.of(context)!.close,
                                    style: LocalizationsUtil.setTextStyle(isKor,
                                        color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary)),
                              ),
                            ),
                            const Gap(20),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_methodController.text == AppLocalizations.of(context)!.select ||
                                      _titleController.text.isEmpty ||
                                      _amountController.text.isEmpty) {
                                    Get.snackbar(
                                      "정보 확인",
                                      "빈 값은 입력 할 수 없습니다.",
                                      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                    );
                                    return;
                                  }
                                  if (cur != null) {
                                    if (_methodController.text ==
                                            StatisticsUtil.conversionMethodTypeToString(
                                                Localizations.localeOf(context).languageCode, cur.type ?? MethodType.ect) &&
                                        _titleController.text == cur.title! &&
                                        _amountController.text == cur.amount!.toString() &&
                                        _currencyController.text == cur.unit) {
                                      Get.snackbar(
                                        "정보 확인",
                                        "변경 된 데이터가 없습니다",
                                        backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                      );
                                      return;
                                    }
                                  }
                                  ExpectationModel item = ExpectationModel()
                                    ..title = _titleController.text
                                    ..amount = IntlUtils.removeComma(_amountController.text)
                                    ..type = StatisticsUtil.conversionStringToMethodType(
                                        Localizations.localeOf(context).languageCode, _methodController.text)
                                    ..unit = _currencyController.text;

                                  // logger.d(item.type);
                                  if (cur != null) {
                                    context.read<ExpectationProvider>().modifyExpectationData(item, idx!, widget.planId!);
                                  } else {
                                    context.read<ExpectationProvider>().addExpectationData(item, widget.planId!);
                                  }
                                  _titleController.clear();
                                  _amountController.clear();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(
                                  cur == null ? AppLocalizations.of(context)!.add : AppLocalizations.of(context)!.modify,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  List<ExpectationModel> mergeByType(List<ExpectationModel> list) {
    Map<MethodType, ExpectationModel> mergedMap = {};
    List<ExpectationModel> resultList = [];

    for (var item in list) {
      if (mergedMap.containsKey(item.type)) {
        // 타입이 이미 존재하면 value를 더함
        mergedMap[item.type!] = ExpectationModel(
          title: mergedMap[item.type]!.title, // 기존 title 유지 (혹은 필요에 따라 변경)
          type: item.type,
          amount: mergedMap[item.type]!.amount! + item.amount!,
        );
      } else {
        // 타입이 처음 등장하면 Map에 추가
        mergedMap[item.type ?? MethodType.ect] = item;
      }
    }

    // Map의 value들을 새로운 List로 변환
    resultList.addAll(mergedMap.values);

    return resultList;
  }
}
