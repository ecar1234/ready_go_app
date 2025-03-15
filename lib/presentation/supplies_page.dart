import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/data/models/supply_model/template_model.dart';
import 'package:ready_go_project/domain/entities/provider/supplies_template_provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:ready_go_project/presentation/supplies_page/add_template_page.dart';

import '../domain/entities/provider/supplies_provider.dart';
import '../util/admob_util.dart';

class SuppliesPage extends StatefulWidget {
  final int planId;

  const SuppliesPage({super.key, required this.planId});

  @override
  State<SuppliesPage> createState() => _SuppliesPageState();
}

class _SuppliesPageState extends State<SuppliesPage> {
  final TextEditingController _controller = TextEditingController();
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;

  Timer? _debounce;

  _onChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<SuppliesTemplateProvider>().getTempList());
    _admobUtil.loadBannerAd(onAdLoaded: () {
      setState(() {
        _isLoaded = true;
      });
    }, onAdFailed: () {
      setState(() {
        _isLoaded = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _debounce?.cancel();
    _admobUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = context
        .watch<SuppliesProvider>()
        .suppliesList;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("준비물"),
          actions: [
            SizedBox(
              width: 100,
              child: TextButton.icon(
                onPressed: () {
                  _suppliesTemplateDialog(context, list);
                },
                style: IconButton.styleFrom(padding: EdgeInsets.zero),
                label: const Text(
                  "템플릿",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                iconAlignment: IconAlignment.end,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .sizeOf(context)
                .height - 120,
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    SingleChildScrollView(
                      child: SizedBox(
                        // height: MediaQuery.sizeOf(context).height - 300,
                        // height: list.isEmpty ? MediaQuery.sizeOf(context).height - 300 : (45 * list.length.toDouble()),
                        // padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width,
                              height: 40,
                              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xff666666)))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "체크리스트",
                                    style: TextStyle(color: Theme
                                        .of(context)
                                        .colorScheme
                                        .secondary, fontWeight: FontWeight.w600, fontSize: 18),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      _itemAddDialog(context);
                                    },
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    label: Text(
                                      "추가",
                                      style: TextStyle(color: Theme
                                          .of(context)
                                          .colorScheme
                                          .secondary),
                                    ),
                                    icon: Icon(
                                      Icons.add,
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    iconAlignment: IconAlignment.end,
                                  )
                                ],
                              ),
                            ),
                            const Gap(10),
                            Container(
                                height: MediaQuery
                                    .sizeOf(context)
                                    .height - 300,
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xff666666)), borderRadius: BorderRadius.circular(10)),
                                child: list.isEmpty
                                    ? const Center(
                                  child: Text("목록을 추가해 주세요"),
                                )
                                    : Scrollbar(
                                  child: ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, idx) {
                                        return SizedBox(
                                          height: 40,
                                          child: TextButton(
                                              onPressed: () {
                                                context.read<SuppliesProvider>().updateItemState(idx, widget.planId);
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 16,
                                                          width: 16,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: const Color(0xff666666)),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1.5, color: list[idx].isCheck! ? Colors.white : Colors.transparent),
                                                                shape: BoxShape.circle,
                                                                color:
                                                                list[idx].isCheck! ? Theme
                                                                    .of(context)
                                                                    .colorScheme
                                                                    .primary : Colors.transparent),
                                                          ),
                                                        ),
                                                        const Gap(10),
                                                        Text(
                                                          "${list[idx].item}",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: list[idx].isCheck == true ? Colors.grey : Theme
                                                                  .of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                              decoration:
                                                              list[idx].isCheck == true ? TextDecoration.lineThrough : TextDecoration.none),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuButton(
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder: (context) =>
                                                    [
                                                      const PopupMenuItem(
                                                          value: "edit",
                                                          child: Text(
                                                            "수정",
                                                          )),
                                                      const PopupMenuItem(
                                                          value: "delete",
                                                          child: Text(
                                                            "삭제",
                                                          )),
                                                    ],
                                                    onSelected: (value) {
                                                      switch (value) {
                                                        case "edit":
                                                          _controller.text = list[idx].item!;
                                                          _itemEditDialog(context, idx);
                                                        case "delete":
                                                          context.read<SuppliesProvider>().removeItem(idx, widget.planId);
                                                      }
                                                    },
                                                  )
                                                ],
                                              )),
                                        );
                                      },
                                      separatorBuilder: (context, idx) => const Gap(5),
                                      itemCount: list.length),
                                )),
                          ],
                        ),
                      ),
                    ),
              ),
              if (_isLoaded && _admobUtil.bannerAd != null)
                SizedBox(
                  height: _admobUtil.bannerAd!.size.height.toDouble(),
                  width: _admobUtil.bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: _admobUtil.bannerAd!),
                )
            ]),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   foregroundColor: Theme.of(context).colorScheme.surface,
        //   backgroundColor: Theme.of(context).colorScheme.secondary,
        //   onPressed: () {
        //     _itemAddDialog(context);
        //   },
        //   child: const Center(
        //     child: Icon(
        //       Icons.add,
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Future<dynamic> _suppliesTemplateDialog(BuildContext context, List<SupplyModel> list) {
    // final tempList = context.watch<SuppliesTemplateProvider>().tempList;
    return showDialog(
        context: context,
        builder: (context) =>
            Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              surfaceTintColor: Theme
                  .of(context)
                  .colorScheme
                  .surface,
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              child: Text(
                                "템플릿 추가 & 선택",
                                style: TextStyle(color: Color(0xff666666), fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Gap(5),
                            Consumer<SuppliesTemplateProvider>(builder: (context, temp, Widget? child) {
                              return SizedBox(
                                child: Text("(${temp.tempList!.length} / 2)"),
                              );
                            })
                          ],
                        ),
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTemplatePage()));
                            },
                            style: IconButton.styleFrom(padding: EdgeInsets.zero),
                            label: const Text("생성"),
                            icon: const Icon(Icons.add),
                          ),
                        )
                      ]),
                    ),
                    const Divider(),
                    Consumer<SuppliesTemplateProvider>(builder: (context, temp, child) {
                      final isDarkMode = context
                          .read<ThemeModeProvider>()
                          .isDarkMode;
                      if (temp.tempList!.isEmpty) {
                        return const SizedBox(
                            height: 160,
                            child: Center(
                              child: Text("템플릿을 생성 할 수 있습니다."),
                            ));
                      }
                      return SizedBox(
                          height: 160,
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, idx) {
                                return SizedBox(
                                  height: 60,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (temp.selectedList == temp.tempList![idx].temp) {
                                          temp.selectTempList(null);
                                          return;
                                        }
                                        temp.selectTempList(temp.tempList![idx].temp);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: temp.selectedList == temp.tempList![idx].temp
                                              ? Theme
                                              .of(context)
                                              .colorScheme
                                              .surface
                                              : Theme
                                              .of(context)
                                              .colorScheme
                                              .onSurface
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 16,
                                                  width: 16,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: const Color(0xff666666)),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color: temp.selectedList == temp.tempList![idx].temp ? Colors.white : Colors.transparent),
                                                        shape: BoxShape.circle,
                                                        color:
                                                        temp.selectedList == temp.tempList![idx].temp! ? Theme
                                                            .of(context)
                                                            .colorScheme
                                                            .primary : Colors.transparent),
                                                  ),
                                                ),
                                                const Gap(10),
                                                SizedBox(
                                                  child: Text(temp.tempList![idx].tempTitle!, style: TextStyle(
                                                      color: temp.selectedList == temp.tempList![idx].temp
                                                          ? Theme
                                                          .of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          : Theme
                                                          .of(context)
                                                          .colorScheme
                                                          .surface),),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              child: PopupMenuButton(
                                                  iconColor: temp.selectedList == temp.tempList![idx].temp
                                                      ? Theme
                                                      .of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      : Theme
                                                      .of(context)
                                                      .colorScheme
                                                      .surface,
                                                  onSelected: (value) {
                                                    if (value == "수정") {
                                                      Navigator.push(
                                                          context, MaterialPageRoute(
                                                          builder: (context) => AddTemplatePage(temp: temp.tempList![idx].temp, idx: idx,)));
                                                    } else {
                                                      context.read<SuppliesTemplateProvider>().removeTemplate(idx);
                                                    }
                                                  }, itemBuilder: (context) {
                                                return <PopupMenuEntry<String>>[
                                                  const PopupMenuItem(value: "수정", child: Text("수정")),
                                                  const PopupMenuItem(value: "삭제", child: Text("삭제")),
                                                ];
                                              }))
                                        ],
                                      )),
                                  // child: Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     SizedBox(
                                  //         child: Text(temp.tempList![idx].tempTitle!, style: const TextStyle(fontSize: 16),)),
                                  //     SizedBox(
                                  //       child: PopupMenuButton(
                                  //         onSelected: (value){
                                  //           if(value == "수정"){
                                  //             Navigator.push(context,
                                  //                 MaterialPageRoute(builder: (context)=> AddTemplatePage(temp:temp.tempList![idx].temp)));
                                  //           }else {
                                  //             context.read<SuppliesTemplateProvider>().removeTemplate(idx);
                                  //           }
                                  //         },
                                  //           itemBuilder: (context) {
                                  //         return  <PopupMenuEntry<String>> [
                                  //           const PopupMenuItem(value: "수정", child: Text("수정")),
                                  //           const PopupMenuItem(value: "삭제", child: Text("삭제")),
                                  //         ];
                                  //       })
                                  //     )
                                  //   ],
                                  // )
                                );
                              },
                              separatorBuilder: (context, idx) => const Gap(10),
                              itemCount: temp.tempList!.length));
                    }),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () {
                                  context.read<SuppliesTemplateProvider>().selectTempList(null);
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text("닫기")),
                          ),
                          const Gap(10),
                          SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  final selected = context.read<SuppliesTemplateProvider>().selectedList;
                                  if (selected.isEmpty) {
                                    Get.snackbar("탬플릿 선택", "추가 할 탬플릿을 선택해 주세요.",
                                        backgroundColor: Theme.of(context).colorScheme.surface);
                                    return;
                                  }
                                  context.read<SuppliesProvider>().addTemplateList(selected, widget.planId);
                                  context.read<SuppliesTemplateProvider>().selectTempList(null);
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "추가하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<dynamic> _itemAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) =>
            Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              surfaceTintColor: Colors.white12,
              child: SizedBox(
                width: 600,
                height: 200,
                child: Column(
                  children: [
                    Stack(children: [
                      const SizedBox(
                        width: 600,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "목록 추가",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ))
                    ]),
                    const Divider(),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 30,
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              onChanged: _onChanged,
                              style: const TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text("닫기")),
                          ),
                          const Gap(10),
                          SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_controller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("항목을 입력해 주세요")));
                                    return;
                                  }
                                  SupplyModel item = SupplyModel(item: _controller.text, isCheck: false);
                                  context.read<SuppliesProvider>().addItem(item, widget.planId);
                                  _controller.text = "";
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "추가하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<dynamic> _itemEditDialog(BuildContext context, int idx) {
    return showDialog(
        context: context,
        builder: (context) =>
            Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: 600,
                height: 200,
                child: Column(
                  children: [
                    Stack(children: [
                      const SizedBox(
                        width: 600,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "목록 추가",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ))
                    ]),
                    const Divider(),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 30,
                            child: TextField(
                              controller: _controller,
                              onChanged: _onChanged,
                              style: const TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_controller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("항목을 입력해 주세요")));
                                    return;
                                  }
                                  String item = _controller.text;
                                  context.read<SuppliesProvider>().editItem(idx, item, widget.planId);
                                  _controller.text = "";
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "수정하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
