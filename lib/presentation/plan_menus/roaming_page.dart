import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ready_go_project/util/localizations_util.dart';

import '../../domain/entities/provider/admob_provider.dart';
import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../domain/entities/provider/roaming_provider.dart';
import '../../util/admob_util.dart';

class RoamingPage extends StatefulWidget {
  final int planId;

  const RoamingPage({super.key, required this.planId});

  @override
  State<RoamingPage> createState() => _RoamingPageState();
}

class _RoamingPageState extends State<RoamingPage> {
  ImagePicker picker = ImagePicker();
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  TextEditingController dpAddressController = TextEditingController();
  TextEditingController activeCodeController = TextEditingController();
  final logger = Logger();
  int? selectedValue;

  // Timer? _debounce;

  // _onChanged(String value) {
  //   if (_debounce?.isActive ?? false) {
  //     _debounce?.cancel();
  //   }
  //   _debounce = Timer(const Duration(milliseconds: 500), () {});
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AdmobProvider>().loadAdBanner());
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
    dpAddressController.dispose();
    activeCodeController.dispose();
    _admobUtil.dispose();
    // _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final roamingData = context.watch<RoamingProvider>().roamingData;
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final double bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    final isKor = Localizations.localeOf(context).languageCode == "ko";
    final localization = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(localization.roamingTitle),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: height,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: height - bannerHei - 40,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _codeSection(context, localization, roamingData!.activeCode ?? "", roamingData.dpAddress ?? "", isDarkMode, isKor),
                            // _dpAddressSection(context, address),
                            // _activeCodeSection(context, code),
                            const Gap(20),
                            _periodSection(context, localization, roamingData.period!, isDarkMode, isKor),
                            const Gap(20),
                            _voucherImageSection(context, localization, roamingData.imgList!, isDarkMode, isKor),
                          ],
                        ),
                      ),
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
      ),
    );
  }

  Widget _voucherImageSection(BuildContext context, AppLocalizations localization, List<String> imgPath, bool isDarkMode, bool isKor) {
    List<File> list = imgPath.map((path) => File(path)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width - 40,
          child: ElevatedButton.icon(
              onPressed: () async {
                await _showImageSourceDialog(context, localization, isDarkMode, isKor);
              },
              style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
              label: Text(
                localization.addEsimImg,
                style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
              ),
              icon: Icon(Icons.image_search, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary)),
        ),
        const Gap(20),
        SizedBox(
          width: MediaQuery.sizeOf(context).width - 40,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      child: list.isEmpty
                          ? const SizedBox()
                          : GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                              itemBuilder: (context, idx) {
                                return Stack(children: [
                                  GestureDetector(
                                    onTap: () {
                                      OpenFile.open(list[idx].path);
                                    },
                                    child: SizedBox(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: AspectRatio(
                                            aspectRatio: 1.0,
                                            child: SizedBox(
                                                child: Image.file(
                                              list[idx],
                                              fit: BoxFit.cover,
                                            ))),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                                        child: IconButton(
                                            onPressed: () {
                                              context.read<RoamingProvider>().removeImage(list[idx], widget.planId);
                                            },
                                            style: IconButton.styleFrom(padding: EdgeInsets.zero),
                                            icon: const Icon(
                                              Icons.close,
                                              size: 15,
                                              color: Colors.black87,
                                            )),
                                      ))
                                ]);
                              },
                              itemCount: list.length,
                            ))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _codeSection(BuildContext context, AppLocalizations localization, String code, String address, bool isDarkMode, bool isKor) {
    return SizedBox(
      child: Column(
        children: [
          //title
          SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width - 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSetCodeDialog(context, localization, code, address, isDarkMode, isKor);
                },
                style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                label: Text(
                  localization.addEsimCode,
                  style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                ),
                icon: Icon(Icons.sim_card_outlined, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
              )),
          const Gap(20),
          // info
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: isDarkMode ? Colors.white : Colors.black87), borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //DP title & buttons
                if (Platform.isIOS)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: FittedBox(
                                child: Text(
                                  localization.dpAddressTitle,
                                  style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            if (address.isNotEmpty)
                              Flexible(
                                flex: 5,
                                child: SizedBox(
                                  height: 40,
                                  width: 220,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(text: dpAddressController.text));
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text(localization.copyDpAddress), duration: const Duration(milliseconds: 1000)));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: Text(localization.copy),
                                        ),
                                      ),
                                      const Gap(10),
                                      SizedBox(
                                        width: 80,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                      actionsAlignment: MainAxisAlignment.center,
                                                      content: Text(
                                                        localization.codeDeleteDesc,
                                                        style: LocalizationsUtil.setTextStyle(isKor, size: 18),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      actions: [
                                                        SizedBox(
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                                                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                              child: Text(localization.cancel)),
                                                        ),
                                                        SizedBox(
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              dpAddressController.text = "";
                                                              context.read<RoamingProvider>().removeAddress(widget.planId);
                                                              Navigator.of(context).pop();
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                                                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                            child: Text(localization.delete),
                                                          ),
                                                        )
                                                      ],
                                                    ));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: Text(localization.delete),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      //DP
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width - 40,
                          child: Text(
                            address.isNotEmpty ? address : localization.dpAddressDesc,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: LocalizationsUtil.setTextStyle(isKor, size: 16),
                          )),
                      const Gap(5),
                    ],
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 5,
                            child: FittedBox(
                              child: Text(
                                localization.activeCodeTitle,
                                style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          if (code.isNotEmpty)
                            Flexible(
                              flex: 5,
                              child: SizedBox(
                                height: 40,
                                width: 220,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: activeCodeController.text));
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(localization.copyActiveCode),
                                            duration: const Duration(milliseconds: 1000),
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text(localization.copy),
                                      ),
                                    ),
                                    const Gap(10),
                                    SizedBox(
                                      width: 80,
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    content: Text(localization.codeDeleteDesc,
                                                        style: LocalizationsUtil.setTextStyle(isKor, size: 18), textAlign: TextAlign.center),
                                                    actionsAlignment: MainAxisAlignment.center,
                                                    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                                                    actions: [
                                                      SizedBox(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor: Theme.of(context).colorScheme.surface,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                          child: Text(localization.cancel),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              activeCodeController.text = "";
                                                              context.read<RoamingProvider>().removeCode(widget.planId);
                                                              Navigator.of(context).pop();
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                            child: Text(
                                                              localization.delete,
                                                              style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),
                                                            )),
                                                      )
                                                    ],
                                                  ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text(localization.delete),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    const Gap(5),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width - 40,
                        child: Text(
                          code.isNotEmpty ? code : localization.activeCodeDesc,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: LocalizationsUtil.setTextStyle(isKor, size: 16),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodSection(BuildContext context, AppLocalizations localization, RoamingPeriodModel period, bool isDarkMode, bool isKor) {
    int? selectedValue = period.period ?? 0;
    DateTime startDate = period.startDate ?? DateTime.now();
    DateTime endDate = period.endDate ?? DateTime.now();
    DateTime now = DateTime.now();

    final useDuration = now.difference(startDate);
    final remainDuration = endDate.difference(now);
    final totalDuration = endDate.difference(startDate);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: isDarkMode ? Colors.white : Colors.black87), borderRadius: BorderRadius.circular(10)),
      // height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  localization.periodEsimTitle,
                  style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, size: 20),
                ),
              ],
            ),
          ),
          const Gap(5),
          Row(
            children: [
              DropdownMenu(
                enabled: period.isActive == null || period.isActive == false,
                initialSelection: selectedValue,
                width: 150,
                menuHeight: 300,
                dropdownMenuEntries: List.generate(31, (idx) {
                  if (idx == 0) {
                    return DropdownMenuEntry(value: idx, label: localization.selectPeriod);
                  }
                  return DropdownMenuEntry(value: idx, label: "$idx ${localization.days}");
                }),
                onSelected: (value) {
                  if (value != null) {
                    context.read<RoamingProvider>().setPeriodDate(value, widget.planId);
                  }
                  // if (period.isActive == true) {
                  //   showDialog(
                  //       context: context,
                  //       builder: (context) => AlertDialog(
                  //             content: const SizedBox(
                  //               height: 100,
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [Text("사용시간을 변경하면 활성화된 데이터가"), Text(" 변경 될 수 있습니다."), Gap(10), Text("변경 하시겠습니까?")],
                  //               ),
                  //             ),
                  //             actions: [
                  //               SizedBox(
                  //                 width: 120,
                  //                 height: 40,
                  //                 child: ElevatedButton(
                  //                     onPressed: () {
                  //                       Navigator.of(context).pop();
                  //                       context.read<RoamingProvider>().setPeriodDate(period.period!, widget.planId);
                  //                       selectedValue = period.period;
                  //                     },
                  //                     child: Text(localization.cancel)),
                  //               ),
                  //               SizedBox(
                  //                 width: 120,
                  //                 height: 40,
                  //                 child: ElevatedButton(
                  //                     onPressed: () {
                  //                       context.read<RoamingProvider>().setPeriodDate(value!, widget.planId);
                  //                       Navigator.of(context).pop();
                  //                     },
                  //                     child: Text(localization.confirm)),
                  //               )
                  //             ],
                  //           ));
                  // } else {
                  //   if (value != null) {
                  //     context.read<RoamingProvider>().setPeriodDate(value, widget.planId);
                  //   }
                  // }
                },
              ),
              const Gap(20),
              period.isActive == true
                  ? SizedBox(
                      width: 80,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.orangeAccent,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: SizedBox(
                                        height: 150,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(localization.resetInfo1),
                                            Text(localization.resetInfo2, textAlign: TextAlign.center,),
                                            const Gap(10),
                                            Text(localization.resetInfo3)
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        SizedBox(
                                          width: 120,
                                          height: 40,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                // context.read<RoamingProvider>().setPeriodDate(period.period!, widget.planId);
                                                // selectedValue = period.period;
                                              },
                                              child: Text(localization.cancel)),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          height: 40,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                // context.read<RoamingProvider>().setPeriodDate(value!, widget.planId);
                                                selectedValue = period.period;
                                                context.read<RoamingProvider>().resetPeriod(widget.planId);
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text((localization.resetCompleted))));
                                              },
                                              child: Text(localization.confirm)),
                                        )
                                      ],
                                    ));
                          },
                          child: Text(
                            localization.reset,
                            style: LocalizationsUtil.setTextStyle(isKor, color: Colors.black87, size: 16),
                          )),
                    )
                  : SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (period.period == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localization.startUsingSnack)));
                              return;
                            }
                            context.read<RoamingProvider>().startPeriod(widget.planId);
                          },
                          child: Text(
                            localization.startUsing,
                            style: LocalizationsUtil.setTextStyle(isKor, color: Theme.of(context).colorScheme.surface, size: 16),
                          )),
                    ),
              const Gap(10),
              // if (period.isActive == true)
            ],
          ),
          const Gap(10),
          if (period.isActive == true)
            Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      useDuration.inSeconds < totalDuration.inSeconds
                          ? Text("${localization.timeUsed}: ${useDuration.inMinutes} ${localization.min}")
                          : Text("${localization.timeUsed}: ${localization.end}"),
                      const Gap(10),
                      const Text("/"),
                      const Gap(10),
                      useDuration.inSeconds < totalDuration.inSeconds
                          ? Text("${localization.remainingTime}: ${remainDuration.inMinutes}${localization.min}")
                          : Text("${localization.remainingTime}: ${localization.end}")
                    ],
                  ),
                ),
                const Gap(10),
                SizedBox(
                  height: 20,
                  child: LinearProgressIndicator(
                    value: useDuration.inSeconds / totalDuration.inSeconds,
                    // 사용량을 비율로 변환
                    backgroundColor: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                    minHeight: 10,
                  ),
                ),
                const Gap(10),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${localization.start}: ${startDate.month}.${startDate.day} / ${startDate.hour}${localization.hour} ${startDate.minute}${localization.min}",
                        style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${localization.end}: ${endDate.month}.${endDate.day} / ${endDate.hour}${localization.hour} ${endDate.minute - 1}${localization.min}",
                        style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context, AppLocalizations localization, bool isDarkMode, bool isKore) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.select),
          content: Text(localization.selectContent),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                final XFile? image = await picker.pickImage(source: ImageSource.camera); // 카메라에서 이미지 선택
                if (image != null) {
                  if (context.mounted) {
                    context.read<RoamingProvider>().addImage(image, widget.planId);
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
              child: Text(
                localization.camera,
                style: LocalizationsUtil.setTextStyle(isKore, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final XFile? image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
                if (image != null) {
                  if (context.mounted) {
                    final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
                    if (kReleaseMode && !isRemove) {
                      context.read<AdmobProvider>().loadAdInterstitialAd();
                      context.read<AdmobProvider>().showInterstitialAd();
                    }
                    context.read<RoamingProvider>().addImage(image, widget.planId);
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
              child: Text(
                localization.gallery,
                style: LocalizationsUtil.setTextStyle(isKore, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSetCodeDialog(
      BuildContext context, AppLocalizations localization, String? code, String? address, bool isDarkMode, bool isKor) async {
    if (code != null) {
      activeCodeController.text = code;
    }
    if (address != null) {
      dpAddressController.text = address;
    }
    showDialog(
        context: context,
        builder: (context) => Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: Platform.isIOS ? MediaQuery.sizeOf(context).height * 0.3 : MediaQuery.sizeOf(context).height * 0.2,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      if (Platform.isIOS)
                        SizedBox(
                          height: 70,
                          child: TextField(
                            controller: dpAddressController,
                            decoration: InputDecoration(
                              labelText: localization.dpAddressTitle,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 70,
                        child: TextField(
                          controller: activeCodeController,
                          decoration: InputDecoration(
                            labelText: localization.activeCodeTitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 45,
                            width: 110,
                            child: ElevatedButton(
                                onPressed: () {
                                  dpAddressController.clear();
                                  activeCodeController.clear();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode ? Theme.of(context).primaryColor : Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(
                                  localization.close,
                                  style:
                                      LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                ))),
                        const Gap(10),
                        SizedBox(
                            height: 50,
                            width: 120,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (Platform.isIOS && dpAddressController.text.isEmpty) {
                                    Get.snackbar(localization.snackTitle, localization.snackDetail(localization.dpAddressTitle),
                                      backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                    );
                                    return;
                                  }
                                  if (activeCodeController.text.isEmpty) {
                                    Get.snackbar(localization.snackTitle, localization.snackDetail(localization.activeCodeTitle),
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                    );
                                    return;
                                  }
                                  if (Platform.isAndroid) {
                                    dpAddressController.text = "";
                                  }
                                  final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
                                  if (kReleaseMode && !isRemove) {
                                    context.read<AdmobProvider>().loadAdInterstitialAd();
                                    context.read<AdmobProvider>().showInterstitialAd();
                                  }

                                  context.read<RoamingProvider>().enterCode(dpAddressController.text, activeCodeController.text, widget.planId);
                                  dpAddressController.clear();
                                  activeCodeController.clear();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: Text(
                                  localization.add,
                                  style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
