import 'dart:async';
import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/provider/admob_provider.dart';
import 'package:ready_go_project/util/date_util.dart';

import '../data/models/plan_model/plan_model.dart';
import '../provider/plan_list_provider.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({super.key});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  TextEditingController nationController = TextEditingController();
  List<DateTime?> _dates = [];

  Timer? _debounce;

  _onChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      log(value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nationController.dispose();
    _debounce?.cancel();
    // context.read<AdmobProvider>().bannerAdDispose();
  }

  @override
  Widget build(BuildContext context) {
    final int idNum = context.watch<PlanListProvider>().planList.length;
    context.read<AdmobProvider>().loadAdBanner();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              "여행 계획 추가",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height -100,
            child: Stack(
              children: [
                LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
                          child: Center(
                            child: Container(
                              // height: MediaQuery.sizeOf(context).height - 100,
                              width: constraints.maxWidth <= 600 ? MediaQuery.sizeOf(context).width : 600,
                              padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _titleSection(),
                                  const Gap(20),
                                  Container(
                                      width: constraints.maxWidth <= 600 ? MediaQuery.sizeOf(context).width : 840,
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: _calendarSection()),
                                  const Gap(30),
                                  // create button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (nationController.text.isEmpty) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                content: Text("국가명을 입력해 주세요."),
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
                                            try {
                                              PlanModel plan = PlanModel(id: idNum + 1, nation: nationController.text, schedule: _dates);
                                              context.read<PlanListProvider>().addPlanList(plan);
                                            } catch (ex) {
                                              throw (ex).toString();
                                            }
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              // backgroundColor: Colors.black87,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                          child: const Text(
                                            "생성",
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                Builder(builder: (context) {
                  final BannerAd? bannerAd = context.watch<AdmobProvider>().bannerAd;
                  if(bannerAd != null){
                    return Positioned(
                        left: 20,
                        bottom: 30,
                        child: SizedBox(
                          width: bannerAd.size.width.toDouble(),
                          height: bannerAd.size.height.toDouble(),
                          child: AdWidget(
                            ad: bannerAd,
                          ),
                        ));
                  }else {
                    log("banner is null on add plan page");
                    return const SizedBox();
                  }

                })
              ],
            ),
          )),
    );
  }

  Widget _titleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "여행 국가",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Gap(10),
        SizedBox(
          height: 50,
          child: TextField(
            controller: nationController,
            onChanged: _onChanged,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87), borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: Colors.black87), borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
        )
      ],
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
