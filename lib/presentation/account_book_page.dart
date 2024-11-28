import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/data/models/plan_model.dart';

import 'package:ready_go_project/util/intl_utils.dart';
import 'package:uuid/uuid.dart';

import '../provider/account_provider.dart';

class AccountBookPage extends StatefulWidget {
  final PlanModel plan;

  const AccountBookPage({super.key, required this.plan});

  @override
  State<AccountBookPage> createState() => _AccountBookPageState();
}

class _AccountBookPageState extends State<AccountBookPage> {
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _payAmountController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final PageController _expandController = PageController(initialPage: 0);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _daysController.dispose();
    _titleController.dispose();
    _payAmountController.dispose();
    _totalAmountController.dispose();
    _expandController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = context.watch<AccountProvider>().accountInfo;
    return Scaffold(
      appBar: AppBar(
        title: const Text("여행경비"),
      ),
      body: SingleChildScrollView(
        child: ExpandablePageView(controller: _expandController, physics: const BouncingScrollPhysics(), children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ..._totalInfoSection(context, info!),
                const Gap(40),
                SizedBox(
                  width: 140,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        _expandController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.zero),
                      child: const Text(
                        "사용내역 보기",
                        style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                      )),
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
              child: info.usageHistory == null || info.usageHistory!.isEmpty
                  ? SizedBox(
                      width: Get.width,
                      height: Get.height - 300,
                      child: const Center(
                        child: Text("사용내역이 없습니다."),
                      ),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int idx) {
                            final dayHistory = info.usageHistory!;
                            List<int> keys = dayHistory.keys.toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(30),
                                Container(
                                    width: Get.width,
                                    height: 40,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: const BorderRadius.only(topRight: Radius.circular(6), topLeft: Radius.circular(6))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${keys[idx]} 일차(${dayHistory[keys[idx]]?[0].usageTime!.month}월 ${info.usageHistory![keys[idx]]?[0].usageTime!.day}일)",
                                          // "${keys[idx]} 일차(${dayHistory[keys[idx]]?[0].usageTime!.month}/${info.usageHistory![keys[idx]]?[0].usageTime!.day})",
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )),
                                Table(
                                  border: TableBorder.all(),
                                  columnWidths: const {
                                    0: FixedColumnWidth(80),
                                    1: FlexColumnWidth(1),
                                    2: FixedColumnWidth(100),
                                  },
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                          child: Container(
                                              height: 40,
                                              decoration: const BoxDecoration(color: Colors.black87),
                                              child: const Center(
                                                  child: Text(
                                                "결제방법",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                              )))),
                                      TableCell(
                                          child: Container(
                                              height: 40,
                                              decoration: const BoxDecoration(color: Colors.black87),
                                              child: const Center(
                                                  child: Text(
                                                "사용 내용",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                              )))),
                                      TableCell(
                                          child: Container(
                                              height: 40,
                                              decoration: const BoxDecoration(color: Colors.black87),
                                              child: const Center(
                                                  child: Text(
                                                "금액",
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                              )))),
                                    ]),
                                    ...List.generate(dayHistory[keys[idx]]!.length, (count) {
                                      return TableRow(children: [
                                        TableCell(
                                            child: SizedBox(
                                                height: 40, child: Center(child: Text(dayHistory[keys[idx]]?[count].category == 0 ? "환전" : "카드")))),
                                        TableCell(child: SizedBox(height: 40, child: Center(child: Text("${dayHistory[keys[idx]]?[count].title}")))),
                                        TableCell(child: SizedBox(height: 40, child: Center(child: Text("${dayHistory[keys[idx]]?[count].amount}")))),
                                      ]);
                                    })
                                  ],
                                ),
                              ],
                            );
                          },
                          itemCount: info.usageHistory!.length,
                        ),
                        SizedBox(
                          width: 120,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                _expandController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                              },
                              style: ElevatedButton.styleFrom(
                                  side: const BorderSide(),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.zero),
                              child: const Text(
                                "사용정보 보기",
                                style: TextStyle(color: Colors.black87),
                              )),
                        ),
                      ],
                    ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addAmountDialog(context, info);
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
      ),
    );
  }

  List<Widget> _totalInfoSection(BuildContext context, AccountModel info) {
    return [
      SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "경비 정보",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 80,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    _setTotalAmountDialog(context, info);
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    "환전 추가",
                    style: TextStyle(color: Colors.black87),
                  )),
            )
          ],
        ),
      ),
      const Gap(20),
      Container(
        width: Get.width,
        height: 282,
        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                  color: Colors.black87,
                  border: Border(bottom: BorderSide()),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              child: GestureDetector(
                onTap: () {},
                child: const Center(
                  child: Text(
                    "사용 내역",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            // total exchange account
            Container(
              height: 60,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: const BoxDecoration(border: Border(right: BorderSide())),
                    child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "환전 총액",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text("(환전)")
                    ]),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          IntlUtils.stringIntAddComma(info.totalExchangeAccount ?? 0),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            // total use account
            Container(
              height: 60,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: const BoxDecoration(border: Border(right: BorderSide())),
                    child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "잔여 총액",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text("(환전)")
                    ]),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          IntlUtils.stringIntAddComma(info.totalUseAccount ?? 0),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            // usage exchange cash
            Container(
              height: 60,
              decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: const BoxDecoration(border: Border(right: BorderSide())),
                    child: const Center(
                      child: Text(
                        "환전 사용 금액",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          IntlUtils.stringIntAddComma(info.exchange ?? 0),
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
            // usage card
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: const BoxDecoration(border: Border(right: BorderSide())),
                    child: const Center(
                      child: Text(
                        "카드 사용 금액",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          IntlUtils.stringIntAddComma(info.card ?? 0),
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _addAmountDialog(BuildContext context, AccountModel info) {
    AmountModel newAmount = AmountModel();

    if (info.usageHistory != null && info.usageHistory!.isNotEmpty) {
      _daysController.text = "${info.usageHistory!.length}";
      // titleController.text = info.usageHistory![daysController.text]
    } else {
      _daysController.text = "1";
    }
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                height: 420,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "사용내역 추가 하기",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const Divider(),
                    const Gap(20),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: TextField(
                              controller: _daysController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  counterText: "",
                                  labelText: "사용 일차",
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12,
                                  )),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                          const Gap(10),
                          const Text("일차"),
                          const Gap(10),
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: DropdownMenu(
                              initialSelection: 0,
                              dropdownMenuEntries: const [DropdownMenuEntry(value: 0, label: "환전"), DropdownMenuEntry(value: 2, label: "카드")],
                              onSelected: (value) {
                                newAmount.category = value;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 282,
                            child: TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  counterText: "",
                                  labelText: "제목",
                                  labelStyle: const TextStyle(fontSize: 12, color: Colors.black87)),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              maxLength: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 282,
                            child: TextField(
                              controller: _payAmountController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  counterText: "",
                                  labelText: "사용 금액",
                                  labelStyle: const TextStyle(fontSize: 12, color: Colors.black87)),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              maxLength: 13,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
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
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.grey),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: const Text(
                                  "취소",
                                  style: TextStyle(color: Colors.black87),
                                )),
                          ),
                          const Gap(20),
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_daysController.text.isEmpty) {
                                    Get.snackbar("데이터 입력 확인", "사용 일차를 확인해 주세요", backgroundColor: Colors.white);
                                    return;
                                  }
                                  if (_titleController.text.isEmpty) {
                                    Get.snackbar("데이터 입력 확인", "제목을 확인해 주세요", backgroundColor: Colors.white);
                                    return;
                                  }
                                  if (_payAmountController.text.isEmpty) {
                                    Get.snackbar("데이터 입력 확인", "사용 금액을 확인해 주세요", backgroundColor: Colors.white);
                                    return;
                                  }
                                  newAmount.id = const Uuid().v4();
                                  newAmount.title = _titleController.text;

                                  newAmount.amount = int.parse(_payAmountController.text);
                                  newAmount.category ??= 0;
                                  int day = int.parse(_daysController.text);
                                  if (day == 1) {
                                    newAmount.usageTime = widget.plan.schedule!.first;
                                  } else if (day > 1) {
                                    newAmount.usageTime = widget.plan.schedule!.first!.add(Duration(days: day - 1));
                                  }

                                  context.read<AccountProvider>().addAmount(newAmount, day, widget.plan.id!);
                                  _titleController.text = "";
                                  _payAmountController.text = "";
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: const Text(
                                  "추가하기",
                                  style: TextStyle(color: Colors.white),
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

  Future<void> _setTotalAmountDialog(BuildContext context, AccountModel info) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          "총 경비 추가 하기",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const Divider(),
                    const Gap(20),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 282,
                            child: TextField(
                              controller: _totalAmountController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                  counterText: "",
                                  labelText: "추가 금액",
                                  labelStyle: const TextStyle(fontSize: 12, color: Colors.black87)),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              maxLength: 13,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
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
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.grey),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: const Text(
                                  "취소",
                                  style: TextStyle(color: Colors.black87),
                                )),
                          ),
                          const Gap(20),
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_totalAmountController.text.isEmpty) {
                                    Get.snackbar("데이터 입력 확인", "추가 금액을 확인해 주세요", backgroundColor: Colors.white);
                                    return;
                                  }
                                  int amount = int.tryParse(_totalAmountController.text) ?? 0;

                                  context.read<AccountProvider>().addTotalAmount(amount, widget.plan.id!);
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: const Text(
                                  "추가하기",
                                  style: TextStyle(color: Colors.white),
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
}
