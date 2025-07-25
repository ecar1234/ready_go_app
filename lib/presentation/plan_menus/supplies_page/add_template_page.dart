import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/data/models/supply_model/template_model.dart';
import 'package:ready_go_project/domain/entities/provider/supplies_template_provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ready_go_project/util/localizations_util.dart';

import '../../../domain/entities/provider/admob_provider.dart';
import '../../../domain/entities/provider/purchase_manager.dart';
import '../../../domain/entities/provider/responsive_height_provider.dart';

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
  final _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  final logger = Logger();
  List<String> _tempList = [];

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

    if (widget.temp != null) {
      _tempList = widget.temp!.map((item) => item.item!).toList();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _admobUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    final hei = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final double bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
    final isKor = Localizations.localeOf(context).languageCode == "ko";
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createTemplate),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: hei,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: hei - bannerHei - 50,
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
                                AppLocalizations.of(context)!.addTemplateItemTitle,
                                style: LocalizationsUtil.setTextStyle(isKor,
                                    color: isDarkMode ? Colors.white : Colors.black87, size: 18, fontWeight: FontWeight.w600),
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
                                              Get.snackbar(AppLocalizations.of(context)!.snackTitle, AppLocalizations.of(context)!.snackDetail("item"),
                                                backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                              );
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
                                            AppLocalizations.of(context)!.add,
                                            style: LocalizationsUtil.setTextStyle(isKor,
                                                color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
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
                            ? SizedBox(
                                child: Center(
                                  child: Text(AppLocalizations.of(context)!.addTemplateItemDesc),
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
                                              style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Colors.black87, size: 16, fontWeight: FontWeight.w500),
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
                                                  child: Text(
                                                    AppLocalizations.of(context)!.delete,
                                                    style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),
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
                                      backgroundColor: isDarkMode ? Theme.of(context).primaryColor : Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      side: isDarkMode ? const BorderSide(color: Colors.white) : null),
                                  child: Text(
                                    AppLocalizations.of(context)!.goBack,
                                    style: LocalizationsUtil.setTextStyle(isKor,
                                        color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
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
                                            bool isCreated = await _tempAddDialog(context, isDarkMode, isRemove, isKor);
                                            if (isCreated) {
                                              Get.back();
                                            }
                                          } else {
                                            if (kReleaseMode && !isRemove) {
                                              context.read<AdmobProvider>().loadAdInterstitialAd();
                                              context.read<AdmobProvider>().showInterstitialAd();
                                              context.read<SuppliesTemplateProvider>().changeTemplate(_tempList, widget.idx);
                                            }else {
                                              context.read<SuppliesTemplateProvider>().changeTemplate(_tempList, widget.idx);
                                            }
                                            Navigator.pop(context);
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text(
                                    widget.temp == null ? AppLocalizations.of(context)!.create : AppLocalizations.of(context)!.modify,
                                    style: LocalizationsUtil.setTextStyle(isKor, color: _tempList.isEmpty ? Colors.grey : Colors.white),
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
                    height: _admobUtil.bannerAd!.size.height.toDouble(),
                    width: _admobUtil.bannerAd!.size.width.toDouble(),
                    child: _admobUtil.getBannerAdWidget(),
                  )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<dynamic> _tempAddDialog(BuildContext context, bool isDarkMode, bool isRemove, bool isKor) async {
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
                      style: LocalizationsUtil.setTextStyle(isKor, size: 12),
                      decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.addTemplateName)),
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
                                  backgroundColor: isDarkMode ? Theme.of(context).primaryColor : Colors.white,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style:
                                    LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                              )),
                        ),
                        const Gap(10),
                        SizedBox(
                            height: 40,
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_tempTitleController.text.isEmpty) {
                                  Get.snackbar(AppLocalizations.of(context)!.snackTitle,
                                    AppLocalizations.of(context)!.snackCommonDetail,
                                    backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                  );
                                  return;
                                }
                                final temp = TemplateModel(tempTitle: _tempTitleController.text);
                                final list = _tempList.map((item) => SupplyModel(item: item, isCheck: false)).toList();
                                temp.temp = list;
                                final tempList = context.read<SuppliesTemplateProvider>().tempList;
                                if (kReleaseMode && !isRemove && tempList!.length == 1) {
                                  context.read<AdmobProvider>().loadAdInterstitialAd();
                                  context.read<AdmobProvider>().showInterstitialAd();
                                }
                                context.read<SuppliesTemplateProvider>().addTemplate(temp);
                                _tempTitleController.clear();
                                Navigator.of(context).pop(true);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Text(
                                AppLocalizations.of(context)!.add,
                                style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),
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
