

import 'package:intl/intl.dart';

import '../data/models/plan_model/plan_model.dart';

class StatisticsUtil {
  static String getAccountStatistics(List<Map<String, List<int>>> account, int idx){
    int total = 0;
    int use = 0;
    for (var item in account) {
      for (var e in item.values) {
        total += e.first + e.last;
      }
    }

    for (var e in account[idx].values) {
      use += e.first + e.last;
    }
    if(total == 0 || use == 0) return "0.0";
    return ((use / total)*100).toStringAsFixed(1);
  }
  static double getAccountValue(List<Map<String, List<int>>> account, int idx){
    int total = 0;
    int use = 0;
    for (var item in account) {
      for (var e in item.values) {
        total += e.first + e.last;
      }
    }

    for (var e in account[idx].values) {
      use += e.first + e.last;
    }
    if(total == 0 || use == 0) return 0.0;
    return ((use / total)*100).roundToDouble();
  }
  static int getPlanTotalAccount(Map<String, List<int>> account){
    int total = 0;
    for (var e in account.values) {
      total += e.first + e.last;
    }
    return total;
  }
}