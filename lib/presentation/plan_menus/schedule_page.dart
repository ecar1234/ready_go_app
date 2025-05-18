import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/util/admob_util.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/theme_mode_provider.dart';

class SchedulePage extends StatefulWidget {
  final PlanModel plan;
  const SchedulePage({super.key, required this.plan});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  final logger = Logger();

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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _admobUtil.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;

    return DefaultTabController(
      length: 10,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("일정 관리"),
          ),
          body: Container(
            height: height - bannerHei,
            // padding: const EdgeInsets.all(20),
            // decoration: BoxDecoration(
            //   border: Border.all()
            // ),
            child: Column(
              children: [

                // Container(
                //   height: height - bannerHei - 60,
                //   decoration: BoxDecoration(
                //       border: Border.all()
                //   ),
                // ),
                // admob
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
    );
  }
}
