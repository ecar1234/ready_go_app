import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';
import 'package:ready_go_project/domain/entities/provider/expectation_provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:ready_go_project/util/intl_utils.dart';

import '../../domain/entities/provider/admob_provider.dart';
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

  int _chartIdx = -1;

  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

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
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(kReleaseMode){
        final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
        if(!isRemove){
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
        title: const Text("예상 경비"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height - bannerHei - 20,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.45,
                      // color: Colors.deepPurpleAccent,
                      child: _expectationChart(context, isDarkMode, height),
                    ),
                    Container(
                      height: (height * 0.55) - bannerHei - 20,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Column(
                        children: [
                          // 내용 입력
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 120,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _expectationDialog(context, wid, isDarkMode, null, null);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white
                                    ),
                                    child: Text("계획 추가", style: TextStyle(color: isDarkMode? Colors.white : Theme.of(context).colorScheme.primary ),)),
                              ),
                              SizedBox(
                                width: 180,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "예상 금액 : ",
                                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                                    ),
                                    Selector<ExpectationProvider, List<ExpectationModel>>(
                                      selector: (context, expectation) => expectation.expectationList!,
                                      builder:(context, list, child) {
                                          return Text(
                                            IntlUtils.stringIntAddComma(StatisticsUtil.getExpectationTotal(list)),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                          );
                                        })
                                  ],
                                ),
                              )
                            ],
                          ),
                          const Gap(10),
                          // const Gap(5),
                          Expanded(
                            child: Selector<ExpectationProvider, List<ExpectationModel>>(
                              selector: (context, expectation) => expectation.expectationList!,
                              builder:(context, list, child) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: isDarkMode ? Colors.white : Colors.black87), borderRadius: BorderRadius.circular(10)),
                                  child: list.isEmpty
                                      ? Center(
                                          child: Text(
                                            "리스트를 추가해 주세요.",
                                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                                          ),
                                        )
                                      : Scrollbar(
                                          child: ListView.separated(
                                              itemBuilder: (context, idx) {
                                                int total = list.fold(0, (prev, ele) => prev + ele.amount!);
                                                return SizedBox(
                                                  height: 60,
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: (wid - 60) * 0.5,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              list[idx].title!,
                                                              style: TextStyle(
                                                                  color: isDarkMode ? Colors.white : Colors.black87,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 14),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                            Text(
                                                              IntlUtils.stringIntAddComma(list[idx].amount!),
                                                              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(child: Text("${((list[idx].amount! / total) * 100).toStringAsFixed(1)}%")),
                                                      SizedBox(
                                                          width: 30,
                                                          child: PopupMenuButton(
                                                            iconColor: isDarkMode ? Colors.white : Colors.black87,
                                                            padding: EdgeInsets.zero,
                                                            color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                                            itemBuilder: (context) => const [
                                                              PopupMenuItem(value: 0, child: Text("수정")),
                                                              PopupMenuItem(value: 1, child: Text("삭제")),
                                                            ],
                                                            onSelected: (value) {
                                                              if (value == 0) {
                                                                ExpectationModel item = list[idx];
                                                                _expectationDialog(context, wid, isDarkMode, item, idx);
                                                              } else if (value == 1) {
                                                                context.read<ExpectationProvider>().removeExpectationData(idx, widget.planId!);
                                                              }
                                                            },
                                                          ))
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
                  ],
                ),
              ),
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

  Widget _expectationChart(BuildContext context, bool isDarkMode, double hei) {
    return Selector<ExpectationProvider, List<ExpectationModel>>(
      selector: (context, expectation) => expectation.expectationList!,
          builder: (context, list, child){
            return list.isEmpty
                ? SizedBox(
                height: hei * 0.45,
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: Center(
                  child: Text(
                    "✨예상 경비를 미리 준비해 보세요",
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ))
              : PieChart(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          _chartIdx = -1;
                          return;
                        }
                        _chartIdx = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 5,
                  centerSpaceRadius: 40,
                  sections: _planAmountChartSection(context, list, isDarkMode),
                ));
          });
  }

  List<PieChartSectionData> _planAmountChartSection(BuildContext context, List<ExpectationModel> list, bool isDarkMode) {
    final mergeList = mergeByType(list);
    // logger.d(mergeList);
    return List.generate(mergeList.length, (idx) {
      final isTouched = idx == _chartIdx;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final widgetSize = isTouched ? 65.0 : 10.0;
      final offset = isTouched ? 1.4 : 1.0;

      final color = chartColors[idx % chartColors.length];
      final title = StatisticsUtil.conversionMethodTypeToString(mergeList[idx].type ?? MethodType.ect);
      final value = double.tryParse(StatisticsUtil.getExpectationTotalAccount(mergeList, idx));
      return PieChartSectionData(
          title: value! > 5.0 ? title : "",
          value: value,
          color: color,
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
                    color: color,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white),
              child: Center(
                child: Text(
                  "${StatisticsUtil.getExpectationTotalAccount(mergeList, idx)}%",
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

  void _expectationDialog(BuildContext context, double wid, bool isDarkMode, ExpectationModel? cur, int? idx) {
    if (cur != null) {
      _amountController.text = cur.amount!.toString();
      _titleController.text = cur.title!;
      if (cur.type == null) {
        _methodController.text = '기타';
      } else {
        _methodController.text = StatisticsUtil.conversionMethodTypeToString(cur.type!);
      }
    }
    showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                height: 240,
                width: wid,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: _titleController,
                        maxLength: 10,
                        maxLines: 1,
                        decoration: const InputDecoration(counterText: '', labelText: "상세 내용"),
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      height: 60,
                      width: wid,
                      child: Row(
                        children: [
                          // method menu
                          SizedBox(
                            height: 60,
                            child: DropdownMenu(
                              dropdownMenuEntries: List.generate(MethodType.values.length + 1, (idx) {
                                if (idx == 0) {
                                  return const DropdownMenuEntry(value: "선택", label: "선택");
                                }
                                String value = "";
                                value = StatisticsUtil.conversionMethodTypeToString(MethodType.values[idx - 1]);
                                return DropdownMenuEntry(value: value, label: value);
                              }),
                              width: 100,
                              controller: _methodController,
                              menuHeight: 300,
                              initialSelection: cur != null ? _methodController.text : "선택",
                              menuStyle: MenuStyle(
                                  backgroundColor: WidgetStatePropertyAll<Color>(isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white)),
                            ),
                          ),
                          const Gap(10),
                          // subject
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: TextField(
                                controller: _amountController,
                                decoration: const InputDecoration(counterText: "", labelText: "예상 금액"),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          const Gap(5),
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
                            width: 80,
                            child: ElevatedButton(
                              onPressed: () {
                                _methodController.text = "선택";
                                _titleController.clear();
                                _amountController.clear();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                "닫기",
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const Gap(20),
                          SizedBox(
                            width: 80,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_methodController.text == "선택" || _titleController.text.isEmpty || _amountController.text.isEmpty) {
                                  Get.snackbar(
                                    "정보 확인",
                                    "빈 값은 입력 할 수 없습니다.",
                                    backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                  );
                                  return;
                                }
                                if (cur != null) {
                                  if (_methodController.text == StatisticsUtil.conversionMethodTypeToString(cur.type ?? MethodType.ect) &&
                                      _titleController.text == cur.title! &&
                                      _amountController.text == cur.amount!.toString()) {
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
                                  ..amount = int.tryParse(_amountController.text)
                                  ..type = StatisticsUtil.conversionStringToMethodType(_methodController.text);

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
                                cur == null ? "추가" : "수정",
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
              ),
            ));
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
