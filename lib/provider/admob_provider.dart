import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobProvider with ChangeNotifier {
  BannerAd? _bannerAd;

  BannerAd? get bannerAd => _bannerAd;

  void loadAdBanner() {
    late String adUnitId;
    if (Platform.isAndroid) {
      if (kReleaseMode) {
        adUnitId = "ca-app-pub-6057371989804889/7587250556";
      } else {
        adUnitId = "ca-app-pub-3940256099942544/9214589741";
      }
    } else if (Platform.isIOS) {
      if (kReleaseMode) {
        adUnitId = "ca-app-pub-6057371989804889/2808834070";
      } else {
        adUnitId = "ca-app-pub-3940256099942544/2435281174";
      }
    }

    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            notifyListeners();
          },
        ),
        request: const AdRequest())
    ..load();
  }

  void bannerAdDispose(){
    _bannerAd?.dispose();
    _bannerAd = null;
    notifyListeners();

  }
}