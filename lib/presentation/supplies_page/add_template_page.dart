import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/data/models/supply_model/template_model.dart';
import 'package:ready_go_project/domain/entities/provider/supplies_template_provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:ready_go_project/util/admob_util.dart';

class AddTemplatePage extends StatefulWidget {
  final List<SupplyModel>? temp;
  final int? idx;

  const AddTemplatePage({super.key, this.temp, this.idx});

  @override
  State<AddTemplatePage> createState() => _AddTemplatePageState();
}

class _AddTemplatePageState extends State<AddTemplatePage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _tempTitleController = TextEditingController();
  final admobUtil = AdmobUtil();
  bool _isLoaded = false;
  List<String> _tempList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    admobUtil.loadBannerAd(onAdLoaded: () {
      setState(() {
        _isLoaded = true;
      });
    }, onAdFailed: () {
      setState(() {
        _isLoaded = false;
      });
    });

    if (widget.temp != null) {
      _tempList = widget.temp!.map((item) => item.item!).toList();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    admobUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("템플릿 생성"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height - 120,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height - 260,
                // decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Text(
                              "템플릿 아이템 추가",
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: SizedBox(
                                    width: 260,
                                    child: TextField(
                                      controller: _textController,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (_textController.text.isEmpty) {
                                            Get.snackbar("준비물 확인.", "빈 값은 추가 할 수 없습니다.", backgroundColor: Theme.of(context).colorScheme.surface);
                                            return;
                                          }
                                          setState(() {
                                            _tempList.add(_textController.text);
                                          });
                                          _textController.clear();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        child: Text(
                                          "추가",
                                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(color: isDarkMode ? Colors.white : Colors.black87), borderRadius: BorderRadius.circular(10)),
                      child: _tempList.isEmpty
                          ? const SizedBox(
                              child: Center(
                                child: Text("템플릿을 추가해 보세요."),
                              ),
                            )
                          : Scrollbar(
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, idx) {
                                    return SizedBox(
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                              child: Text(
                                            "${idx + 1}.${_tempList[idx]}",
                                            style: TextStyle(
                                                color: isDarkMode ? Colors.white : Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
                                          )),
                                          SizedBox(
                                            height: 30,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _tempList.removeAt(idx);
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.black87,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                child: const Text(
                                                  "삭제",
                                                  style: TextStyle(color: Colors.white),
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, idx) => const Gap(10),
                                  itemCount: _tempList.length),
                            ),
                    )),
                    const Gap(20),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 120,
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "뒤로가기",
                                  style: TextStyle(color: Colors.black87),
                                )),
                          ),
                          const Gap(20),
                          SizedBox(
                            height: 50,
                            width: 120,
                            child: ElevatedButton(
                                onPressed: _tempList.isEmpty
                                    ? null
                                    : () async {
                                        if (widget.temp == null) {
                                          bool isCreated = await _tempAddDialog(context);
                                          if (isCreated) {
                                            Get.back();
                                          }
                                        } else {
                                          context.read<SuppliesTemplateProvider>().changeTemplate(_tempList, widget.idx);
                                          Navigator.pop(context);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(
                                  widget.temp == null ? "생성" : "수정",
                                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Gap(10),
              if (_isLoaded == true)
                SizedBox(
                  height: admobUtil.bannerAd!.size.height.toDouble(),
                  width: admobUtil.bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: admobUtil.bannerAd!),
                )
            ],
          ),
        ),
      ),
    ));
  }

  Future<dynamic> _tempAddDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            surfaceTintColor: Colors.white12,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 600,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    child: TextField(
                      controller: _tempTitleController,
                      autofocus: true,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
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
                                Navigator.of(context).pop(false);
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: const Text("취소")),
                        ),
                        const Gap(10),
                        SizedBox(
                            height: 40,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_tempTitleController.text.isEmpty) {
                                  Get.snackbar("템플릿 이름 입력", "템플릿 이름은 빈 값으로 입력 할 수 없습니다.");
                                  return;
                                }
                                final temp = TemplateModel(tempTitle: _tempTitleController.text);
                                final list = _tempList.map((item) => SupplyModel(item: item, isCheck: false)).toList();
                                temp.temp = list;
                                context.read<SuppliesTemplateProvider>().addTemplate(temp);
                                _tempTitleController.clear();
                                Navigator.of(context).pop(true);
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
          );
        });
  }
}
