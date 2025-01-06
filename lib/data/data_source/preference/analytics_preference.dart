import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsPreference {
  AnalyticsPreference._internal();

  static final AnalyticsPreference _singleton = AnalyticsPreference._internal();

  static AnalyticsPreference get singleton => _singleton;

  Future<void> checkIsFirst()async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool? isFirst = pref.getBool("is_first_run");
    if(isFirst == null || isFirst){
      await FirebaseAnalytics.instance.logEvent(name: "fire_run", parameters: {"time_stamp" : DateTime.now().toString()});
      log("first run logged");
      pref.setBool("is_first_run", false);
    }
  }
}
