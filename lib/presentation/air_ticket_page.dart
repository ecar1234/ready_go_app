import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../provider/admob_provider.dart';
import '../provider/images_provider.dart';

class AirTicketPage extends StatefulWidget {
  final int planId;

  const AirTicketPage({super.key, required this.planId});

  @override
  State<AirTicketPage> createState() => _AirTicketPageState();
}

class _AirTicketPageState extends State<AirTicketPage> {
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final departureList = context.watch<ImagesProvider>().departureImg;
    final arrivalList = context.watch<ImagesProvider>().arrivalImg;
    context.read<AdmobProvider>().loadAdBanner();
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraint) => SingleChildScrollView(
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: constraint.maxWidth <= 600 ? MediaQuery.sizeOf(context).height - 100 : null,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150, child: _departureSection(context, departureList)),
                  const Gap(20),
                  SizedBox(height: 150, child: _arrivalSection(context, arrivalList))
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
            log("banner is null on images page");
            return const SizedBox();
          }
        })
      ]),
    );
  }

  Widget _departureSection(BuildContext context, List<XFile> list) {
    final list = context.watch<ImagesProvider>().departureImg;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "출발(Departure)",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        SizedBox(
          width: list.isEmpty ? 100 : (list.length * 110) + 100,
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
                              return GestureDetector(
                                onTap: () {
                                  OpenFile.open(list[idx].path);
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all()),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(list[idx].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            context.read<ImagesProvider>().removeDepartureImage(list[idx], widget.planId);
                                          },
                                          icon: const Icon(Icons.close))),
                                ]),
                              );
                            },
                            separatorBuilder: (context, idx) => const Gap(10),
                            itemCount: list.length),
                      ),
                    ),
              SizedBox(
                  width: (list.length * 110) + 100 < MediaQuery.sizeOf(context).width ? 100 : 50,
                  height: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.white12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      onPressed: () async {
                        _showImageSourceDialog("departure");
                      },
                      child: const Icon(Icons.add)))
            ],
          ),
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
                  if(type == "departure"){
                    imgProvider.addDepartureImage(image, widget.planId);
                  }else if(type == "arrival"){
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

  Widget _arrivalSection(BuildContext context, List<XFile> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "도착(Arrival)",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        SizedBox(
          width: list.isEmpty ? 100 : (list.length * 110) + 100,
          height: 120,
          child: Row(
            children: [
              context.watch<ImagesProvider>().arrivalImg.isEmpty
                  ? const SizedBox()
                  : Expanded(
                      child: SizedBox(
                        height: 100,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, idx) {
                              return GestureDetector(
                                onTap: () {
                                  OpenFile.open(list[idx].path);
                                },
                                child: Stack(children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all()),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(list[idx].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            context.read<ImagesProvider>().removeArrivalImage(list[idx], widget.planId);
                                          },
                                          icon: const Icon(Icons.close))),
                                ]),
                              );
                            },
                            separatorBuilder: (context, idx) => const Gap(10),
                            itemCount: list.length),
                      ),
                    ),
              SizedBox(
                  width: (list.length * 110) + 100 < MediaQuery.sizeOf(context).width ? 100 : 50,
                  height: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.white12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      onPressed: () async {
                        _showImageSourceDialog("arrival");
                      },
                      child: const Icon(Icons.add)))
            ],
          ),
        )
      ],
    );
  }
}
