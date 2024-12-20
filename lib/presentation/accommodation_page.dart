import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:accordion/accordion.dart';

import 'package:ready_go_project/data/models/plan_model.dart';
import 'package:ready_go_project/domain/entities/accommodation_provider.dart';
import 'package:ready_go_project/util/intl_utils.dart';

class AccommodationPage extends StatefulWidget {
  final PlanModel plan;

  const AccommodationPage({super.key, required this.plan});

  @override
  State<AccommodationPage> createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<AccommodationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _periodController.dispose();
    _paymentController.dispose();
    _checkOutController.dispose();
    _checkInController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<AccommodationProvider>().accommodation;
    int month = widget.plan.schedule!.first!.month;
    int day = widget.plan.schedule!.first!.day;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("숙소정보"),
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: list?.isEmpty == true || list == null
                ? SizedBox(
                    height: Get.height - 300,
                    child: const Center(child: Text("숙소 정보가 없습니다.")),
                  )
                : _accordionSection(context, list)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addAccommodation(context, month, day);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _addAccommodation(BuildContext context, int month, int day) {
    return showDialog(
        context: context,
        builder: (BuildContext diaContext) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Container(
                  height: 720,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // info field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "숙소 정보",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const Gap(10),
                          SizedBox(
                            height: 50,
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                label: const Text(
                                  "숙소명",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const Gap(10),
                          SizedBox(
                            height: 50,
                            child: TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                label: const Text(
                                  "주소",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const Gap(10),
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: TextField(
                              controller: _paymentController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                label: const Text(
                                  "결제금액",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Gap(10),
                      const Divider(),
                      // start Day
                      const Gap(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "숙박 일정",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const Gap(10),
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("시작일 : "),
                                const Gap(10),
                                DropdownMenu(
                                  width: 110,
                                  // enabled: false,
                                  menuStyle: const MenuStyle(
                                    visualDensity: VisualDensity.compact, // 밀도 조정
                                  ),
                                  initialSelection: month,
                                  onSelected: (value) {
                                    setState(() {
                                      month = value!;
                                    });
                                  },
                                  // selectedTrailingIcon: null,
                                  dropdownMenuEntries: [...List.generate(12, (idx) => DropdownMenuEntry(value: idx + 1, label: "${idx + 1}월"))],
                                ),
                                const Gap(10),
                                DropdownMenu(
                                  width: 110,
                                  // enabled: false,
                                  menuStyle: const MenuStyle(
                                    visualDensity: VisualDensity.compact, // 밀도 조정
                                  ),
                                  initialSelection: day,
                                  onSelected: (value) {
                                    setState(() {
                                      if (value! < day) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("여행 시작일 보다 이전의 날짜로 설정 할 수 없습니다.")));
                                        return;
                                      }
                                      if (value > widget.plan.schedule!.last!.day) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("여행 종료일 보다 이후 날짜로 설정 할 수 없습니다.")));
                                        return;
                                      }
                                      day = value;
                                    });
                                  },
                                  dropdownMenuEntries: [
                                    ...List.generate(getDaysOfMouth(widget.plan.schedule!.first!.year, month),
                                        (idx) => DropdownMenuEntry(value: idx + 1, label: "${idx + 1}일"))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      // period
                      Row(
                        children: [
                          const Text("숙박기간 : "),
                          const Gap(10),
                          SizedBox(
                            width: 60,
                            height: 50,
                            child: TextField(
                              controller: _periodController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                label: const Text("일정", style: TextStyle(color: Colors.black87)),
                                border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const Gap(10),
                          const Text("박")
                        ],
                      ),
                      const Gap(10),
                      const Divider(),
                      const Gap(5),
                      // options(checkIn/checkout)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "옵션",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const Gap(10),
                          SizedBox(
                            height: 50,
                            width: Get.width,
                            child: Row(
                              children: [
                                const SizedBox(width: 70, child: Text("체크인 : ")),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _checkInController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10))),
                                  ),
                                ),
                                const Gap(10),
                                const Text("시")
                              ],
                            ),
                          ),
                          const Gap(10),
                          SizedBox(
                            height: 50,
                            width: Get.width,
                            child: Row(
                              children: [
                                const SizedBox(width: 70, child: Text("체크아웃 : ")),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _checkOutController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10))),
                                  ),
                                ),
                                const Gap(10),
                                const Text("시")
                              ],
                            ),
                          )
                        ],
                      ),
                      const Gap(10),
                      const Divider(),
                      const Gap(5),
                      // buttons
                      SizedBox(
                        height: 50,
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      side: const BorderSide(),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: const Text(
                                    "닫기",
                                    style: TextStyle(color: Colors.black87),
                                  )),
                            ),
                            const Gap(20),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_nameController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "숙소명을 입력해 주세요", colorText: Colors.white, backgroundColor: Colors.black87, snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("여행 종료일 보다 이후 날짜로 설정 할 수 없습니다.")));
                                      return;
                                    }
                                    if (_addressController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "주소를 입력해 주세요.", colorText: Colors.white, backgroundColor: Colors.black87, snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("숙소 주소를 확인해 주세요")));
                                      return;
                                    }
                                    if (_paymentController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "숙박 가격을 입력해 주세요.", colorText: Colors.white, backgroundColor: Colors.black87, snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("숙소 가격을 확인해 주세요")));
                                      return;
                                    }
                                    if (_periodController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "숙박 일 수를 입력해 주세요.", colorText: Colors.white, backgroundColor: Colors.black87, snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("숙박 기간을 확인해 주세요")));
                                      return;
                                    }
                                    if (_checkInController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "체크인 시간을 입력해 주세요.", colorText: Colors.white, backgroundColor: Colors.black87, snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("체크인 시간을 확인해 주세요")));
                                      return;
                                    }
                                    if (_checkOutController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "체크 아웃 시간을 입력해 주세요.", colorText: Colors.white, backgroundColor: Colors.black87, snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("체크아웃 시간을 확인해 주세요")));
                                      return;
                                    }

                                    AccommodationModel info = AccommodationModel();
                                    info.name = _nameController.text;
                                    info.address = _addressController.text;
                                    info.payment = _paymentController.text;
                                    info.checkInTime = _checkInController.text;
                                    info.checkOutTime = _checkOutController.text;
                                    info.period = int.parse(_periodController.text);
                                    info.startDay = DateTime(widget.plan.schedule!.first!.year, month, day);

                                    context.read<AccommodationProvider>().addAccommodation(info, widget.plan.id!);
                                    _nameController.text = "";
                                    _addressController.text = "";
                                    _paymentController.text = "";
                                    _checkInController.text = "";
                                    _checkOutController.text = "";
                                    _periodController.text = "";

                                    Navigator.pop(diaContext);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: const Text(
                                    "추가",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _accordionSection(BuildContext context, List<AccommodationModel> list) {
    return Accordion(
        disableScrolling: true,
        headerBorderColor: Colors.black87,
        headerBorderColorOpened: Colors.black87,
        headerBorderWidth: 1,
        headerPadding: const EdgeInsets.all(20),
        headerBackgroundColor: Colors.white,
        contentBorderColor: Colors.black87,
        contentVerticalPadding: 20,
        contentHorizontalPadding: 20,
        children: [
          ...List.generate(list.length, (idx) {
            return AccordionSection(
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${list[idx].name} (${list[idx].period}박)",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: TextButton(
                          onPressed: () {
                            context.read<AccommodationProvider>().removeAccommodation(list[idx], widget.plan.id!);
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text("삭제")),
                    ),
                  ],
                ),
                content: Container(
                    width: Get.width,
                    height: 300,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "주소",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                      child: const Text("구글맵 열기"),
                                    ),
                                  ),
                                  const Gap(10),
                                  SizedBox(
                                    width: 70,
                                    child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                      child: const Text("주소 복사"),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(
                            "${list[idx].address}",
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          width: Get.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                                child: Text(
                                  "숙박 일정",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: Text("${list[idx].startDay!.year}.${list[idx].startDay!.month}.${list[idx].startDay!.day} "
                                    "~ ${list[idx].startDay!.add(Duration(days: list[idx].period!)).year}."
                                    "${list[idx].startDay!.add(Duration(days: list[idx].period!)).month}."
                                    "${list[idx].startDay!.add(Duration(days: list[idx].period!)).day} (${list[idx].period}박)"),
                              )
                            ],
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          width: Get.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                                child: Text(
                                  "옵션",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: Row(
                                  children: [const SizedBox(width: 60, child: Text("체크인")), Text(": ${list[idx].checkInTime} 시")],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: Row(
                                  children: [const SizedBox(width: 60, child: Text("체크아웃")), Text(": ${list[idx].checkOutTime} 시")],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "결제금액",
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              Text(
                                IntlUtils.stringIntAddComma(int.parse(list[idx].payment!)),
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              )
                            ],
                          ),
                        )
                      ],
                    )));
          })
        ]);
  }

  int getDaysOfMouth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    } else {
      return DateTime(year, month + 1, 0).day;
    }
  }
}
