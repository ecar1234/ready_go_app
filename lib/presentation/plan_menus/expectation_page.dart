import 'package:fl_chart/fl_chart.dart';
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
    _admobUtil.loadBannerAd(onAdLoaded: () {
      setState(() {
        _isLoaded = true;
      });
    }, onAdFailed: () {
      _isLoaded = false;
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
    final list = context.watch<ExpectationProvider>().expectationList!;

    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final wid = MediaQuery.sizeOf(context).width;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height : 0;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("예상 경비"),
      ),
      body: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: height - bannerHei - 20,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.4,
                    // color: Colors.deepPurpleAccent,
                    child: _expectationChart(context, list, isDarkMode),
                  ),
                  Container(
                    height: (height * 0.6) - bannerHei - 20,
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
                                  child: const Text("계획 추가")),
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
                                  Text(
                                    IntlUtils.stringIntAddComma(StatisticsUtil.getExpectationTotal(list)),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Gap(10),
                        // const Gap(5),
                        Expanded(
                          child: Container(
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
    ));
  }

  Widget _expectationChart(BuildContext context, List<ExpectationModel> list, bool isDarkMode) {
    return list.isEmpty
        ? const SizedBox(
            child: Center(
                child: Text(
              "여행 예상 비용이 아직 없습니다.",
              style: TextStyle(color: Colors.white),
            )),
          )
        : PieChart(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            PieChartData(
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 5,
              centerSpaceRadius: 40,
              sections: _planAmountChartSection(context, list, isDarkMode),
            ));
  }

  List<PieChartSectionData> _planAmountChartSection(BuildContext context, List<ExpectationModel> list, bool isDarkMode) {
    return List.generate(list.length, (idx) {
      final isTouched = idx == _chartIdx;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 70.0 : 60.0;
      final widgetSize = isTouched ? 55.0 : 10.0;
      final offset = isTouched ? 1.4 : 1.0;

      final color = chartColors[idx % chartColors.length];
      return PieChartSectionData(
          title: StatisticsUtil.conversionMethodTypeToString(list[idx].type ?? MethodType.ect),
          value: StatisticsUtil.getExpectationTotalAccount(list, idx),
          color: color,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                                  if (_methodController.text == StatisticsUtil.conversionMethodTypeToString(cur.type??MethodType.ect) &&
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
}
