import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../domain/entities/provider/admob_provider.dart';
import '../../domain/entities/provider/images_provider.dart';
import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../util/admob_util.dart';

class AirTicketPage extends StatefulWidget {
  final int planId;

  const AirTicketPage({super.key, required this.planId});

  @override
  State<AirTicketPage> createState() => _AirTicketPageState();
}

class _AirTicketPageState extends State<AirTicketPage> {
  ImagePicker picker = ImagePicker();

  final logger = Logger();
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;

  late final PdfViewerController _pdfDepartureController = PdfViewerController();
  late final PdfViewerController _pdfArrivalController = PdfViewerController();

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
    _admobUtil.dispose();
    _pdfDepartureController.dispose();
    _pdfArrivalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final double bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("항공권(E-ticket)"),
        ),
        body: Container(
          height: height,
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraint) => SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: height - bannerHei - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (height - bannerHei - 40) / 2, child: _departureSection(context, isDarkMode)),
                    SizedBox(height: (height - bannerHei - 40) / 2, child: _arrivalSection(context, isDarkMode))
                  ],
                ),
              ),
            ),
            if (_isLoaded && _admobUtil.bannerAd != null)
              SizedBox(
                height: _admobUtil.bannerAd!.size.height.toDouble(),
                width: _admobUtil.bannerAd!.size.width.toDouble(),
                child: _admobUtil.getBannerAdWidget(),
              )
          ]),
        ),
      ),
    );
  }

  Widget _departureSection(BuildContext context, isDarkMode) {
    final list = context.watch<ImagesProvider>().departureImg;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton.icon(
            onPressed: () {
              _showImageSourceDialog("departure", isDarkMode);
            },
            style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
            label: Text(
              "출발(Departure) 이미지 추가",
              style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
            ),
            icon: Icon(Icons.flight_takeoff, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Container(
              child: list.isEmpty
                  ? const SizedBox(
                      child: Center(
                        child: Text("출발(Departure) E-Ticket 등록해 보세요."),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemBuilder: (context, idx) {
                        return Stack(children: [
                          GestureDetector(
                            onTap: () {
                              if (list[idx].path.contains("pdf")) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text("PDF Viewer"),
                                        ),
                                        body: SizedBox(child: SfPdfViewer.file(File(list[idx].path)))),
                                  ),
                                );
                              } else {
                                OpenFile.open(list[idx].path);
                              }
                            },
                            child: SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: list[idx].path.contains("pdf")
                                    ? AbsorbPointer(
                                        // 클릭/스크롤 막기
                                        child: SfPdfViewer.file(
                                        File(list[idx].path),
                                        controller: _pdfDepartureController,
                                        canShowPaginationDialog: false,
                                        canShowScrollHead: false,
                                        enableTextSelection: false,
                                        pageLayoutMode: PdfPageLayoutMode.single,
                                        scrollDirection: PdfScrollDirection.vertical,
                                        initialScrollOffset: const Offset(0, 0),
                                        enableDocumentLinkAnnotation: false,
                                        enableHyperlinkNavigation: false,
                                        onDocumentLoaded: (details) {
                                          _pdfDepartureController.jumpToPage(1);
                                        },
                                      ))
                                    : AspectRatio(
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
                                      context.read<ImagesProvider>().removeDepartureImage(list[idx], widget.planId);
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
                    )),
        )
      ],
    );
  }

  Widget _arrivalSection(BuildContext context, bool isDarkMode) {
    final list = context.watch<ImagesProvider>().arrivalImg;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton.icon(
            onPressed: () {
              _showImageSourceDialog("arrival", isDarkMode);
            },
            style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
            label: Text(
              "도착(Arrival) 이미지 추가",
              style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
            ),
            icon: Icon(Icons.flight_land, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Container(
              child: list.isEmpty
                  ? const SizedBox(
                      child: Center(
                        child: Text("도착(Arrival) E-Ticket 등록해 보세요."),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemBuilder: (context, idx) {
                        return Stack(children: [
                          GestureDetector(
                            onTap: () {
                              if (list[idx].path.contains("pdf")) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: const Text("PDF Viewer"),
                                        ),
                                        body: SizedBox(child: SfPdfViewer.file(File(list[idx].path)))),
                                  ),
                                );
                              } else {
                                OpenFile.open(list[idx].path);
                              }
                            },
                            child: SizedBox(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: list[idx].path.contains("pdf")
                                    ? AbsorbPointer(
                                        // 클릭/스크롤 막기
                                        child: SfPdfViewer.file(
                                        File(list[idx].path),
                                        controller: _pdfArrivalController,
                                        canShowPaginationDialog: false,
                                        canShowScrollHead: false,
                                        enableTextSelection: false,
                                        pageLayoutMode: PdfPageLayoutMode.single,
                                        scrollDirection: PdfScrollDirection.vertical,
                                        initialScrollOffset: const Offset(0, 0),
                                        enableDocumentLinkAnnotation: false,
                                        enableHyperlinkNavigation: false,
                                        onDocumentLoaded: (details) {
                                          _pdfArrivalController.jumpToPage(1);
                                        },
                                      ))
                                    : AspectRatio(
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
                                      context.read<ImagesProvider>().removeArrivalImage(list[idx], widget.planId);
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
                    )),
        )
      ],
    );
  }

  void _showImageSourceDialog(String type, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
        return Dialog(
            insetPadding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 300,
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final XFile? image = await picker.pickImage(source: ImageSource.camera); // 카메라에서 이미지 선택
                        if (image != null && context.mounted) {
                          if (type == "departure") {
                            final list = context.read<ImagesProvider>().departureImg;
                            if (kReleaseMode && list.isNotEmpty && !isRemove) {
                              context.read<AdmobProvider>().loadAdInterstitialAd();
                              context.read<AdmobProvider>().showInterstitialAd();
                            }
                            context.read<ImagesProvider>().addDepartureImage(image, null, widget.planId);
                          } else if (type == "arrival") {
                            final list = context.read<ImagesProvider>().arrivalImg;
                            if (kReleaseMode && list.isNotEmpty && !isRemove) {
                              context.read<AdmobProvider>().loadAdInterstitialAd();
                              context.read<AdmobProvider>().showInterstitialAd();
                            }
                            context.read<ImagesProvider>().addArrivalImage(image, null, widget.planId);
                          }
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        } else {
                          Get.snackbar("카메라 이미지 오류", "알 수 없는 이유로 이미지를 불러오지 못했습니다.");
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                      label: Text(
                        "카메라",
                        style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                      ),
                      icon: Icon(
                        Icons.camera_alt,
                        color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
                        if (image != null && context.mounted) {
                          if (type == "departure") {
                            final list = context.read<ImagesProvider>().departureImg;
                            if (kReleaseMode && list.isNotEmpty && !isRemove) {
                              context.read<AdmobProvider>().loadAdInterstitialAd();
                              context.read<AdmobProvider>().showInterstitialAd();
                            }
                            context.read<ImagesProvider>().addDepartureImage(image, null, widget.planId);
                          } else if (type == "arrival") {
                            final list = context.read<ImagesProvider>().arrivalImg;
                            if (kReleaseMode && list.isNotEmpty && !isRemove) {
                              context.read<AdmobProvider>().loadAdInterstitialAd();
                              context.read<AdmobProvider>().showInterstitialAd();
                            }
                            context.read<ImagesProvider>().addArrivalImage(image, null, widget.planId);
                          }
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        } else {
                          Get.snackbar("이미지 불러오기 실패", "알 수 없는 문제로 이미지 불러오기 실패.");
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                      label: Text(
                        "갤러리",
                        style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                      ),
                      icon: Icon(
                        Icons.camera,
                        color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf', 'doc'],
                        );

                        if (result != null && context.mounted) {
                          if (type == "departure") {
                            final list = context.read<ImagesProvider>().departureImg;
                            if (kReleaseMode && list.isNotEmpty && !isRemove) {
                              context.read<AdmobProvider>().loadAdInterstitialAd();
                              context.read<AdmobProvider>().showInterstitialAd();
                            }
                            context.read<ImagesProvider>().addDepartureImage(null, result.files, widget.planId);
                          } else if (type == "arrival") {
                            final list = context.read<ImagesProvider>().arrivalImg;
                            if (kReleaseMode && list.isNotEmpty && !isRemove) {
                              context.read<AdmobProvider>().loadAdInterstitialAd();
                              context.read<AdmobProvider>().showInterstitialAd();
                            }
                            context.read<ImagesProvider>().addArrivalImage(null, result.files, widget.planId);
                          }
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                        }else{
                          Get.snackbar("파일 불러오기 실패", "알 수 없는 문제로 파일 불러오기 실패.");
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                      label: Text(
                        "파일",
                        style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                      ),
                      icon: Icon(
                        Icons.file_copy,
                        color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? const Color(0xff007AFF) : Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text(
                        "취소",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
