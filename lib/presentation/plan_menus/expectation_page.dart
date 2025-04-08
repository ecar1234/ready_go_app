import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../util/admob_util.dart';

class ExpectationPage extends StatefulWidget {
  final int? planId;

  const ExpectationPage({super.key, required this.planId});

  @override
  State<ExpectationPage> createState() => _ExpectationPageState();
}

class _ExpectationPageState extends State<ExpectationPage> {
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("예상 경비"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: height * 0.4,
                color: Colors.deepPurpleAccent,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xff666666)))
                        ),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "목록",
                              style: TextStyle(color: Color(0xff666666), fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(
                              child: TextButton.icon(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero
                                ),
                                label: Text("추가"),
                                icon: Icon(Icons.add),
                                iconAlignment: IconAlignment.end,
                              ),
                            ),
                          ],
                        ))
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
    ));
  }
}
