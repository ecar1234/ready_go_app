import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';
import 'package:ready_go_project/domain/entities/provider/schedule_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ready_go_project/util/localizations_util.dart';

import '../../../domain/entities/provider/purchase_manager.dart';
import '../../../domain/entities/provider/responsive_height_provider.dart';
import '../../../domain/entities/provider/theme_mode_provider.dart';
import '../../../util/admob_util.dart';

class AddSchedulePage extends StatefulWidget {
  final ScheduleModel daySchedule;
  final int roundIdx;
  final int scheduleIdx;
  final String planId;
  const AddSchedulePage({super.key, required this.daySchedule, required this.roundIdx, required this.scheduleIdx, required this.planId});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {

  final _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  final logger = Logger();

  final TextEditingController _detailController = TextEditingController();
  List<String> details = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.daySchedule.details != null && widget.daySchedule.details!.isNotEmpty){
      details.addAll(widget.daySchedule.details!);
    }

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _admobUtil.dispose();
    _detailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    List<String> stringTimeList = widget.daySchedule.time!.split(":");
    Widget conversionTime = const SizedBox();
    if (int.parse(stringTimeList[0]) > 12) {
      conversionTime = RichText(
          text: TextSpan(
              text: "PM",
              style: TextStyle(
                  color: isDarkMode ? Theme.of(context).colorScheme.secondary : Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
              children: [
                TextSpan(
                    text: " ${int.parse(stringTimeList[0]) - 12}:${stringTimeList[1]}",
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 20))
              ]));
    }
    else {
      conversionTime = RichText(
          text: TextSpan(
              text: "AM",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
              children: [
                TextSpan(
                    text: " ${stringTimeList[0]}:${stringTimeList[1]}",
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 20))
              ]));
    }

    final isKor = Localizations.localeOf(context).languageCode == "ko";
    final localization = AppLocalizations.of(context)!;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title:  FittedBox(child: Text(localization.detailAndMemo)),),
      body:  GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            height: height - bannerHei,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDarkMode ? Colors.white : Colors.black87),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(localization.mainSchedule,
                                style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            conversionTime,
                            const Gap(10),
                            Text("${widget.daySchedule.title}",
                              style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                SizedBox(
                  height: 50,
                  // width: MediaQuery.sizeOf(context).width-80,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: SizedBox(
                          height: 50,
                          child: TextField(
                            controller: _detailController,
                            decoration: InputDecoration(
                                label: Text(
                                  localization.detailAndMemo,
                                  style: isKor ? null : LocalizationsUtil.setTextStyle(isKor),
                                )),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if(_detailController.text.isEmpty){
                                    Get.snackbar(localization.snackTitle, localization.snackDetail(localization.detailAndMemo),
                                      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                    );
                                    return;
                                  }
                                  details.add(_detailController.text);
                                  _detailController.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white
                              ),
                              child: Text(localization.add, style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),)),
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(10),
                Expanded(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width-40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: isDarkMode ? Colors.white : Colors.black87),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: details.isEmpty ?
                      SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(localization.detailDesc1, style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),),
                          Text(localization.detailDesc2, style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),),
                        ],
                      ))
                          : ListView.separated(
                          shrinkWrap: true ,
                          itemBuilder: (context, idx){
                            return SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${idx+1}. ${details[idx]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                  SizedBox(
                                    height: 30,
                                    width: 70,
                                    child: ElevatedButton(onPressed: (){
                                      setState(() {
                                        details.removeAt(idx);
                                      });
                                    }, style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      )
                                    ),
                                        child: Text(localization.delete, style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),)),
                                  )
                                ],
                              ),
                            );
                          }, separatorBuilder: (context, idx)=> const Gap(8), itemCount: details.length) ,
                    )),
                const Gap(10),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              _detailController.clear();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              side: isDarkMode ? const BorderSide(color: Colors.white) : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                            child: Text(localization.close, style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary ),)),
                      ),
                      const Gap(20),
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: ElevatedButton(onPressed: () {
                          context.read<ScheduleProvider>().addScheduleDetails(details, widget.roundIdx, widget.scheduleIdx, widget.planId);
                          Navigator.pop(context);
                        }, style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                            )
                        ),
                            child: Text(localization.add, style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),)),
                      )
                    ],
                  ),
                ),
                if (_isLoaded && _admobUtil.bannerAd != null)
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
}
