import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';
import 'package:ready_go_project/util/admob_util.dart';
import 'package:ready_go_project/util/date_util.dart';
import 'package:ready_go_project/util/localizations_util.dart';
import 'package:ready_go_project/util/nation_currency_unit_util.dart';
import 'package:uuid/uuid.dart';

import '../data/models/plan_model/plan_model.dart';
import '../domain/entities/provider/admob_provider.dart';
import '../domain/entities/provider/plan_list_provider.dart';
import '../domain/entities/provider/purchase_manager.dart';
import '../domain/entities/provider/responsive_height_provider.dart';
import '../l10n/app_localizations.dart';

class AddPlanPage extends StatefulWidget {
  final PlanModel? plan;

  const AddPlanPage({super.key, this.plan});

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  final logger = Logger();
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  bool _nationRead = true;
  TextEditingController nationController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  List<DateTime?> _dates = [];

  List<String> nationsKo = [
    "선택",
    "🇰🇷 대한민국",
    "🇯🇵 일본",
    "🇨🇳 중국",
    "🇹🇼 대만",
    "🇲🇳 몽골",
    "🇭🇰 홍콩",
    "🇹🇭 태국",
    "🇻🇳 베트남",
    "🇵🇭 필리핀",
    "🇰🇭 캄보디아",
    "🇱🇦 라오스",
    "🇲🇾 말레이시아",
    "🇸🇬 싱가포르",
    "🇮🇩 인도네시아",
    "🇲🇲 미얀마",
    "🇦🇺 호주",
    "🇳🇿 뉴질랜드",
    "🇮🇳 인도",
    "🇬🇧 영국",
    "🇫🇷 프랑스",
    "🇩🇪 독일",
    "🇪🇸 스페인",
    "🇵🇹 포르투칼",
    "🇮🇹 이탈리아",
    "🇬🇷 그리스",
    "🇹🇷 튀르키예",
    "🇨🇦 캐나다",
    "🇺🇸 미국",
    "🇲🇽 맥시코",
    "🇨🇴 콜롬비아",
    "🇧🇷 브라질",
    "🇦🇷 아르헨티나",
    "🇨🇱 칠레",
    "✈️ 기타"
  ];
  List<String> nationsEn = [
    "Select",
    "🇦🇷 Argentina",
    "🇦🇺 Australia",
    "🇧🇷 Brazil",
    "🇰🇭 Cambodia",
    "🇨🇦 Canada",
    "🇨🇱 Chile",
    "🇨🇳 China",
    "🇨🇴 Colombia",
    "🇫🇷 France",
    "🇩🇪 Germany",
    "🇬🇷 Greece",
    "🇭🇰 Hong Kong",
    "🇮🇳 India",
    "🇮🇩 Indonesia",
    "🇮🇹 Italy",
    "🇯🇵 Japan",
    "🇱🇦 Laos",
    "🇲🇾 Malaysia",
    "🇲🇳 Mongolia",
    "🇲🇲 Myanmar",
    "🇲🇽 Mexico",
    "🇳🇿 New Zealand",
    "🇵🇭 Philippines",
    "🇵🇹 Portugal",
    "🇸🇬 Singapore",
    "🇰🇷 South Korea",
    "🇪🇸 Spain",
    "🇸🇪 Sweden", // 🇸🇪 스웨덴이 없었지만 알파벳 순서 참고용 예시로 임의 추가 가능
    "🇹🇭 Thailand",
    "🇹🇷 Türkiye",
    "🇹🇼 Taiwan",
    "🇬🇧 United Kingdom",
    "🇺🇸 United States",
    "🇻🇳 Vietnam",
    "✈️ Others"
  ];
  List<String> nationsJa = [
    "選択",
    "🇰🇷 韓国",
    "🇯🇵 日本",
    "🇨🇳 中国",
    "🇹🇼 台湾",
    "🇲🇳 モンゴル",
    "🇭🇰 香港",
    "🇹🇭 タイ",
    "🇻🇳 ベトナム",
    "🇵🇭 フィリピン",
    "🇰🇭 カンボジア",
    "🇱🇦 ラオス",
    "🇲🇾 マレーシア",
    "🇸🇬 シンガポール",
    "🇮🇩 インドネシア",
    "🇲🇲 ミャンマー",
    "🇦🇺 オーストラリア",
    "🇳🇿 ニュージーランド",
    "🇮🇳 インド",
    "🇬🇧 イギリス",
    "🇫🇷 フランス",
    "🇩🇪 ドイツ",
    "🇪🇸 スペイン",
    "🇵🇹 ポルトガル",
    "🇮🇹 イタリア",
    "🇬🇷 ギリシャ",
    "🇹🇷 トルコ",
    "🇨🇦 カナダ",
    "🇺🇸 アメリカ合衆国",
    "🇲🇽 メキシコ",
    "🇨🇴 コロンビア",
    "🇧🇷 ブラジル",
    "🇦🇷 アルゼンチン",
    "🇨🇱 チリ",
    "✈️ その他"
  ];

  // Timer? _debounce;
  //
  // _onChanged(String value) {
  //   if (_debounce?.isActive ?? false) {
  //     _debounce?.cancel();
  //   }
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     if (kDebugMode) {
  //       logger.d(value);
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.plan != null) {
      nationController.text = NationCurrencyUnitUtil.getNationFlag(widget.plan!.nation!);
      subjectController.text = widget.plan!.subject ?? "";
      _dates = widget.plan!.schedule!;
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
    nationController.dispose();
    subjectController.dispose();
    // _debounce?.cancel();
    _admobUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = context.read<PlanListProvider>().planList;
    final isDarkMode = context.read<ThemeModeProvider>().isDarkMode;
    final hei = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
    final double bannerHei = _isLoaded ? _admobUtil.bannerAd!.size.height.toDouble() : 0;
    final isKor = Localizations.localeOf(context).languageCode == "ko";
    final localization = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                localization.titleAddPlan,
                style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600),
              ),
              actions: [
                SizedBox(
                  width: 100,
                  // height: 50,
                  child: TextButton.icon(
                    onPressed: () {
                      if (widget.plan != null) {
                        if ((widget.plan!.nation! == nationController.text) &&
                            (widget.plan!.subject! == subjectController.text) &&
                            (widget.plan!.schedule! == _dates)) {
                          FocusManager.instance.primaryFocus!.unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("변경 사항이 존재 하지 않습니다."),
                            duration: Duration(seconds: 1),
                          ));
                          return;
                        }
                      }
                      if (nationController.text.isEmpty) {
                        FocusManager.instance.primaryFocus!.unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(localization.snackEmptyNation),
                          duration: const Duration(seconds: 1),
                        ));
                        return;
                      }
                      if (subjectController.text.isEmpty) {
                        FocusManager.instance.primaryFocus!.unfocus();
                        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                          content: Text(localization.snackEmptySubject),
                          duration: const Duration(seconds: 1),
                        ));
                        return;
                      }
                      if (_dates.length > 2 || _dates.isEmpty) {
                        FocusManager.instance.primaryFocus!.unfocus();
                        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                          content: Text(localization.snackEmptyPeriod),
                          duration: const Duration(seconds: 1),
                        ));
                        return;
                      }
                      if(nationController.text == localization.select){
                        FocusManager.instance.primaryFocus!.unfocus();
                        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                          content: Text(localization.snackEmptyNation),
                          duration: const Duration(seconds: 1),
                        ));
                        return;
                      }

                      try {
                        PlanModel plan = PlanModel();
                        if (widget.plan != null) {
                          plan
                            ..id = widget.plan!.id
                            ..schedule = _dates
                            ..nation = nationController.text.split(" ")[0]
                            ..subject = subjectController.text
                            ..favorites = widget.plan!.favorites
                            ..unit = NationCurrencyUnitUtil.getNationCurrency(nationController.text.split(" ")[0]);
                          // debugPrint(nationController.text);
                          // debugPrint("${plan.unit}");
                          context.read<PlanListProvider>().changePlan(plan);
                        } else {
                          plan
                            ..id = const Uuid().v4()
                            ..nation = nationController.text.split(" ")[0]
                            ..subject = subjectController.text
                            ..schedule = _dates
                            ..favorites = false
                            ..unit = NationCurrencyUnitUtil.getNationCurrency(nationController.text.split(" ")[0]);
                          // debugPrint(nationController.text);
                          // debugPrint("${plan.unit}");
                          context.read<PlanListProvider>().addPlanList(plan);
                          // logger.i(plan.nation);
                        }
                      } catch (ex) {
                        throw (ex).toString();
                      }
                      final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
                      if (kReleaseMode && !isRemove && list.isNotEmpty) {
                        context.read<AdmobProvider>().loadAdInterstitialAd();
                        context.read<AdmobProvider>().showInterstitialAd();
                      }
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    label: Text(
                      widget.plan != null ? localization.modify : localization.create,
                      style: LocalizationsUtil.setTextStyle(isKor,
                          size: 15, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Container(
                height: hei,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
                              child: SizedBox(
                                height: hei - bannerHei - 40,
                                width: constraints.maxWidth > 800 ? 700 : MediaQuery.sizeOf(context).width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _nationSelection(context, localization, isKor),
                                    const Gap(10),
                                    _titleSection(localization, isKor),
                                    const Gap(10),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                            // width: constraints.maxWidth <= 600 ? MediaQuery.sizeOf(context).width : 840,
                                            padding: const EdgeInsets.symmetric(vertical: 20),
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius: BorderRadius.circular(10),
                                                color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                                            child: _calendarSection(isDarkMode, hei, localization, isKor)),
                                      ),
                                    ),
                                    // const Gap(30),
                                    // create button
                                    // SizedBox(
                                    //   height: 50,
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       SizedBox(
                                    //         width: 150,
                                    //         height: 50,
                                    //         child: ElevatedButton(
                                    //           onPressed: () {
                                    //             if (widget.plan != null) {
                                    //               if (widget.plan!.nation! == nationController.text && widget.plan!.schedule! == _dates) {
                                    //                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    //                   content: Text("변경 사항이 존재 하지 않습니다."),
                                    //                   duration: Duration(seconds: 1),
                                    //                 ));
                                    //                 return;
                                    //               } else {}
                                    //             } else {
                                    //               if (nationController.text.isEmpty) {
                                    //                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    //                   content: Text("여행 제목을 입력해 주세요."),
                                    //                   duration: Duration(seconds: 1),
                                    //                 ));
                                    //                 return;
                                    //               }
                                    //               if (_dates.length > 2 || _dates.isEmpty) {
                                    //                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    //                   content: Text("일정을 선택해 주세요"),
                                    //                   duration: Duration(seconds: 1),
                                    //                 ));
                                    //                 return;
                                    //               }
                                    //             }
                                    //             try {
                                    //               PlanModel plan = PlanModel();
                                    //               if (widget.plan != null) {
                                    //                 plan
                                    //                   ..id = widget.plan!.id
                                    //                   ..schedule = _dates
                                    //                   ..nation = nationController.text
                                    //                   ..favorites = widget.plan!.favorites;
                                    //                 context.read<PlanListProvider>().changePlan(plan);
                                    //               } else {
                                    //                 plan
                                    //                   ..id = idNum + 1
                                    //                   ..nation = nationController.text
                                    //                   ..schedule = _dates
                                    //                   ..favorites = false;
                                    //                 context.read<PlanListProvider>().addPlanList(plan);
                                    //               }
                                    //             } catch (ex) {
                                    //               throw (ex).toString();
                                    //             }
                                    //             Navigator.pop(context);
                                    //           },
                                    //           style: ElevatedButton.styleFrom(
                                    //               backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
                                    //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    //           child: Text(
                                    //             widget.plan != null ? "수정" : "생성",
                                    //             style: TextStyle(
                                    //                 fontSize: 18,
                                    //                 fontWeight: FontWeight.w500,
                                    //                 color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            )),
                    if (_isLoaded && _admobUtil.bannerAd != null)
                      SizedBox(
                        height: _admobUtil.bannerAd!.size.height.toDouble(),
                        width: _admobUtil.bannerAd!.size.width.toDouble(),
                        child: _admobUtil.getBannerAdWidget(),
                      )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _nationSelection(BuildContext context, AppLocalizations localization, bool isKor) {
    List<String> nations = [];
    if (Localizations.localeOf(context).languageCode == "ko") {
      nations = nationsKo;
    } else if (Localizations.localeOf(context).languageCode == "en") {
      nations = nationsEn;
    } else {
      nations = nationsJa;
    }

    if (nationController.text.isEmpty) {
      nationController.text = nations[0];
    }
    if(widget.plan != null){
      nationController.text = nations.firstWhere((item) => item.contains(widget.plan!.nation!));
    }
    return SizedBox(
      // height: 90,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(localization.addNation, style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, size: 16)),
          ),
          const Gap(10),
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownMenu(
                    width: 200,
                    initialSelection: widget.plan == null
                        ? localization.select
                        : (nations.any((item) => item.contains(widget.plan!.nation!)) ? nations.firstWhere((item) => item.contains(widget.plan!.nation!)) : "✈️ ${localization.others}"),
                    trailingIcon: null,
                    menuHeight: 250,
                    onSelected: (selected) {
                      if (selected != null) {
                        if (selected == "✈️ ${localization.others}") {
                          nationController.text = localization.addNation;
                          setState(() {
                            _nationRead = false;
                          });
                        }
                        else if(selected == localization.select){
                          nationController.text = localization.select;
                          setState(() {
                            _nationRead = true;
                          });
                        }
                        else {
                          final nation = selected.split(" ")[1];
                          nationController.text = "$nation (${NationCurrencyUnitUtil.getNationCurrency(nation)})";
                          setState(() {
                            _nationRead = true;
                          });
                        }
                      }
                    },
                    dropdownMenuEntries: List.generate(nations.length, (int idx) {
                      if(idx == 0){
                        return DropdownMenuEntry(value: localization.select, label: localization.select);
                      }
                      return DropdownMenuEntry(value: nations[idx], label: nations[idx]);
                    })),
                const Gap(10),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      controller: nationController,
                      readOnly: _nationRead,
                      autofocus: _nationRead ? false : true,
                      style: GoogleFonts.notoSans(),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _titleSection(AppLocalizations localization, bool isKor) {
    return SizedBox(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.addTitle,
            style:
                isKor ? const TextStyle(fontWeight: FontWeight.w600, fontSize: 16) : GoogleFonts.notoSans(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const Gap(10),
          SizedBox(
            height: 50,
            child: TextField(
                controller: subjectController,
                // onChanged: _onChanged,
                decoration: InputDecoration(hintText: localization.addPlanHint, hintStyle: LocalizationsUtil.setTextStyle(isKor))),
          )
        ],
      ),
    );
  }

  Widget _calendarSection(bool isDarkMode, double hei, AppLocalizations localization, bool isKor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          localization.addPeriod,
          style: isKor ? const TextStyle(fontWeight: FontWeight.w600, fontSize: 16) : GoogleFonts.notoSans(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const Gap(10),
        LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
                height: hei * 0.3,
                width: constraints.maxWidth > 800 ? 640 : MediaQuery.sizeOf(context).width,
                child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                        firstDate: DateTime.now(),
                        firstDayOfWeek: 0,
                        calendarType: CalendarDatePicker2Type.range,
                        weekdayLabels: isKor ? ["일", "월", "화", "수", "목", "금", "토"] : ["Sun", "Mon", "Tue", "Wen", "Thu", "Fri", "Sat"],
                        selectedDayHighlightColor: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                    value: _dates,
                    onValueChanged: (list) => setState(() {
                          _dates = list;
                        })));
          },
        ),
        if (_dates.isNotEmpty)
          SizedBox(
              height: 20,
              child: Text(
                "${DateUtil.dateToString(_dates.first ?? DateTime.now())} "
                "~ ${DateUtil.dateToString(_dates.last ?? DateTime.now())}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ))
        else if (_dates.isEmpty)
          const SizedBox(
            height: 20,
          )
      ],
    );
  }
}
