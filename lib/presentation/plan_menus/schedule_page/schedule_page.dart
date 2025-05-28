import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/domain/entities/provider/schedule_provider.dart';
import 'package:ready_go_project/presentation/plan_menus/schedule_page/add_schedule_page.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:ready_go_project/util/date_util.dart';

import '../../../data/models/plan_model/plan_model.dart';
import '../../../domain/entities/provider/purchase_manager.dart';
import '../../../domain/entities/provider/theme_mode_provider.dart';

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

  bool isAfterCheckScheduleTime(List<String> timeList, DateTime startDay, int roundIdx) {
    DateTime today = DateTime.now();
    DateTime scheduleDay = DateTime(startDay.add(Duration(days: roundIdx)).year, startDay.add(Duration(days: roundIdx)).month,
        startDay.add(Duration(days: roundIdx)).day, int.parse(timeList[0]), int.parse(timeList[1]));
    return today.isAfter(scheduleDay);
  }

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
    _titleController.dispose();
    _minController.dispose();
    _hourController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    // final allScheduleList = context.watch<ScheduleProvider>().scheduleList ?? [];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("일정 관리"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // add buttons
                SizedBox(
                  height: height - bannerHei - 40,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width - 40,
                        child: ElevatedButton(
                            onPressed: () {
                              _scheduleDialog(context, null, _selected, isDarkMode);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Icon(
                                    size: 24,
                                    Icons.edit_calendar,
                                    color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  "주요 일정 추가",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                ),
                                SizedBox(
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const Gap(20),
                      // schedule index
                      _scheduleIndex(context, isDarkMode),
                      const Gap(10),
                      // schedule data for days
                      _scheduleDataForDays(context, isDarkMode),
                    ],
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

  Widget _scheduleIndex(BuildContext context, bool isDarkMode) {
    return SizedBox(
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
        ));
  }

  Widget _scheduleDataForDays(BuildContext context, bool isDarkMode) {
    return Expanded(
      child: Selector<ScheduleProvider, List<ScheduleListModel>>(
          selector: (context, schedule) => schedule.scheduleList ?? [],
          builder: (context, allSchedule, child) {
            if (allSchedule[_selected].scheduleList!.isEmpty) {
              return const SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "주요 일정을 등록해보세요.",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const Gap(24),
                    Text("주요일정 등록 후"),
                    Text("세부 일정을 등록 할 수 있어요."),
                  ],
                ),
              );
            }
            return SizedBox(
                width: MediaQuery.sizeOf(context).width - 40,
                // decoration: BoxDecoration(border: Border.all()),
                child: ListView.separated(
                    itemBuilder: (context, idx) {
                      final daySchedule = allSchedule[_selected].scheduleList;
                      final stringTimeList = daySchedule![idx].time!.split(":");
                      Widget conversionTime = const SizedBox();
                      if (int.parse(stringTimeList[0]) > 12) {
                        conversionTime = RichText(
                            text: TextSpan(
                                text: "PM",
                                style: TextStyle(
                                    color: isDarkMode ? Theme.of(context).colorScheme.secondary : Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                                children: [
                              TextSpan(
                                  text: " ${int.parse(stringTimeList[0]) - 12}:${stringTimeList[1]}",
                                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 18))
                            ]));
                      } else {
                        conversionTime = RichText(
                            text: TextSpan(
                                text: "AM",
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 18),
                                children: [
                              TextSpan(
                                  text: " ${stringTimeList[0]}:${stringTimeList[1]}",
                                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 18))
                            ]));
                      }
                      return Container(
                        padding: daySchedule[idx].details != null && daySchedule[idx].details!.isNotEmpty
                            ? const EdgeInsets.only(bottom: 8) : null,
                        decoration: BoxDecoration(
                          color: isDarkMode? Theme.of(context).colorScheme.primary: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[200]!, // 좀 더 연한 그림자 색상
                              spreadRadius: 0.5, // 미세한 확산
                              blurRadius: 0.5,    // 매우 흐릿하게 (상단으로 갈수록 퍼지면서 사라짐)
                              offset: Offset(0, 2), // 그림자의 시작점을 하단에서 조금 더 아래로
                            ),
                            // 하단 그림자를 좀 더 명확하게 표현하기 위한 추가 그림자 (선택 사항)
                            BoxShadow(
                              color: Colors.grey[200]!, // 더 진한 부분
                              spreadRadius: 0.4, // 아주 조금만 퍼짐
                              blurRadius: 0.1,   // 덜 흐릿하게
                              offset: Offset(0, 1), // 하단에 가깝게
                            ),
                          ]
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // time
                                Flexible(
                                  flex: 3,
                                  child: SizedBox(
                                    width: (MediaQuery.sizeOf(context).width - 40) * 0.3,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isAfterCheckScheduleTime(stringTimeList, widget.plan.schedule![0]!, _selected)
                                                  ? Colors.redAccent
                                                  : Colors.blue),
                                        ),
                                        const Gap(10),
                                        conversionTime
                                      ],
                                    ),
                                  ),
                                ),
                                // title
                                Flexible(
                                    flex: 5,
                                    child: SizedBox(
                                        width: (MediaQuery.sizeOf(context).width - 40) * 0.5,
                                        child: Text(
                                          "${daySchedule[idx].title}",
                                          style: const TextStyle(overflow: TextOverflow.ellipsis),
                                        ))),
                                // button menus
                                Flexible(
                                    flex: 2,
                                    child: SizedBox(
                                      width: (MediaQuery.sizeOf(context).width - 40) * 0.5,
                                      child: PopupMenuButton(
                                          color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: "edit",
                                                  child: const Text("일정 수정"),
                                                  onTap: () {
                                                    _scheduleDialog(context, daySchedule[idx], _selected, isDarkMode);
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  value: "add",
                                                  child: const Text("세부 정보 추가"),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddSchedulePage(
                                                                  daySchedule: daySchedule[idx],
                                                                  roundIdx: _selected,
                                                                  scheduleIdx: idx,
                                                                  planId: widget.plan.id!,
                                                                )));
                                                  },
                                                ),
                                                PopupMenuItem(
                                                  value: "remove",
                                                  child: const Text("삭제"),
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                              title: const Text("일정을 삭제 합니다."),
                                                              actions: [
                                                                SizedBox(
                                                                  child: ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: const Text("취소")),
                                                                ),
                                                                SizedBox(
                                                                  child: ElevatedButton(
                                                                      onPressed: () {
                                                                        context
                                                                            .read<ScheduleProvider>()
                                                                            .removeSchedule(_selected, idx, widget.plan.id!);
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: const Text("삭제")),
                                                                ),
                                                              ],
                                                            ));
                                                  },
                                                ),
                                              ]),
                                    ))
                              ],
                            ),
                            if (daySchedule[idx].details != null && daySchedule[idx].details!.isNotEmpty)
                              SizedBox(
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 3,
                                        child: SizedBox(
                                          width: (MediaQuery.sizeOf(context).width - 40) * 0.3,
                                          height: daySchedule[idx].details!.length * 20,
                                          // decoration:
                                          //     BoxDecoration(border: Border(left: BorderSide(color: isDarkMode ? Colors.white : Colors.black87))),
                                        )),
                                    Flexible(
                                      flex: 7,
                                      child: SizedBox(
                                        width: (MediaQuery.sizeOf(context).width - 40) * 0.7,
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, detailIdx) {
                                              return SizedBox(
                                                  height: 20,
                                                  width: (MediaQuery.sizeOf(context).width - 40) * 0.7,
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 7,
                                                        child: SizedBox(
                                                            width: ((MediaQuery.sizeOf(context).width - 40) * 0.7) * 0.7,
                                                            child: Text(daySchedule[idx].details![detailIdx], style: const TextStyle(overflow: TextOverflow.ellipsis),)),
                                                      ),
                                                      Flexible(
                                                        flex: 3,
                                                        child: SizedBox(
                                                            height: 20,
                                                            width: ((MediaQuery.sizeOf(context).width - 40) * 0.7) * 0.3,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                context
                                                                    .read<ScheduleProvider>()
                                                                    .removeScheduleDetail(_selected, idx, detailIdx, widget.plan.id!);
                                                              },
                                                              child: const Icon(
                                                                Icons.remove_circle,
                                                                color: Colors.redAccent,
                                                                size: 20,
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ));
                                            },
                                            separatorBuilder: (context, idx) => const Gap(4),
                                            itemCount: daySchedule[idx].details!.length),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, idx) => const Gap(10),
                    itemCount: allSchedule[_selected].scheduleList!.length));
          }),
    );
  }

  Future<void> _scheduleDialog(BuildContext context, ScheduleModel? schedule, int roundIdx, bool isDarkMode) async {
    showDialog(
        context: context,
        builder: (context) {
          if (schedule != null) {
            _titleController.text = schedule.title!;
            _hourController.text = schedule.time!.split(":")[0];
            _minController.text = schedule.time!.split(":")[1];
          }
          ScheduleListModel dayScheduleList = context.read<ScheduleProvider>().scheduleList![roundIdx];

          return Dialog(
            insetPadding: const EdgeInsets.all(20),
            // backgroundColor: isDarkMode ? const Color(0xffADD8E6) : Colors.white,
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
                                initialSelection: schedule != null ? int.parse(schedule.time!.split(":")[0]) : 0,
                                dropdownMenuEntries: List.generate(24, (idx) => DropdownMenuEntry(value: idx, label: idx == 0 ? "0" : "$idx"))),
                          ),
                          const Gap(8),
                          const Text("시"),
                          const Gap(16),
                          SizedBox(
                            width: 100,
                            child: DropdownMenu(
                                controller: _minController,
                                initialSelection: schedule != null ?
                                (schedule.time!.split(":")[1] == "00" ? 0 : int.parse(schedule.time!.split(":")[1]) / 10) : 0,
                                dropdownMenuEntries:
                                    List.generate(6, (idx) => DropdownMenuEntry(value: idx, label: idx == 0 ? "00" : "${idx * 10}"))),
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
                                  backgroundColor: isDarkMode ? Theme.of(context).primaryColor : Colors.white,
                                  side: isDarkMode ? const BorderSide(color: Colors.white) : null,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                "닫기",
                                style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                              )),
                        ),
                        const Gap(20),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_titleController.text.isEmpty) {
                                  Get.snackbar("일정 내용을 입력해 주세요.", "일정의 타이틀 없이 셍성 할 수 없습니다.");
                                  return;
                                }

                                if (schedule == null &&
                                    dayScheduleList.scheduleList!.any((item) => item.time == "${_hourController.text}:${_minController.text}")) {
                                  Get.snackbar("일정의 시간을 확인해 주세요.", "선택한 시간에 일정이 존재 합니다.");
                                  return;
                                }

                                ScheduleModel item = ScheduleModel()
                                  ..title = _titleController.text
                                  ..time = "${_hourController.text}:${_minController.text}";
                                // logger.i("$item");
                                // logger.i("$_selected");
                                if (schedule == null) {
                                  context.read<ScheduleProvider>().createSchedule(item, _selected, widget.plan.id!);
                                } else {
                                  item.id = schedule.id;
                                  context.read<ScheduleProvider>().editSchedule(item, _selected, widget.plan.id!);
                                }
                                _titleController.clear();
                                _hourController.clear();
                                _minController.clear();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                schedule == null ? "생성" : "수정",
                                style: const TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
