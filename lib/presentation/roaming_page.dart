import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';

import '../domain/entities/provider/admob_provider.dart';
import '../domain/entities/provider/roaming_provider.dart';

class RoamingPage extends StatefulWidget {
  final int planId;

  const RoamingPage({super.key, required this.planId});

  @override
  State<RoamingPage> createState() => _RoamingPageState();
}

class _RoamingPageState extends State<RoamingPage> {
  ImagePicker picker = ImagePicker();
  TextEditingController dpAddressController = TextEditingController();
  TextEditingController activeCodeController = TextEditingController();
  final logger = Logger();
  int? selectedValue;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dpAddressController.dispose();
    activeCodeController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<RoamingProvider>().imageList;
    final code = context.watch<RoamingProvider>().code;
    final address = context.watch<RoamingProvider>().dpAddress;
    final period = context.watch<RoamingProvider>().period ?? RoamingPeriodModel();

    context.read<AdmobProvider>().loadAdBanner();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("로밍 & ESIM"),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Stack(children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: constraints.maxWidth <= 600 ? MediaQuery.sizeOf(context).width : 600,
                height: MediaQuery.sizeOf(context).height - 100,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _voucherImageSection(context, list),
                      const Gap(10),
                      const Divider(),
                      _codeSection(context, address, code),
                      // _dpAddressSection(context, address),
                      // _activeCodeSection(context, code),
                      const Divider(),
                      const Gap(10),
                      _periodSection(context, period)
                    ],
                  ),
                ),
              ),
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
                logger.d("banner is null on roaming page");
                return const SizedBox();
              }
            })
          ]),
        ),
      ),
    );
  }

  Widget _voucherImageSection(BuildContext context, List<XFile>? list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "바우처 이미지",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        SizedBox(
          width: list!.isEmpty ? 100 : (list.length * 110) + 100,
          height: 120,
          child: Row(
            children: [
              list.isEmpty
                  ? const SizedBox()
                  : Expanded(
                      child: SizedBox(
                      height: 100,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, idx) {
                            return Stack(children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all()),
                                child: GestureDetector(
                                    onTap: () {
                                      OpenFile.open(list[idx].path);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(list[idx].path),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        context.read<RoamingProvider>().removeImage(list[idx], widget.planId);
                                      },
                                      icon: const Icon(Icons.close))),
                            ]);
                          },
                          separatorBuilder: (context, idx) => const Gap(10),
                          itemCount: list.length),
                    )),
              SizedBox(
                height: 100,
                width: (list.length * 110) + 100 < MediaQuery.sizeOf(context).width ? 100 : 50,
                child: ElevatedButton(
                    onPressed: () async {
                      await _showImageSourceDialog(context);
                      // final imgProvider = context.read<RoamingProvider>();
                      // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      // if (image != null) {
                      //   imgProvider.addImage(image, widget.planId);
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                        side: const BorderSide(color: Colors.white12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    child: const Icon(Icons.add)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _codeSection(BuildContext context, String? address, String? code) {
    return SizedBox(
      child: Column(
        children: [
          //title
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "활성화 코드",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                if ((code != null && code.isEmpty) || (address != null && address.isEmpty))
                  SizedBox(
                      height: 40,
                      child: TextButton(
                          onPressed: () {
                            _showSetCodeDialog(context);
                          },
                          child: const Text("입력하기")))
                else
                  SizedBox(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        _showSetCodeDialog(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text("수정하기"),
                    ),
                  ),
              ],
            ),
          ),
          const Gap(10),
          // info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "SM-DP주소",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (address != null && address.isNotEmpty)
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: () {
                                  // if (dpAddressController.text.isEmpty) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("SM-DP주소가 비어있습니다.")));
                                  //   return;
                                  // }
                                  Clipboard.setData(ClipboardData(text: dpAddressController.text));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text("SM-DP주소가 복사 되었습니다."), duration: Duration(milliseconds: 500)));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text("복사"),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actionsAlignment: MainAxisAlignment.center,
                                            content: const Text(
                                              "SM-DP주소를 삭제 하시겠습니까?",
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
                                style: TextButton.styleFrom(
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
              SizedBox(
                  child: Text(
                address != null && address.isNotEmpty ? address : "SM-DP 주소를 등록해 주세요",
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              const Gap(5),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "활성화 코드",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (code != null && code.isNotEmpty)
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: () {
                                  // if (activeCodeController.text.isEmpty) {
                                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("활성화 코드가 비어있습니다.")));
                                  //   return;
                                  // }
                                  Clipboard.setData(ClipboardData(text: activeCodeController.text));
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("활성화 코드가 복사 되었습니다.."),
                                    duration: Duration(milliseconds: 500),
                                  ));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text("복사"),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: const Text("활성화 코드를 삭제 하시겠습니까?", textAlign: TextAlign.center),
                                            actionsAlignment: MainAxisAlignment.center,
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
                                                        foregroundColor: Theme.of(context).colorScheme.onSecondary,
                                                        backgroundColor: Theme.of(context).colorScheme.secondary,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                    child: const Text("삭제")),
                                              )
                                            ],
                                          ));
                                },
                                style: TextButton.styleFrom(
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
              SizedBox(
                  child: Text(
                code != null && code.isNotEmpty ? code : "활성화 코드를 등록해 주세요",
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _periodSection(
    BuildContext context,
    RoamingPeriodModel period,
  ) {
    int? selectedValue = period.period ?? 0;
    DateTime startDate = period.startDate ?? DateTime.now();
    DateTime endDate = period.endDate ?? DateTime.now();
    DateTime now = DateTime.now();

    final useDuration = now.difference(startDate!);
    final remainDuration = endDate.difference(now);
    final totalDuration = endDate.difference(startDate!);

    return SizedBox(
      // height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            child: Row(
              children: [
                const Text(
                  "사용기간 설정",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const Gap(20),
                DropdownMenu(
                  enabled: period.isActive == null || period.isActive == false,
                  initialSelection: selectedValue,
                  width: 120,
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
                                  height: 150,
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
              ],
            ),
          ),
          const Gap(10),
          Row(
            children: [
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
              if (period.isActive == true)
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "시작: ${startDate.month}월 ${startDate.day}일 ${startDate.hour}시 ${startDate.minute}분",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "종료: ${endDate.month}월 ${endDate.day}일 ${endDate.hour}시 ${endDate.minute}분",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
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
              ],
            )
        ],
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final roamingProvider = context.read<RoamingProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("이미지 선택"),
          content: const Text("갤러리 또는 카메라 중 하나를 선택하세요."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                final XFile? image = await picker.pickImage(source: ImageSource.camera); // 카메라에서 이미지 선택
                if (image != null) {
                  roamingProvider.addImage(image, widget.planId);
                }
              },
              child: const Text("카메라"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                final XFile? image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
                if (image != null) {
                  roamingProvider.addImage(image, widget.planId);
                }
              },
              child: const Text("갤러리"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSetCodeDialog(BuildContext context) async {
    String? code = context.read<RoamingProvider>().code;
    String? address = context.read<RoamingProvider>().dpAddress;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          activeCodeController.text = code!;
          dpAddressController.text = address!;
          return SizedBox(
              height: MediaQuery.sizeOf(context).height / 2,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "활성화 정보 입력",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // address info
                    SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "SM-DP + 주소",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 80,
                            child: TextField(
                              controller: dpAddressController,
                              readOnly: true,
                              maxLength: 60,
                              onTap: () {
                                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                                final localPosition = renderBox.globalToLocal(Offset(0, MediaQuery.sizeOf(context).height));
                                logger.d("dp : ${localPosition.dy}");
                                showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(localPosition.dx, localPosition.dy + 50, localPosition.dx, localPosition.dy),
                                    items: [
                                      if (dpAddressController.text.isEmpty)
                                        PopupMenuItem(
                                            child: TextButton(
                                                onPressed: () async {
                                                  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                                  if (clipboardData != null && clipboardData.text != null) {
                                                    if (mounted) {
                                                      Provider.of<RoamingProvider>(context, listen: false)
                                                          .updateTempAddress(clipboardData.text ?? "");
                                                      dpAddressController.text = Provider.of<RoamingProvider>(context).tempAddress;
                                                    }
                                                  }
                                                  Get.back();
                                                },
                                                child: const Text("붙여넣기")))
                                      else
                                        PopupMenuItem(
                                            child: TextButton(
                                                onPressed: () {
                                                  dpAddressController.text = ""; // 올바른 할당 연산자 사용
                                                  Get.back();
                                                },
                                                child: const Text("삭제하기")))
                                    ]);
                              },
                              onChanged: _onChanged,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    //code info
                    SizedBox(
                      child: Column(
                        children: [
                          const SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "활성화 코드",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 80,
                            child: TextField(
                              controller: activeCodeController,
                              maxLength: 60,
                              readOnly: true,
                              onTap: () {
                                final RenderBox render = context.findRenderObject() as RenderBox;
                                final localPosition = render.globalToLocal(Offset(0, MediaQuery.sizeOf(context).height));
                                logger.d("code : ${localPosition.dy}");
                                showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(localPosition.dx, localPosition.dy + 150, localPosition.dx, localPosition.dy),
                                    items: [
                                      if (activeCodeController.text.isEmpty)
                                        PopupMenuItem(
                                            child: TextButton(
                                                onPressed: () async {
                                                  final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                                  if (clipboardData != null && clipboardData.text != null) {
                                                    if (mounted) {
                                                      Provider.of<RoamingProvider>(context, listen: false).updateTempCode(clipboardData.text ?? "");
                                                      activeCodeController.text = Provider.of<RoamingProvider>(context).tempCode;
                                                    }
                                                  }
                                                  Get.back();
                                                },
                                                child: const Text("붙여넣기")))
                                      else
                                        PopupMenuItem(
                                            child: TextButton(
                                                onPressed: () {
                                                  Provider.of<RoamingProvider>(context, listen: false).updateTempCode("");
                                                  activeCodeController.text = Provider.of<RoamingProvider>(context).tempCode;
                                                  Get.back();
                                                },
                                                child: const Text("삭제하기")))
                                    ]);
                              },
                              onChanged: _onChanged,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Gap(10),
                    // button
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {
                            if (dpAddressController.text.isEmpty) {
                              Get.snackbar("입력정보 확인", "SM-DP 주소를 입력해 주세요",
                                  colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                              return;
                            }
                            if (activeCodeController.text.isEmpty) {
                              Get.snackbar("입력정보 확인", "활성화 코드를 입력해 주세요",
                                  colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                              return;
                            }

                            if (activeCodeController.text == code && dpAddressController.text == address) {
                              Get.snackbar("입력정보 확인", "변경 내용이 없습니다.",
                                  colorText: Theme.of(context).colorScheme.onSurface, backgroundColor: Theme.of(context).colorScheme.surface);
                              return;
                            }

                            try {
                              String newAddress = Provider.of<RoamingProvider>(context).tempAddress;
                              String newCode = Provider.of<RoamingProvider>(context).tempCode;
                              context.read<RoamingProvider>().enterCode(newAddress, newCode, widget.planId);
                              // context.read<RoamingProvider>().enterCode(newCode, widget.planId);
                            } on Exception catch (e) {
                              logger.e(e.toString());
                              rethrow;
                            }
                            Provider.of<RoamingProvider>(context, listen: false).updateTempCode("");
                            Provider.of<RoamingProvider>(context, listen: false).updateTempAddress("");
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              foregroundColor: Theme.of(context).colorScheme.surface,
                              backgroundColor: Theme.of(context).colorScheme.onSurface,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            "입력하기",
                            style: TextStyle(fontSize: 16),
                          )),
                    )
                  ],
                ),
              ));
        });
  }
}
