import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class AdmobProvider with ChangeNotifier {
  final logger = Logger();

  // BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  bool _isLoaded = false;

  // BannerAd? get bannerAd => _bannerAd;
  InterstitialAd? get interstitialAd => _interstitialAd;

  // bool get isLoaded => _isLoaded;

  // void loadAdBanner() {
  //   late String adUnitId;
  //   if (Platform.isAndroid) {
  //     if (kReleaseMode) {
  //       adUnitId = "ca-app-pub-6057371989804889/7587250556";
  //     } else {
  //       adUnitId = "ca-app-pub-3940256099942544/9214589741";
  //     }
  //   } else if (Platform.isIOS) {
  //     if (kReleaseMode) {
  //       adUnitId = "ca-app-pub-6057371989804889/2808834070";
  //     } else {
  //       adUnitId = "ca-app-pub-3940256099942544/2435281174";
  //     }
  //
  //     _bannerAd = BannerAd(
  //         size: AdSize.banner,
  //         adUnitId: adUnitId,
  //         listener: BannerAdListener(
  //           onAdLoaded: (ad) {
  //             _isLoaded = true;
  //             notifyListeners();
  //           },
  //           onAdFailedToLoad: (ad, error) {
  //             ad.dispose();
  //             _bannerAd = null;
  //             _isLoaded = false;
  //             notifyListeners();
  //           },
  //         ),
  //         request: const AdRequest())..load();
  //   }
  // }

  void loadAdInterstitialAd() {
    late String interstitialAd;
    if (Platform.isAndroid) {
      if (kReleaseMode) {
        interstitialAd = "ca-app-pub-6057371989804889/7457638448";
      } else {
        interstitialAd = "ca-app-pub-3940256099942544/1033173712";
      }
    } else if (Platform.isIOS) {
      if (kReleaseMode) {
        interstitialAd = "ca-app-pub-6057371989804889/3488764386";
      } else {
        interstitialAd = "ca-app-pub-3940256099942544/4411468910";
      }
    }
    InterstitialAd.load(
        adUnitId: interstitialAd,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isLoaded = true;
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              logger.i('$ad dismissed.');
              ad.dispose();
              _interstitialAd = null;
              _isLoaded = false;
              // 필요하다면 다음 광고 로드
              // _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
              logger.e('$ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _isLoaded = false;
              // 필요하다면 재시도 또는 오류 처리
            },
          );
        }, onAdFailedToLoad: (LoadAdError error) {
          logger.e("full screen AD loading failed");
        }));
  }

  void showInterstitialAd() {
    if (_isLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      logger.w("Interstitial Ad is not ready yet.");
      // 광고가 준비되지 않았을 때의 처리
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _interstitialAd?.dispose();
  }

}
