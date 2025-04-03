import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';

import '../domain/entities/provider/admob_provider.dart';
import '../domain/entities/provider/images_provider.dart';
import '../domain/entities/provider/responsive_height_provider.dart';
import '../util/admob_util.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AdmobProvider>().loadAdBanner());
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
    _admobUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final departureList = context.watch<ImagesProvider>().departureImg;
    // final arrivalList = context.watch<ImagesProvider>().arrivalImg;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _admobUtil.bannerAd!.size.height;
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
                // height: height - bannerHei - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: (height - bannerHei -40) / 2, child: _departureSection(context)),
                    SizedBox( height: (height - bannerHei- 40) / 2, child: _arrivalSection(context))
                  ],
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
    );
  }

  Widget _departureSection(BuildContext context) {
    final list = context.watch<ImagesProvider>().departureImg;
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton.icon(
            onPressed: () {
              _showImageSourceDialog("departure");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white
            ),
            label: Text("출발(Departure) 이미지 추가", style: TextStyle(color: isDarkMode? Colors.white : Theme.of(context).colorScheme.primary),),
            icon: Icon(Icons.flight_takeoff, color: isDarkMode? Colors.white : Theme.of(context).colorScheme.primary),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Container(
              child: list.isEmpty
                  ? const SizedBox(
                      child: Center(
                        child: Text("등록된 출발(Departure) 이미지가 없습니다."),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemBuilder: (context, idx) {
                        return Stack(children: [
                          GestureDetector(
                            onTap: () {
                              OpenFile.open(list[idx].path);
                            },
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: SizedBox(
                                child: Image.file(
                                  list[idx],
                                  fit: BoxFit.cover,
                                ),
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

  Widget _arrivalSection(BuildContext context) {
    final list = context.watch<ImagesProvider>().arrivalImg;
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width,
          child: ElevatedButton.icon(
            onPressed: () {
              _showImageSourceDialog("arrival");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white
            ),
            label: Text("도착(Arrival) 이미지 추가", style: TextStyle(color: isDarkMode? Colors.white : Theme.of(context).colorScheme.primary),),
            icon: Icon(Icons.flight_land, color: isDarkMode? Colors.white : Theme.of(context).colorScheme.primary),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Container(
              child: list.isEmpty
                  ? const SizedBox(
                      child: Center(
                        child: Text("등록된 도착(Arrival) 이미지가 없습니다."),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemBuilder: (context, idx) {
                        return Stack(children: [
                          GestureDetector(
                            onTap: () {
                              OpenFile.open(list[idx].path);
                            },
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: SizedBox(
                                child: Image.file(
                                  list[idx],
                                  fit: BoxFit.cover,
                                ),
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

  void _showImageSourceDialog(String type) {
    final imgProvider = context.read<ImagesProvider>();

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
                  if (type == "departure") {
                    imgProvider.addDepartureImage(image, widget.planId);
                  } else if (type == "arrival") {
                    imgProvider.addArrivalImage(image, widget.planId);
                  }
                }
              },
              child: const Text("카메라"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                final XFile? image = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택
                if (image != null) {
                  if (type == "departure") {
                    imgProvider.addDepartureImage(image, widget.planId);
                  } else if (type == "arrival") {
                    imgProvider.addArrivalImage(image, widget.planId);
                  }
                }
              },
              child: const Text("갤러리"),
            ),
          ],
        );
      },
    );
  }
}
