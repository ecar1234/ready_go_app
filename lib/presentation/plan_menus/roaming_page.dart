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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text("로밍(E-SIM)"),
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
                            _codeSection(context, roamingData!.activeCode ?? "", roamingData.dpAddress ?? "", isDarkMode),
                            // _dpAddressSection(context, address),
                            // _activeCodeSection(context, code),
                            const Gap(20),
                            _periodSection(context, roamingData.period!, isDarkMode),
                            const Gap(20),
                            _voucherImageSection(context, roamingData.imgList!, isDarkMode),
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

  Widget _voucherImageSection(BuildContext context, List<String> imgPath, bool isDarkMode) {
    List<File> list = imgPath.map((path) => File(path)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width - 40,
          child: ElevatedButton.icon(
              onPressed: () async {
                await _showImageSourceDialog(context, isDarkMode);
              },
              style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
              label: Text(
                "E-SIM 바우쳐 이미지 등록",
                style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
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
                          ? const SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  "🌠 바우처 QR 코드를 등록 할 수도 있어요.",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
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

  Widget _codeSection(BuildContext context, String code, String address, bool isDarkMode) {
    return SizedBox(
      child: Column(
        children: [
          //title
          SizedBox(
              height: 50,
              width: MediaQuery.sizeOf(context).width - 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSetCodeDialog(context, code, address, isDarkMode);
                },
                style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                label: Text(
                  "E-SIM 활성화 주소 입력",
                  style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
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
                            const Text(
                              "SM-DP주소",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            if (address.isNotEmpty)
                              SizedBox(
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
                                              const SnackBar(content: Text("SM-DP주소가 복사 되었습니다."), duration: Duration(milliseconds: 500)));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text("복사"),
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
                                                    content: const Text(
                                                      "SM-DP주소를 삭제 하시겠습니까?",
                                                      style: TextStyle(fontSize: 18),
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
                                                            child: const Text("취소")),
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
                                                          child: const Text("삭제"),
                                                        ),
                                                      )
                                                    ],
                                                  ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text("삭제"),
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      ),
                      //DP
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width - 40,
                          child: Text(
                            address.isNotEmpty ? address : "SM-DP 주소를 등록 할 수 있습니다.",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16),
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
                          const Text(
                            "활성화 코드",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          if (code.isNotEmpty)
                            SizedBox(
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
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("활성화 코드가 복사 되었습니다."),
                                          duration: Duration(milliseconds: 500),
                                        ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text("복사"),
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
                                                  content:
                                                      const Text("활성화 코드를 삭제 하시겠습니까?", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
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
                                                        child: const Text("취소"),
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
                                                          child: const Text(
                                                            "삭제",
                                                            style: TextStyle(color: Colors.white),
                                                          )),
                                                    )
                                                  ],
                                                ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text("삭제"),
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    const Gap(5),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width - 40,
                        child: Text(
                          code.isNotEmpty ? code : "활성화 코드를 등록 할 수 있습니다.",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
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

  Widget _periodSection(BuildContext context, RoamingPeriodModel period, bool isDarkMode) {
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
          const SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(
                  "사용기간 설정",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
                    return DropdownMenuEntry(value: idx, label: "기간 선택");
                  }
                  return DropdownMenuEntry(value: idx, label: "$idx일");
                }),
                onSelected: (value) {
                  if (period.isActive == true) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: const SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Text("사용시간을 변경하면 활성화된 데이터가"), Text(" 변경 될 수 있습니다."), Gap(10), Text("변경 하시겠습니까?")],
                                ),
                              ),
                              actions: [
                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        context.read<RoamingProvider>().setPeriodDate(period.period!, widget.planId);
                                        selectedValue = period.period;
                                      },
                                      child: const Text("취소")),
                                ),
                                SizedBox(
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        context.read<RoamingProvider>().setPeriodDate(value!, widget.planId);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("확인")),
                                )
                              ],
                            ));
                  } else {
                    if (value != null) {
                      context.read<RoamingProvider>().setPeriodDate(value, widget.planId);
                    }
                  }
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
                                      content: const SizedBox(
                                        height: 150,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [Text("데이터 초기화"), Text("사용 정보가 초가화 됩니다."), Gap(10), Text("변경 하시겠습니까?")],
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
                                              child: const Text("취소")),
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
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(("데이터가 초기화 되었습니다"))));
                                              },
                                              child: const Text("확인")),
                                        )
                                      ],
                                    ));
                          },
                          child: const Text(
                            "초기화",
                            style: TextStyle(color: Colors.black87, fontSize: 16),
                          )),
                    )
                  : SizedBox(
                      width: 80,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (period.period == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("사용기간을 설정 또는 재설정 해주세요")));
                              return;
                            }
                            context.read<RoamingProvider>().startPeriod(widget.planId);
                          },
                          child: Text(
                            "활성화",
                            style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 16),
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
                          ? Text("사용시간(분): ${useDuration.inMinutes}분")
                          : Text("사용시간(분): ${totalDuration.inMinutes}분"),
                      const Gap(10),
                      const Text("/"),
                      const Gap(10),
                      useDuration.inSeconds < totalDuration.inSeconds ? Text("잔여시간(분): ${remainDuration.inMinutes}분") : const Text("잔여시간(분): 사용완료")
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
                        "시작: ${startDate.month}월 ${startDate.day}일 ${startDate.hour}시 ${startDate.minute}분",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "종료: ${endDate.month}월 ${endDate.day}일 ${endDate.hour}시 ${endDate.minute - 1}분",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Future<void> _showImageSourceDialog(BuildContext context, bool isDarkMode) async {
    final roamingProvider = context.read<RoamingProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("이미지 선택"),
          content: const Text("갤러리 또는 카메라 중 하나를 선택하세요."),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                final XFile? image = await picker.pickImage(source: ImageSource.camera); // 카메라에서 이미지 선택
                if (image != null) {
                  roamingProvider.addImage(image, widget.planId);
                }
              },style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode?Theme.of(context).colorScheme.primary : Colors.white
            ),
              child: Text("카메라", style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                final XFile? image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
                if (image != null) {
                  roamingProvider.addImage(image, widget.planId);
                }
              },style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode?Theme.of(context).colorScheme.primary : Colors.white
            ),
              child: Text("갤러리", style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSetCodeDialog(BuildContext context, String? code, String? address, bool isDarkMode) async {
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
                            decoration: const InputDecoration(
                              labelText: "SM-DP 주소",
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 70,
                        child: TextField(
                          controller: activeCodeController,
                          decoration: const InputDecoration(
                            labelText: "활성화 코드",
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
                                  "닫기",
                                  style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                ))),
                        const Gap(10),
                        SizedBox(
                            height: 50,
                            width: 120,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (Platform.isIOS && dpAddressController.text.isEmpty) {
                                    Get.snackbar("SM-DP 주소가 빈 값 입니다.", "빈 값은 등록 할 수 없습니다.");
                                    return;
                                  }
                                  if (activeCodeController.text.isEmpty) {
                                    Get.snackbar("활성화 주소가 빈 값 입니다.", "빈 값은 등록 할 수 없습니다.");
                                    return;
                                  }
                                  if (Platform.isAndroid) {
                                    dpAddressController.text = "";
                                  }
                                  context.read<RoamingProvider>().enterCode(dpAddressController.text, activeCodeController.text, widget.planId);
                                  dpAddressController.clear();
                                  activeCodeController.clear();
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "등록",
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
