import 'dart:async';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
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
      print(value);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nationController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
  final int idNum = context.watch<PlanListProvider>().planList.length;
    return GestureDetector(
      onTap: (){
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
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleSection(),
              const Gap(30),
              _calendarSection(),
              const Gap(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(onPressed: (){
                      if(nationController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("국가명을 입력해 주세요."), duration: Duration(seconds: 1),)
                        );
                        return;
                      }
                      if(_dates.length > 2 || _dates.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("일정을 선택해 주세요"), duration: Duration(seconds: 1),)
                        );
                        return;
                      }
                      try{
                        PlanModel plan = PlanModel(
                          id: idNum + 1,
                          nation: nationController.text,
                          schedule: _dates
                        );
                        context.read<PlanListProvider>().addPlanList(plan);
                      }catch(ex){
                        throw(ex).toString();
                      }
                      Navigator.pop(context);
                    }, style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ), child: const Text("생성", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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
      children: [
        const Text(
          "일정",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Gap(10),
        SizedBox(
            width: 500,
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                  firstDate: DateTime.now(),
                  firstDayOfWeek: 0,
                  calendarType: CalendarDatePicker2Type.range,
                weekdayLabels: ["일","월", "화","수","목","금","토"],

              ),
              value: _dates,
              onValueChanged: (list) => setState(() {
                _dates = list;
              })
            )),
        SizedBox(
            height: 60,
            child: _dates.isNotEmpty ? Text("${DateUtil.dateToString(_dates.first ?? DateTime.now())} "
                "~ ${DateUtil.dateToString(_dates.last??DateTime.now())}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),) : const Text("일정 선택")
        )
      ],
    );
  }
}
