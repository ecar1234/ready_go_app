import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/provider/plan_list_provider.dart';
import 'package:ready_go_project/domain/entities/provider/responsive_height_provider.dart';
import 'package:ready_go_project/domain/entities/provider/schedule_provider.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:ready_go_project/util/date_util.dart';

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

  late List<bool> _isSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PlanModel planSchedule = context.read<PlanListProvider>().planList.firstWhere((plan) => plan.id == widget.plan.id);
    int days = DateUtil.datesDifference(planSchedule.schedule!);
    for(var i = 1; i <= days; i++){
      _isSelected.add(false);
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
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    final scheduleList = context.watch<ScheduleProvider>().scheduleList??[];
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("일정 관리"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: height - bannerHei,
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      scheduleList.isEmpty ?
                          const SizedBox(child: Text("데이터 없음"),)
                      : ToggleButtons(
                        children: [],
                        isSelected: _isSelected,
                        color: isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                        selectedColor: Colors.white,
                        fillColor: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
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
