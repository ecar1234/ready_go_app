import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobUtil {
  BannerAd? bannerAd;

  void loadBannerAd({required Function onAdLoaded, required Function onAdFailed}) {

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
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onAdLoaded();
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("admob banner onFailed to load");
          ad.dispose();
          bannerAd = null;
          onAdFailed();
        },
      ),
      request: const AdRequest(),
    )
      ..load();
  }

  Widget? getBannerAdWidget() {
    if (bannerAd != null) {
      return AdWidget(ad: bannerAd!);
    }
    return null;
  }
    void dispose() {
      bannerAd?.dispose();
    }
  }