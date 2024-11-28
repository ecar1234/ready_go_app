import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_departureSection(context, departureList), const Gap(20), _arrivalSection(context, arrivalList)],
        ),
      ),
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
          width: list.isEmpty ? 120 : list.length * 120 + 80,
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
                                onTap: (){
                                  OpenFile.open(list[idx].path);
                                },
                                child: Stack(children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      File(list[idx].path),
                                      fit: BoxFit.cover,
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
                  width: list.length < 3 ? 100 : 50,
                  height: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.white12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      onPressed: () async {
                        final imgProvider = context.read<ImagesProvider>();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imgProvider.addDepartureImage(image, widget.planId);
                        }
                      },
                      child: const Icon(Icons.add)))
            ],
          ),
        )
      ],
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
          width: list.isEmpty ? 120 : list.length * 120 + 80,
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
                                onTap: (){
                                  OpenFile.open(list[idx].path);
                                },
                                child: Stack(children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.file(
                                      File(list[idx].path),
                                      fit: BoxFit.cover,
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
                  width: list.length < 3 ? 100 : 50,
                  height: 100,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.white12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      onPressed: () async {
                        final imgProvider = context.read<ImagesProvider>();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imgProvider.addArrivalImage(image, widget.planId);
                        }
                      },
                      child: const Icon(Icons.add)))
            ],
          ),
        )
      ],
    );
  }
}
