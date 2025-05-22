import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/domain/entities/provider/schedule_provider.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:ready_go_project/util/date_util.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/theme_mode_provider.dart';

class SchedulePage extends StatefulWidget {
  final PlanModel plan;

  const SchedulePage({super.key, required this.plan});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  final logger = Logger();
  int _selected = 0;

  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    final allScheduleList = context.watch<ScheduleProvider>().scheduleList ?? [];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("일정 관리"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height - bannerHei,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("여행 일정", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  // final editSchedule = allScheduleList[_selected].scheduleList.
                                  return Dialog(
                                    insetPadding: const EdgeInsets.all(20),
                                    child: Container(
                                      // height: 00,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "시간",
                                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                                              ),
                                              const Gap(8),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: DropdownMenu(
                                                        controller: _hourController,
                                                        menuHeight: 300,
                                                        initialSelection: 0,
                                                        dropdownMenuEntries:
                                                            List.generate(24, (idx) => DropdownMenuEntry(value: idx, label: idx == 0 ? "0" : "$idx"))),
                                                  ),
                                                  const Gap(8),
                                                  const Text("시"),
                                                  const Gap(16),
                                                  SizedBox(
                                                    width: 100,
                                                    child: DropdownMenu(
                                                        controller: _minController,
                                                        initialSelection: 0,
                                                        dropdownMenuEntries: List.generate(
                                                            6, (idx) => DropdownMenuEntry(value: idx, label: idx == 0 ? "00" : "${idx * 10}"))),
                                                  ),
                                                  const Gap(8),
                                                  const Text("분")
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Gap(20),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "여행 일정",
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                              ),
                                              const Gap(8),
                                              SizedBox(
                                                height: 50,
                                                child: TextField(
                                                  controller: _titleController,
                                                  maxLines: 1,
                                                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Gap(20),
                                          SizedBox(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  height: 50,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        _titleController.clear();
                                                        _hourController.clear();
                                                        _minController.clear();
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                      child: Text("닫기")),
                                                ),
                                                const Gap(20),
                                                SizedBox(
                                                  width: 100,
                                                  height: 50,
                                                  child: ElevatedButton(
                                                      onPressed: () {

                                                        if(_titleController.text.isEmpty){
                                                          Get.snackbar("일정 내용을 입력해 주세요.", "일정의 타이틀 없이 셍성 할 수 없습니다.");
                                                          return;
                                                        }

                                                        int scheduleNewId = 1;
                                                        if(allScheduleList.any((item) => item.id == _selected)){
                                                          var item = allScheduleList.firstWhere((item) => item.id == _selected);
                                                          if(item.scheduleList != null && item.scheduleList!.isNotEmpty){
                                                            scheduleNewId = item.scheduleList!.length;
                                                          }
                                                        }
                                                        ScheduleModel item = ScheduleModel()
                                                          ..id = scheduleNewId
                                                          ..time = "${_hourController.text}:${_minController.text}"
                                                          ..title = _titleController.text;
                                                        // logger.i("$item");
                                                        // logger.i("$_selected");
                                                        context.read<ScheduleProvider>().createSchedule(item, _selected, widget.plan.id!);
                                                        Navigator.pop(context);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                      child: Text("생성")),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Text("일정 추가"))
                    ],
                  ),
                ),
                const Gap(10),
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
                              _selected = idx;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: _selected == idx
                                    ? (isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).primaryColor)
                                    : (isDarkMode ? Theme.of(context).primaryColor : Colors.white),
                                border: Border.all(
                                    color: _selected == idx
                                        ? (isDarkMode ? Colors.transparent : Colors.white)
                                        : (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary)),
                                borderRadius: BorderRadius.circular(24)),
                            child: Text(
                              "${scheduleDay.month}월${scheduleDay.day}일 (${idx + 1}일차)",
                              style: TextStyle(
                                  color: _selected == idx ? Colors.white : (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                  fontWeight: _selected == idx ? FontWeight.w600 : FontWeight.w400),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, idx) => const Gap(8),
                      itemCount: DateUtil.datesDifference(widget.plan.schedule!) + 1,
                    )),
                const Gap(10),
                Expanded(
                  child: Container(
                      width: MediaQuery.sizeOf(context).width - 40,
                      decoration: BoxDecoration(border: Border.all()),
                      child: allScheduleList.isEmpty
                          ? SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("주요 일정과 세부 일정을 등록해보세요."),
                                  const Gap(24),
                                  Text("주요일정 등록 후"),
                                  Text("세부 일정을 등록 할 수 있어요."),
                                ],
                              ),
                            )
                          : allScheduleList.any((item) => item.id == _selected)
                              ? ListView.separated(
                                  itemBuilder: (context, idx) {
                                    final daySchedule = allScheduleList.firstWhere((item) => item.id == _selected).scheduleList!;
                                    final scheduleTime = daySchedule[idx].time!.split(":");
                                    return SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("${scheduleTime[0]}시 ${scheduleTime[1]}분"),
                                              const Gap(10),
                                              Text("${daySchedule[idx].title}")
                                            ],
                                          ),
                                          if (daySchedule[idx].details != null && daySchedule[idx].details!.isNotEmpty)
                                            ListView.separated(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, idx) {},
                                                separatorBuilder: (context, idx) => const Gap(4),
                                                itemCount: daySchedule[idx].details!.length)
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, idx) => const Gap(10),
                                  itemCount: allScheduleList.firstWhere((item) => item.id == _selected).scheduleList!.length)
                          : SizedBox(
                        child: Text("${_selected + 1}일차의 일정을 추가해 보세요"),
                      )
                  ),
                ),
                // admob
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
      ),
    );
  }
}
