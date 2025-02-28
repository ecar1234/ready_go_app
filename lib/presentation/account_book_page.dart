import 'dart:async';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/util/intl_utils.dart';

import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/account_provider.dart';
import '../domain/entities/provider/admob_provider.dart';

class AccountBookPage extends StatefulWidget {
  final PlanModel plan;

  const AccountBookPage({super.key, required this.plan});

  @override
  State<AccountBookPage> createState() => _AccountBookPageState();
}

class _AccountBookPageState extends State<AccountBookPage> {
  final TextEditingController _totalDaysController = TextEditingController(text: "1");
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _payAmountController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final logger = Logger();
  // final TextEditingController _editDetailController = TextEditingController(text: amount.title);
  // final TextEditingController _editAmountController = TextEditingController(text: amount.amount.toString());
  // final TextEditingController _editCategoryController = TextEditingController();
  final PageController _expandController = PageController(initialPage: 0);

  Timer? _debounce;

  _onChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _daysController.dispose();
    _titleController.dispose();
    _payAmountController.dispose();
    _totalAmountController.dispose();
    _expandController.dispose();
    _totalDaysController.dispose();

    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final AccountModel info = context.watch<AccountProvider>().accountInfo!;
    context.read<AdmobProvider>().loadAdBanner();
    return Scaffold(
      appBar: AppBar(
        title: const Text("여행경비"),
      ),
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height - 100,
          child: ExpandablePageView(
              controller: _expandController, physics: const BouncingScrollPhysics(), children: [_page1(context, info), _page2(context, info)]),
        ),
        Builder(builder: (context) {
          final BannerAd? bannerAd = context.watch<AdmobProvider>().bannerAd;
          if (bannerAd != null) {
            return Positioned(
                left: 20,
                right: 20,
                bottom: 30,
                child: SizedBox(
                  width: bannerAd.size.width.toDouble(),
                  height: bannerAd.size.height.toDouble(),
                  child: AdWidget(
                    ad: bannerAd,
                  ),
                ));
          } else {
            logger.d("Banner Ad is null on account page");
            return const SizedBox();
          }
        })
      ]),
      // floatingActionButton: FloatingActionButton(
      //   foregroundColor: Theme.of(context).colorScheme.surface,
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      //   onPressed: () {
      //     _addAmountDialog(context, info);
      //   },
      //   child: const Icon(
      //     Icons.add,
      //   ),
      // ),
    );
  }

  Widget _page1(BuildContext context, AccountModel info) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ..._totalInfoSection(context, info),
          const Gap(40),
          SizedBox(
            width: 140,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  _expandController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                },
                style: ElevatedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.zero),
                child: const Text(
                  "사용내역 보기",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }

  Widget _page2(BuildContext context, AccountModel info) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 100),
        child: Column(
          children: [
            Container(
              height: 60,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  // 잔여 경비
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.secondary,
                                      border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline)),
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "잔액",
                                        style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "(환전)",
                                        style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        IntlUtils.stringIntAddComma(info.totalUseAccount!),
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      )),
                  // 총 사용 금액
                  Expanded(
                      flex: 1,
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "총 지출",
                                      style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "(환전)",
                                      style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              )),
                          Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      IntlUtils.stringIntAddComma(info.exchange!),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ))
                        ],
                      )),
                ],
              ),
            ),
            const Gap(10),
            info.usageHistory == null || info.usageHistory!.isEmpty
                ? SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height - 300,
                    child: const Center(
                      child: Text("사용내역이 없습니다."),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height - 300,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             const Text("사용내역", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                              TextButton.icon(
                                onPressed: (){
                                  _addAmountDialog(context, info);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  )
                                ),
                                label: const Text("지출"), icon: const Icon(Icons.add),iconAlignment: IconAlignment.end,)
                            ],
                          ),
                        ),
                        const Gap(20),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, fidx) {
                              List<List<AmountModel>?> amountList = info.usageHistory!;
                              return Container(
                                width: MediaQuery.sizeOf(context).width - 40,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // date section
                                        Container(
                                            height: 40,
                                            width: MediaQuery.sizeOf(context).width - 42,
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondary,
                                                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline)),
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${amountList[fidx]!.first.usageTime!.month}월 ${amountList[fidx]!.first.usageTime!.day}일(${amountList[fidx]!.first.id}일차)",
                                                  style: TextStyle(
                                                      color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w600, fontSize: 16),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    // title menu
                                    Container(
                                      height: 40,
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                              width: (MediaQuery.sizeOf(context).width - 42) * 0.2,
                                              child: const Center(
                                                  child: Text(
                                                "종류",
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ))),
                                          Container(
                                              width: (MediaQuery.sizeOf(context).width - 42) * 0.6,
                                              decoration: BoxDecoration(
                                                  border: Border.symmetric(vertical: BorderSide(color: Theme.of(context).colorScheme.outline))),
                                              child: const Center(
                                                  child: Text(
                                                "사용 내역",
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ))),
                                          SizedBox(
                                              width: (MediaQuery.sizeOf(context).width - 42) * 0.2,
                                              child: const Center(
                                                  child: Text(
                                                "금액",
                                                style: TextStyle(fontWeight: FontWeight.w600),
                                              ))),
                                        ],
                                      ),
                                    ),
                                    // use detail
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, idx) {
                                        List<AmountModel> list = amountList[fidx]!;
                                        return Container(
                                          decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline))),
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _usedAmountEdit(context, info.usageHistory, fidx, idx);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        SizedBox(
                                                            height: 40,
                                                            width: (MediaQuery.sizeOf(context).width - 42) * 0.2,
                                                            child: Center(child: Text(list[idx].category == 0 ? "현금" : "카드"))),
                                                        Container(
                                                            height: 40,
                                                            width: (MediaQuery.sizeOf(context).width - 42) * 0.6,
                                                            decoration: BoxDecoration(
                                                                border: Border.symmetric(
                                                                    vertical: BorderSide(color: Theme.of(context).colorScheme.outline))),
                                                            child: Center(child: Text("${list[idx].title}"))),
                                                        SizedBox(
                                                            height: 40,
                                                            width: (MediaQuery.sizeOf(context).width - 42) * 0.2,
                                                            child: Center(
                                                                child: Text(
                                                              "${list[idx].amount}",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w600,
                                                                  color: list[idx].type == AmountType.add
                                                                      ? Colors.blueAccent
                                                                      : (list[idx].category == 0 ? Colors.redAccent : Colors.green)),
                                                            ))),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      itemCount: amountList[fidx]!.length,
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, fidx) => const Gap(20),
                            itemCount: info.usageHistory!.length,
                          ),
                        ),
                        const Gap(20),
                        SizedBox(
                          width: 120,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                _expandController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                              },
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.zero),
                              child: const Text(
                                "경비내역 보기",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              )),
                        ),
                      ],
                    ),
                  ),
          ],
        ));
  }

  List<Widget> _totalInfoSection(BuildContext context, AccountModel info) {
    return [
      Container(
        height: 40,
        decoration:  BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary,))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "경비 정보",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 150,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        _setTotalAmountDialog(context, info);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,),
                      label: const Text(
                        "총 경비",
                      ),
                    icon: const Icon(Icons.add),
                    iconAlignment: IconAlignment.end,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _addAmountDialog(context, info);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,),
                    label: const Text(
                      "지출",
                    ),
                    icon: const Icon(Icons.add),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      const Gap(15),
      Container(
        width: MediaQuery.sizeOf(context).width,
        height: 282,
        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline)),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
              child:  Center(
                child: Text(
                  "여행 경비 내역",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.surface,),
                ),
              ),
            ),
            // total exchange account
            Container(
              height: 60,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline))),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
                    child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "총 경비",
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
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline))),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
                    child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "잔여 경비",
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
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outline))),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
                    child: const Center(
                      child: Text(
                        "현금 사용",
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
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Theme.of(context).colorScheme.outline))),
                    child: const Center(
                      child: Text(
                        "카드 사용",
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
              child: SingleChildScrollView(
                child: Container(
                  height: 420,
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      //title
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
                      // days
                      SizedBox(
                        height: 50,
                        width: 280,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: TextField(
                                controller: _daysController,
                                onChanged: _onChanged,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                                        borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                    counterText: "",
                                    labelText: "사용 일차",
                                    labelStyle: const TextStyle(
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
                      // detail
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 282,
                              child: TextField(
                                controller: _titleController,
                                onChanged: _onChanged,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                                        borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                                        borderRadius: BorderRadius.circular(10)),
                                    counterText: "",
                                    labelText: "제목",
                                    labelStyle: const TextStyle(fontSize: 12)),
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                maxLength: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      // amount
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 282,
                              child: TextField(
                                controller: _payAmountController,
                                onChanged: _onChanged,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                                        borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                                        borderRadius: BorderRadius.circular(10)),
                                    counterText: "",
                                    labelText: "사용 금액",
                                    labelStyle: const TextStyle(fontSize: 12)),
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
                      // buttons
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
                                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero),
                                  child: const Text(
                                    "닫기",
                                  )),
                            ),
                            const Gap(20),
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_daysController.text.isEmpty) {
                                      Get.snackbar("데이터 입력 확인", "사용 일차를 확인해 주세요", colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                                      return;
                                    }
                                    if (_titleController.text.isEmpty) {
                                      Get.snackbar("데이터 입력 확인", "제목을 확인해 주세요", colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                                      return;
                                    }
                                    if (_payAmountController.text.isEmpty) {
                                      Get.snackbar("데이터 입력 확인", "사용 금액을 확인해 주세요", colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                                      return;
                                    }
                                    newAmount.id = _daysController.text;
                                    newAmount.title = _titleController.text;
                                    newAmount.type = AmountType.use;
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
                                    // Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero),
                                  child: Text(
                                    "추가하기",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.surface,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: TextField(
                              controller: _totalAmountController,
                              onChanged: _onChanged,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline), borderRadius: BorderRadius.circular(10)),
                                  counterText: "",
                                  labelText: "추가 금액",
                                  labelStyle: const TextStyle(fontSize: 12)),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              maxLength: 13,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          ),
                          const Gap(10),
                          SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _totalDaysController,
                                textAlign: TextAlign.end,
                              )),
                          const Gap(10),
                          const Text("일차")
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
                                    // backgroundColor: Theme.of(context).colorScheme.primary,
                                    side: BorderSide(color: Theme.of(context).colorScheme.outline),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: const Text(
                                  "취소",
                                )),
                          ),
                          const Gap(20),
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_totalAmountController.text.isEmpty) {
                                    Get.snackbar("데이터 입력 확인", "추가 금액을 확인해 주세요", colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                                    return;
                                  }
                                  int amount = int.tryParse(_totalAmountController.text) ?? 0;
                                  int days = int.tryParse(_totalDaysController.text) ?? 1;
                                  context.read<AccountProvider>().addTotalAmount(amount, days, widget.plan.id!);
                                  _totalAmountController.text = "";
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  "추가하기",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface,
                                  ),
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

  Future<void> _usedAmountEdit(BuildContext context, List<List<AmountModel>?>? history, int fIdx, int sInd) {
    var amount = history![fIdx]![sInd];

    return showDialog(
        context: context,
        builder: (context) {
          final TextEditingController detailController = TextEditingController(text: amount.title);
          final TextEditingController amountController = TextEditingController(text: amount.amount.toString());
          final TextEditingController categoryController = TextEditingController();

          return Dialog(
            child: Container(
                width: MediaQuery.sizeOf(context).width - 60,
                height: 360,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    //title
                    const SizedBox(
                      height: 60,
                      child: Center(
                        child: Text(
                          "수정 & 삭제",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const Divider(),
                    Container(
                        height: 250,
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // category
                                    SizedBox(
                                      height: 60,
                                      child: DropdownMenu(
                                          controller: categoryController,
                                          initialSelection: amount.category,
                                          enabled: amount.type == AmountType.add ? false : true,
                                          dropdownMenuEntries: const [
                                            DropdownMenuEntry(value: 0, label: "환전"),
                                            DropdownMenuEntry(value: 2, label: "카드")
                                          ]),
                                    ),
                                    // amount
                                    SizedBox(
                                      width: 120,
                                      child: TextField(
                                        controller: amountController,
                                        textAlign: TextAlign.end,
                                        decoration: const InputDecoration(
                                          labelText: "사용금액",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const Gap(20),
                                // detail
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child: TextField(
                                        controller: detailController,
                                        decoration: const InputDecoration(labelText: "사용내역"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                            SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          categoryController.dispose();
                                          amountController.dispose();
                                          detailController.dispose();
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        child: const Text("닫기")),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          AmountModel newAmount = AmountModel();
                                          newAmount.id = amount.id;
                                          newAmount.amount = int.tryParse(amountController.text);
                                          newAmount.category = categoryController.text == "환전" ? 0 : 2;
                                          newAmount.title = detailController.text;
                                          newAmount.type = amount.type;
                                          newAmount.usageTime = amount.usageTime;

                                          if (newAmount.title == amount.title &&
                                              newAmount.amount == amount.amount &&
                                              newAmount.category == amount.category) {
                                            Get.snackbar("수정 내용을 확인해 주세요", "변경 사항이 존재하지 않아 수정 할 수 없습니다.", colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                                            return;
                                          }

                                          context.read<AccountProvider>().editeAmountItem(fIdx, sInd, newAmount, widget.plan.id!);

                                          // categoryController.dispose();
                                          // amountController.dispose();
                                          // detailController.dispose();

                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor: Colors.black87,
                                            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        child: const Text(
                                          "수정",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          context.read<AccountProvider>().removeAmountItem(fIdx, sInd, widget.plan.id!);
                                          categoryController.dispose();
                                          amountController.dispose();
                                          detailController.dispose();
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor: Theme.of(context).colorScheme.secondary,
                                            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        child: Text(
                                          "삭제",
                                          style: TextStyle(color: Theme.of(context).colorScheme.surface),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ],
                )),
          );
        });
  }
}
