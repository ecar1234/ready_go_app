import 'dart:developer';

import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';

import '../data/models/account_model/amount_model.dart';


class StatisticsUtil {
  // Statistics
  static String getAccountStatistics(List<Map<String, List<int>>> account, int idx) {
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
    if (total == 0 || use == 0) return "0.0";
    return ((use / total) * 100).toStringAsFixed(1);
  }

  static double getAccountValue(List<Map<String, List<int>>> account, int idx) {
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
    if (total == 0 || use == 0) return 0.0;
    return ((use / total) * 100).roundToDouble();
  }

  static int getPlanTotalAccount(Map<String, List<int>> account) {
    int total = 0;
    for (var e in account.values) {
      total += e.first + e.last;
    }
    return total;
  }

  // Expectation
  static int getExpectationTotal(List<ExpectationModel> list){
    int total = 0;

    for (var item in list) {
      total += item.amount!;
    }
    return total;
  }

  static String getExpectationTotalAccount(List<ExpectationModel> list, int idx) {
    int total = 0;
    int use = list[idx].amount!;
    for (var item in list) {
      total += item.amount!;
    }
    // log("${((use / total) * 100).roundToDouble()}");
    return ((use / total) * 100).toStringAsFixed(1);
  }

  static String conversionMethodTypeToString(MethodType type) {
    switch (type) {
      case MethodType.ariPlane:
        return "항공권";
      case MethodType.shopping:
        return "쇼핑";
      case MethodType.traffic:
        return "교통비";
      case MethodType.food:
        return "음식";
      case MethodType.drink:
        return "유흥";
      case MethodType.tour:
        return "여행";
      case MethodType.leisure:
        return "레져";
      case MethodType.accommodation:
        return "숙소";
      case MethodType.ect:
        return "기타";
    }
  }

  static MethodType conversionStringToMethodType(String type) {
    switch (type) {
      case "항공권":
        return MethodType.ariPlane;
      case "교통비":
        return MethodType.traffic;
      case "음식":
        return MethodType.food;
      case "유흥":
        return MethodType.drink;
      case "쇼핑":
        return MethodType.shopping;
      case "숙소":
        return MethodType.accommodation;
      case "여행":
        return MethodType.tour;
      case "레져":
        return MethodType.leisure;
      case "기타":
        return MethodType.ect;
      default: return MethodType.ect;
    }
  }
}
