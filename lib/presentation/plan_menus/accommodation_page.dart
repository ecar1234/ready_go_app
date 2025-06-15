import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:accordion/accordion.dart';
import 'package:ready_go_project/util/date_util.dart';
import 'package:ready_go_project/util/intl_utils.dart';
import 'package:ready_go_project/util/localizations_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../domain/entities/provider/accommodation_provider.dart';
import '../../domain/entities/provider/admob_provider.dart';
import '../../domain/entities/provider/purchase_manager.dart';
import '../../domain/entities/provider/responsive_height_provider.dart';
import '../../domain/entities/provider/theme_mode_provider.dart';
import '../../util/admob_util.dart';

class AccommodationPage extends StatefulWidget {
  final PlanModel plan;

  const AccommodationPage({super.key, required this.plan});

  @override
  State<AccommodationPage> createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<AccommodationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _bookingNumController = TextEditingController();
  final TextEditingController _bookingAppController = TextEditingController();
  final logger = Logger();
  final AdmobUtil _admobUtil = AdmobUtil();
  bool _isLoaded = false;
  Timer? _debounce;

  _onChangedCheckIn(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      logger.d(value);
    });
    if (int.parse(value) > 24) {
      _checkInController.text = "24";
    }
  }

  _onChangedCheckOut(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      logger.d(value);
    });
    if (int.parse(value) > 24) {
      _checkOutController.text = "24";
    }
  }

  Future<void> _openGoogleMap(String address) async {
    final String mapsUrl = "comgooglemaps://?q=${Uri.encodeComponent(address)}";
    final String webMapUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";

    if (await canLaunchUrl(Uri.parse(mapsUrl))) {
      // Google Maps 앱으로 열기
      await launchUrl(Uri.parse(mapsUrl));
      if (kDebugMode) {
        print("open maps app");
      }
    } else {
      // Google Maps 웹 브라우저로 열기
      await launchUrl(Uri.parse(webMapUrl), mode: LaunchMode.externalApplication);
      if (kDebugMode) {
        print("open web maps");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => context.read<AdmobProvider>().loadAdBanner());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kReleaseMode) {
        final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
        if (!isRemove) {
          context.read<AdmobProvider>().interstitialAd!.show();
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
    _nameController.dispose();
    _addressController.dispose();
    _periodController.dispose();
    _paymentController.dispose();
    _checkOutController.dispose();
    _checkInController.dispose();
    _bookingNumController.dispose();
    _bookingAppController.dispose();
    _debounce?.cancel();
    _admobUtil.dispose();
  }

  int getDaysOfMouth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    } else {
      return DateTime(year, month + 1, 0).day;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<AccommodationProvider>().accommodation;
    int month = widget.plan.schedule!.first!.month;
    int day = widget.plan.schedule!.first!.day;

    final isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    final height = GetIt.I.get<ResponsiveHeightProvider>().resHeight ?? MediaQuery.sizeOf(context).height - 120;
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
            title: FittedBox(child: Text(localization.accommodationTitle)),
            actions: [
              SizedBox(
                width: 100,
                child: TextButton.icon(
                    onPressed: () {
                      _addAccommodation(context, localization, month, day, height, isKor);
                    },
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    label: Text(
                      localization.add,
                      style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: Icon(Icons.add, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary)),
              )
            ],
          ),
          body: Container(
            height: height,
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
                    child: list?.isEmpty == true || list == null
                        ? SizedBox(
                            height: height - bannerHei - 170,
                            width: MediaQuery.sizeOf(context).width - 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.hotel),
                                    const Gap(5),
                                    Text(localization.accInfoDesc1,
                                        style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, size: 16)),
                                  ],
                                ),
                                const Gap(10),
                                Text(
                                  localization.accInfoDesc2,
                                  style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, size: 16),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: height - bannerHei - 50,
                            width: constraints.maxWidth <= 600 ? MediaQuery.sizeOf(context).width : 600,
                            child: SingleChildScrollView(child: _accordionSection(context, localization, list, isDarkMode, isKor)))),
              ),
              if (_isLoaded && _admobUtil.bannerAd != null)
                SizedBox(
                  height: _admobUtil.bannerAd!.size.height.toDouble(),
                  width: _admobUtil.bannerAd!.size.width.toDouble(),
                  child: _admobUtil.getBannerAdWidget(),
                )
            ]),
          ),
          // floatingActionButton: FloatingActionButton(
          //   foregroundColor: Theme.of(context).colorScheme.surface,
          //   backgroundColor: Theme.of(context).colorScheme.secondary,
          //   onPressed: () {
          //     _addAccommodation(context, month, day);
          //   },
          //   child: const Icon(Icons.add),
          // ),
        ),
      ),
    );
  }

  Future<void> _addAccommodation(BuildContext context, AppLocalizations localization, int month, int day, double hei, bool isKor) {
    // final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
    return showDialog(
        context: context,
        builder: (BuildContext diaContext) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Dialog(
              insetPadding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Container(
                  // height: hei * 0.8,
                  //width 는 LayoutBuilder 필요
                  // width: MediaQuery.sizeOf(context).width * 0.7,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // info field
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.addToInfo,
                              style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                            ),
                            const Gap(10),
                            // 숙소 이름
                            SizedBox(
                              height: 50,
                              child: TextField(
                                controller: _nameController,
                                // onChanged: _onChanged,
                                decoration: InputDecoration(
                                  label: Text(
                                    localization.accName,
                                    style: isKor ? null : LocalizationsUtil.setTextStyle(isKor),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            // 숙소 주소
                            SizedBox(
                              height: 50,
                              child: TextField(
                                controller: _addressController,
                                // onChanged: _onChanged,
                                decoration: InputDecoration(
                                  label: Text(
                                    localization.address,
                                    style: isKor ? null : LocalizationsUtil.setTextStyle(isKor),
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            // 금액
                            SizedBox(
                              height: 50,
                              child: TextField(
                                controller: _paymentController,
                                // onChanged: _onChanged,
                                maxLines: 1,
                                maxLength: 9,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                    label: Text(
                                      localization.amount,
                                      style: isKor ? null : LocalizationsUtil.setTextStyle(isKor),
                                    ),
                                    counterText: ""),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _paymentController.text = IntlUtils.stringIntAddComma(int.parse(value));
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const Gap(20),
                      // start Day
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.enterPeriod,
                              style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                            ),
                            const Gap(10),
                            SizedBox(
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  DropdownMenu(
                                    width: 110,
                                    menuHeight: 300,
                                    // enabled: false,
                                    menuStyle: const MenuStyle(
                                      visualDensity: VisualDensity.compact, // 밀도 조정
                                    ),
                                    initialSelection: month,
                                    onSelected: (value) {
                                      setState(() {
                                        month = value!;
                                      });
                                    },
                                    // selectedTrailingIcon: null,
                                    dropdownMenuEntries: [
                                      ...List.generate(
                                          12,
                                          (idx) => DropdownMenuEntry(
                                              value: idx + 1, label: DateUtil.getMonth(Localizations.localeOf(context).languageCode, idx + 1)))
                                    ],
                                  ),
                                  const Gap(10),
                                  DropdownMenu(
                                    width: 90,
                                    // enabled: false,
                                    menuStyle: const MenuStyle(
                                      visualDensity: VisualDensity.compact, // 밀도 조정
                                    ),
                                    initialSelection: day,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value! < day) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("여행 시작일 보다 이전의 날짜로 설정 할 수 없습니다.")));
                                          return;
                                        }
                                        if (value > widget.plan.schedule!.last!.day) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("여행 종료일 보다 이후 날짜로 설정 할 수 없습니다.")));
                                          return;
                                        }
                                        day = value;
                                      });
                                    },
                                    dropdownMenuEntries: [
                                      ...List.generate(getDaysOfMouth(widget.plan.schedule!.first!.year, month), (idx) {
                                        if (isKor) {
                                          return DropdownMenuEntry(value: idx + 1, label: "${idx + 1}일");
                                        } else {
                                          if (idx == 0) {
                                            return DropdownMenuEntry(value: idx + 1, label: "${idx + 1}");
                                          }
                                          return DropdownMenuEntry(value: idx + 1, label: "${idx + 1}");
                                        }
                                      })
                                    ],
                                  ),
                                  const Gap(10),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: TextField(
                                      controller: _periodController,
                                      // onChanged: _onChanged,
                                      maxLines: 1,
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      textAlign: TextAlign.end,
                                      decoration: InputDecoration(label: Text(localization.period, style: isKor ? null : LocalizationsUtil.setTextStyle(isKor),), counterText: ""),
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(localization.days)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      // options(checkIn/checkout)
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.checkInAndCheckout,
                              style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                            ),
                            const Gap(10),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                children: Localizations.localeOf(context).languageCode == "ko" || Localizations.localeOf(context).languageCode == "ja"
                                    ? [
                                        SizedBox(
                                          width: 80,
                                          child: TextField(
                                            controller: _checkInController,
                                            onChanged: _onChangedCheckIn,
                                            maxLines: 1,
                                            maxLength: 2,
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: const InputDecoration(
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                        const Gap(10),
                                        Text(localization.from),
                                        const Gap(10),
                                        SizedBox(
                                          width: 80,
                                          child: TextField(
                                            controller: _checkOutController,
                                            onChanged: _onChangedCheckOut,
                                            maxLines: 1,
                                            maxLength: 2,
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: const InputDecoration(
                                                counterText: "",
                                            ),
                                          ),
                                        ),
                                        const Gap(10),
                                        Text(localization.to)
                                      ]
                                    : [
                                        Text(localization.from),
                                        const Gap(10),
                                        SizedBox(
                                          width: 80,
                                          child: TextField(
                                            controller: _checkInController,
                                            onChanged: _onChangedCheckIn,
                                            maxLines: 1,
                                            maxLength: 2,
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: const InputDecoration(
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                        const Gap(10),
                                        Text(localization.to),
                                        const Gap(10),
                                        SizedBox(
                                          width: 80,
                                          child: TextField(
                                            controller: _checkOutController,
                                            onChanged: _onChangedCheckOut,
                                            maxLines: 1,
                                            maxLength: 2,
                                            textAlign: TextAlign.end,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            decoration: const InputDecoration(
                                                counterText: "",
                                            )
                                          ),
                                        ),
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      // booking info
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.reservationInfo,
                              style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                            ),
                            const Gap(10),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                controller: _bookingAppController,
                                decoration: InputDecoration(label: Text(localization.reservationApp, style: isKor ? null : LocalizationsUtil.setTextStyle(isKor),), counterText: ""),
                              ),
                            ),
                            const Gap(10),
                            SizedBox(
                              height: 50,
                              child: TextField(
                                controller: _bookingNumController,
                                decoration: InputDecoration(label: Text(localization.reservationNum, style: isKor ? null : LocalizationsUtil.setTextStyle(isKor),), counterText: ""),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Gap(20),
                      // buttons
                      SizedBox(
                        height: 50,
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0, side: const BorderSide(), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text(
                                    localization.close,
                                  )),
                            ),
                            const Gap(20),
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_nameController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "숙소명을 입력해 주세요",
                                          colorText: Theme.of(context).colorScheme.onSurface,
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("여행 종료일 보다 이후 날짜로 설정 할 수 없습니다.")));
                                      return;
                                    }
                                    if (_addressController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "주소를 입력해 주세요.",
                                          colorText: Theme.of(context).colorScheme.onSurface,
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("숙소 주소를 확인해 주세요")));
                                      return;
                                    }
                                    if (_paymentController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "숙박 가격을 입력해 주세요.",
                                          colorText: Theme.of(context).colorScheme.onSurface,
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("숙소 가격을 확인해 주세요")));
                                      return;
                                    }
                                    if (_periodController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "숙박 일 수를 입력해 주세요.",
                                          colorText: Theme.of(context).colorScheme.onSurface,
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("숙박 기간을 확인해 주세요")));
                                      return;
                                    }
                                    if (_checkInController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "체크인 시간을 입력해 주세요.",
                                          colorText: Theme.of(context).colorScheme.onSurface,
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("체크인 시간을 확인해 주세요")));
                                      return;
                                    }
                                    if (_checkOutController.text.isEmpty) {
                                      Get.snackbar("입력 정보 확인", "체크 아웃 시간을 입력해 주세요.",
                                          colorText: Theme.of(context).colorScheme.onSurface,
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          snackPosition: SnackPosition.BOTTOM);
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("체크아웃 시간을 확인해 주세요")));
                                      return;
                                    }
                                    final isRemove = context.read<PurchaseManager>().isRemoveAdsUser;
                                    if (kReleaseMode && !isRemove) {
                                      context.read<AdmobProvider>().loadAdInterstitialAd();
                                      context.read<AdmobProvider>().showInterstitialAd();
                                    }

                                    AccommodationModel info = AccommodationModel();
                                    info.name = _nameController.text;
                                    info.address = _addressController.text;
                                    info.payment = _paymentController.text;
                                    info.checkInTime = _checkInController.text;
                                    info.checkOutTime = _checkOutController.text;
                                    info.period = int.parse(_periodController.text);
                                    info.startDay = DateTime(widget.plan.schedule!.first!.year, month, day);
                                    info.bookApp = _bookingAppController.text;
                                    info.bookNum = _bookingNumController.text;

                                    context.read<AccommodationProvider>().addAccommodation(info, widget.plan.id!);
                                    _nameController.clear();
                                    _addressController.clear();
                                    _paymentController.clear();
                                    _checkInController.clear();
                                    _checkOutController.clear();
                                    _periodController.clear();
                                    _bookingNumController.clear();
                                    _bookingAppController.clear();

                                    Navigator.pop(diaContext);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text(
                                    localization.add,
                                    style: LocalizationsUtil.setTextStyle(isKor, color: Colors.white),
                                  )),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _accordionSection(BuildContext context, AppLocalizations localization, List<AccommodationModel> list, bool isDarkMode, bool isKor) {
    return Accordion(
        disableScrolling: true,
        rightIcon: null,
        headerBorderColor: isDarkMode ? Colors.white : Colors.black87,
        // headerBorderColorOpened: Colors.black87,
        headerBorderWidth: 1,
        headerPadding: const EdgeInsets.all(20),
        headerBackgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
        contentBorderColor: isDarkMode ? Colors.white : Colors.black87,
        contentBackgroundColor: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
        contentVerticalPadding: 20,
        contentHorizontalPadding: 20,
        children: [
          ...List.generate(list.length, (idx) {
            return AccordionSection(
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${list[idx].name} (${list[idx].period} ${localization.days})",
                      style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: TextButton(
                          onPressed: () {
                            context.read<AccommodationProvider>().removeAccommodation(idx, widget.plan.id!);
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            localization.delete,
                            style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                          )),
                    ),
                  ],
                ),
                content: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    // height: 350,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localization.address,
                                    style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: TextButton(
                                          onPressed: () async {
                                            await _openGoogleMap(list[idx].address!);
                                          },
                                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                          child: Text(localization.viewMap),
                                        ),
                                      ),
                                      const Gap(10),
                                      SizedBox(
                                        width: 70,
                                        child: TextButton(
                                          onPressed: () {
                                            if (list[idx].address!.isEmpty) {
                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("주소가 존재하지 않습니다.")));
                                              return;
                                            }
                                            Clipboard.setData(ClipboardData(text: list[idx].address!));
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("숙소 주소가 복사 되었습니다.")));
                                          },
                                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                          child: Text(localization.copy),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(
                                "${list[idx].address}",
                                style: const TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text(
                                  localization.enterPeriod,
                                  style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: Text("${list[idx].startDay!.year}.${list[idx].startDay!.month}.${list[idx].startDay!.day} "
                                    "~ ${list[idx].startDay!.add(Duration(days: list[idx].period!)).year}."
                                    "${list[idx].startDay!.add(Duration(days: list[idx].period!)).month}."
                                    "${list[idx].startDay!.add(Duration(days: list[idx].period!)).day} (${list[idx].period}${localization.days})"),
                              )
                            ],
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text(
                                  localization.option,
                                  style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    SizedBox(width: 80, child: Text(localization.checkIn)),
                                    Text(" : ${list[idx].checkInTime} ${localization.hour}")],
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    SizedBox(width: 80, child: Text(localization.checkout)),
                                    Text(" : ${list[idx].checkOutTime} ${localization.hour}")],
                                ),
                              )
                            ],
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  child: Text(
                                localization.reservationInfo,
                                style: LocalizationsUtil.setTextStyle(isKor, size: 16, fontWeight: FontWeight.w600),
                              )),
                              const Gap(10),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("${localization.reservationApp} : ")),
                                      SizedBox(
                                        child: Text(list[idx].bookApp ?? localization.noData),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 140, child: Text("${localization.reservationNum} : ")),
                                      SizedBox(
                                        child: Text(list[idx].bookNum ?? localization.noData),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const Gap(10),
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                localization.amount,
                                style: LocalizationsUtil.setTextStyle(isKor, fontWeight: FontWeight.w600, size: 16),
                              ),
                              Text(
                                list[idx].payment!,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ],
                    )));
          })
        ]);
  }
}
