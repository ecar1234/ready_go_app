import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/util/admob_util.dart';

import 'package:ready_go_project/util/date_util.dart';

import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/admob_provider.dart';
import '../domain/entities/provider/plan_list_provider.dart';

class AddPlanPage extends StatefulWidget {
  final PlanModel? plan;

  const AddPlanPage({super.key, this.plan});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  final logger = Logger();
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  TextEditingController nationController = TextEditingController();
  List<DateTime?> _dates = [];
  InterstitialAd? _interstitialAd;
  Timer? _debounce;

  _onChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (kDebugMode) {
        logger.d(value);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.plan != null) {
      nationController.text = widget.plan!.nation!;
      _dates = widget.plan!.schedule!;
    }
    if (mounted) {
      _interstitialAd = context.read<AdmobProvider>().interstitialAd;
      if (_interstitialAd != null) {
        _interstitialAd?.show();
      }
    }
    _admobUtil.loadBannerAd(onAdLoaded: () {
      setState(() {
        _isLoaded = true;
      });
    }, onAdFailed: () {
      setState(() {
        _isLoaded = false;
      });
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<AdmobProvider>().loadAdBanner();
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nationController.dispose();
    _debounce?.cancel();
    _admobUtil.dispose();
    // context.read<AdmobProvider>().interstitialAdDispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = context.read<PlanListProvider>().planList;
    final idNum = list.length;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                "여행 계획 추가",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            body: Container(
              // height: MediaQuery.sizeOf(context).height - 120,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
                                child: SizedBox(
                                  height: 630,
                                  width: constraints.maxWidth <= 600 ? MediaQuery.sizeOf(context).width : 600,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      _titleSection(),
                                      const Gap(20),
                                      Container(
                                          width: constraints.maxWidth <= 600 ? MediaQuery.sizeOf(context).width : 840,
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                                          child: _calendarSection()),
                                      const Gap(30),
                                      // create button
                                      SizedBox(
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 150,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (widget.plan != null) {
                                                    if (widget.plan!.nation! == nationController.text && widget.plan!.schedule! == _dates) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                        content: Text("변경 사항이 존재 하지 않습니다."),
                                                        duration: Duration(seconds: 1),
                                                      ));
                                                      return;
                                                    } else {}
                                                  } else {
                                                    if (nationController.text.isEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                        content: Text("여행 제목을 입력해 주세요."),
                                                        duration: Duration(seconds: 1),
                                                      ));
                                                      return;
                                                    }
                                                    if (_dates.length > 2 || _dates.isEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                        content: Text("일정을 선택해 주세요"),
                                                        duration: Duration(seconds: 1),
                                                      ));
                                                      return;
                                                    }
                                                  }
                                                  try {
                                                    PlanModel plan = PlanModel();
                                                    if (widget.plan != null) {
                                                      plan
                                                        ..id = widget.plan!.id
                                                        ..schedule = _dates
                                                        ..nation = nationController.text
                                                        ..favorites = widget.plan!.favorites;
                                                      context.read<PlanListProvider>().changePlan(plan);
                                                    } else {
                                                      plan
                                                        ..id = idNum + 1
                                                        ..nation = nationController.text
                                                        ..schedule = _dates
                                                        ..favorites = false;
                                                      context.read<PlanListProvider>().addPlanList(plan);
                                                    }
                                                  } catch (ex) {
                                                    throw (ex).toString();
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    // backgroundColor: Colors.black87,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                child: Text(
                                                  widget.plan != null ? "수정" : "생성",
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                    ],
                  ),
                  if (_isLoaded && _admobUtil.bannerAd != null)
                    SizedBox(
                      height: _admobUtil.bannerAd!.size.height.toDouble(),
                      width: _admobUtil.bannerAd!.size.width.toDouble(),
                      child: AdWidget(ad: _admobUtil.bannerAd!),
                    )
                ],
              ),
            )),
      ),
    );
  }

  Widget _titleSection() {
    return SizedBox(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "여행 제목",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const Gap(10),
          SizedBox(
            height: 50,
            child: TextField(
              controller: nationController,
              onChanged: _onChanged,
              decoration: const InputDecoration(
                  hintText: "국가명 or 친목여행 등..",
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87), borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.black87), borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          )
        ],
      ),
    );
  }

  Widget _calendarSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "일정",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Gap(10),
        SizedBox(
            height: 300,
            width: 500,
            child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  firstDate: DateTime.now(),
                  firstDayOfWeek: 0,
                  calendarType: CalendarDatePicker2Type.range,
                  weekdayLabels: ["일", "월", "화", "수", "목", "금", "토"],
                ),
                value: _dates,
                onValueChanged: (list) => setState(() {
                      _dates = list;
                    }))),
        SizedBox(
            height: 30,
            child: _dates.isNotEmpty
                ? Text(
                    "${DateUtil.dateToString(_dates.first ?? DateTime.now())} "
                    "~ ${DateUtil.dateToString(_dates.last ?? DateTime.now())}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                : const Text("일정 선택"))
      ],
    );
  }
}
