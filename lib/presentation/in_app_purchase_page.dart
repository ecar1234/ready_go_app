
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/purchases/purchase_model.dart';
import 'package:ready_go_project/domain/entities/provider/purchase_manager.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';

class InAppPurchasePage extends StatefulWidget {
  const InAppPurchasePage({super.key});

  @override
  State<InAppPurchasePage> createState() => _InAppPurchasePageState();
}

class _InAppPurchasePageState extends State<InAppPurchasePage> {
  final Logger logger = Logger();

  // final PurchaseManager purchaseManager = PurchaseManager();

  int _selectedIdx = -1;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    // context.read<PurchaseManager>().queryProducts(_productIds);
    final products = context.read<PurchaseManager>().products;
    // final purchases = context.watch<PurchaseManager>().purchases;
    // logger.i(products);
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final hei = GetIt.I.get<ResponsiveHeightProvider>().resHeight!;
    final wid = MediaQuery.sizeOf(context).width;
    return Container(
        height: hei - 80,
        width: wid,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            // title
            SizedBox(
                height: hei * 0.3,
                width: wid - 40,
                // color: Colors.teal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "당신의 모든 여정을",
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Ready Go가",
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "편리하게 만들어 드립니다",
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ],
                )),
            Container(
              height: (hei * 0.7) - 100,
              width: wid - 40,
              padding: const EdgeInsets.all(20),
              // color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context){
                      final itemsHei = (hei * 0.7) - 200;
                    return SizedBox(
                      height: itemsHei,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Selector<PurchaseManager, List<PurchaseModel>>(
                            selector: (context, manager) => manager.purchases,
                            builder:(context, purchases, child) {
                              final isRemove = purchases.any((item) => item.productId.contains("cash_3300"));
                            return GestureDetector(
                              onTap: isRemove ? null : () {
                                //TODO: 이거 로직을 좀 생각해야 될듯 하다..
                                if (_selectedIdx == -1) {
                                  setState(() {
                                    _selectedIdx = 0;
                                  });
                                } else {
                                  setState(() {
                                    _selectedIdx = -1;
                                  });
                                }
                              },
                              child: Container(
                                  height: 120,
                                  width: wid - 80,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? (_selectedIdx == 0 || isRemove ? Theme.of(context).colorScheme.primary : Colors.transparent)
                                          : Colors.white,
                                      border: Border.all(
                                          width: _selectedIdx == 0 || isRemove ? 2 : 1,
                                          color: isDarkMode
                                              ? Colors.white
                                              : (_selectedIdx == 0 || isRemove ? Theme.of(context).colorScheme.primary : Colors.black87)),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 할인 정보
                                      SizedBox(
                                        // width: 110,
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 110,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  // Container(
                                                  //   width: 50,
                                                  //   height: 25,
                                                  //   decoration: BoxDecoration(
                                                  //       color: _selectedIdx == 0 || isRemove ? Colors.orangeAccent : const Color(0xff999999),
                                                  //       border: _selectedIdx == 0 || isRemove ? null : Border.all(color: const Color(0xff999999)),
                                                  //       borderRadius: BorderRadius.circular(25)),
                                                  //   child: const Center(
                                                  //       child: Text(
                                                  //     "인기",
                                                  //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                  //   )),
                                                  // ),
                                                  Container(
                                                    width: 50,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                        color: _selectedIdx == 0 || isRemove ? Colors.teal : const Color(0xff999999),
                                                        border: _selectedIdx == 0 || isRemove ? null : Border.all(color: const Color(0xff999999)),
                                                        borderRadius: BorderRadius.circular(25)),
                                                    child: const Center(
                                                        child: Text(
                                                      "-20%",
                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                    )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // 구매 정보
                                      Expanded(
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    Platform.isIOS ?
                                                    "광고 제거" :
                                                    products.first.title.split(" ").first,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 18,
                                                        color: isDarkMode
                                                            ? (_selectedIdx == 0 || isRemove ? Colors.white : const Color(0xff999999))
                                                            : (_selectedIdx == 0 || isRemove ? Colors.black87 : const Color(0xff999999))),
                                                  ),
                                                  if(isRemove)
                                                  const Gap(10),
                                                  if(isRemove)
                                                      SizedBox(
                                                        // width: 50,
                                                        // height: 50,
                                                        child: Text("(구입 완료)", style: TextStyle(
                                                            color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                                                            fontWeight: FontWeight.w600),),
                                                      ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "₩4100",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[400],
                                                        decoration: TextDecoration.lineThrough,
                                                        decorationColor: Colors.grey[400]),
                                                  ),
                                                  Text(
                                                    "₩3300",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: isDarkMode
                                                            ? (_selectedIdx == 0 || isRemove? Colors.white : const Color(0xff999999))
                                                            : (_selectedIdx == 0 || isRemove ? Colors.black87 : const Color(0xff999999)),
                                                        fontWeight: FontWeight.w600),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // 설명
                                      SizedBox(
                                        child: Text("광고 없이 서비스를 이용 할 수 있습니다.",
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? (_selectedIdx == 0 || isRemove ? Colors.white : const Color(0xff999999))
                                                : (_selectedIdx == 0 || isRemove ? Colors.black87 : const Color(0xff999999))
                                        ),),
                                      )
                                    ],
                                  )),
                            );
                          }),
                          const Gap(10),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Container(
                          //       height: 120,
                          //       width: wid - 80,
                          //       padding: const EdgeInsets.all(10),
                          //       decoration: BoxDecoration(
                          //           // color: isDarkMode ? (_selectedIdx == 0 ? Theme.of(context).colorScheme.primary : Colors.transparent) : Colors.white,
                          //           color: Colors.transparent,
                          //           border: Border.all(
                          //               // width: _selectedIdx == 0 ? 2 : 1,
                          //               // color: isDarkMode ? Colors.white : (_selectedIdx == 0 ? Theme.of(context).colorScheme.primary : Colors.black87)),
                          //               color: isDarkMode ? Colors.white : const Color(0xff999999)),
                          //           borderRadius: BorderRadius.circular(10)),
                          //       child: const Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           // 할인 정보
                          //           SizedBox(
                          //             width: 110,
                          //             height: 25,
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.start,
                          //               children: [
                          //                 Text(
                          //                   "업데이트 준비 중",
                          //                   style: TextStyle(color: Color(0xff999999)),
                          //                 )
                          //                 // Container(
                          //                 //   width: 50,
                          //                 //   decoration: BoxDecoration(
                          //                 //       color: _selectedIdx == 0 ? Colors.orangeAccent : const Color(0xff999999),
                          //                 //       border: _selectedIdx == 0 ? null : Border.all(color: const Color(0xff999999)),
                          //                 //       borderRadius: BorderRadius.circular(25)),
                          //                 //   child: const Center(
                          //                 //       child: Text(
                          //                 //         "인기",
                          //                 //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          //                 //       )),
                          //                 // ),
                          //                 // Container(
                          //                 //   width: 50,
                          //                 //   decoration: BoxDecoration(
                          //                 //       color: _selectedIdx == 0 ? Colors.teal : const Color(0xff999999),
                          //                 //       border: _selectedIdx == 0 ? null : Border.all(color: const Color(0xff999999)),
                          //                 //       borderRadius: BorderRadius.circular(25)),
                          //                 //   child: const Center(
                          //                 //       child: Text(
                          //                 //         "-20%",
                          //                 //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          //                 //       )),
                          //                 // )
                          //               ],
                          //             ),
                          //           ),
                          //           // 구매 정보
                          //           Expanded(
                          //             child: SizedBox(
                          //               child: Column(
                          //                 mainAxisAlignment: MainAxisAlignment.center,
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   Row(
                          //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                     children: [
                          //                       Text(
                          //                         "광고 제거 & 데이터 저장",
                          //                         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Color(0xff999999)
                          //                             // color: isDarkMode
                          //                             //     ? (_selectedIdx == 0 ? Colors.white : Color(0xff999999))
                          //                             //     : (_selectedIdx == 0 ? Colors.black87 : Color(0xff999999))
                          //                             ),
                          //                       ),
                          //                       Column(
                          //                         mainAxisAlignment: MainAxisAlignment.center,
                          //                         children: [
                          //                           // const Text(
                          //                           //   "₩9,900",
                          //                           //   style: TextStyle(fontSize: 14, color: Color(0xff999999), decoration: TextDecoration.lineThrough),
                          //                           // ),
                          //                           Text(
                          //                             "₩15,000",
                          //                             style: TextStyle(
                          //                                 fontSize: 18,
                          //                                 color: Color(0xff999999),
                          //                                 // color: isDarkMode
                          //                                 //     ? (_selectedIdx == 0 ? Colors.white : Color(0xff999999))
                          //                                 //     : (_selectedIdx == 0 ? Colors.black87 : Color(0xff999999)),
                          //                                 fontWeight: FontWeight.w600),
                          //                           ),
                          //                         ],
                          //                       )
                          //                     ],
                          //                   ),
                          //                   Text(
                          //                     "(Web 에서도 접속 가능)",
                          //                     style: TextStyle(color: Color(0xff999999), fontSize: 12),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       )),
                          // ),
                        ],
                      ),
                    );}
                  ),
                  // const Gap(20),
                  SizedBox(
                    height: 50,
                    width: wid - 80,
                    child: ElevatedButton(
                        onPressed: _selectedIdx != -1
                            ? () {
                                if (_selectedIdx == 0) {
                                  context.read<PurchaseManager>().buyProduct(products.first, context);

                                } else if (_selectedIdx == 1) {
                                } else {}
                              }
                            : null,
                        style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                        child: Text(
                          "결제하기",
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : (_selectedIdx != -1 ? Theme.of(context).colorScheme.primary : Colors.grey[400])),
                        )),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
