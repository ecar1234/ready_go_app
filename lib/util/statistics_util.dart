
import 'package:flutter/material.dart';
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

  static String conversionMethodTypeToString(String locale, MethodType type) {
    if(locale == "ko"){
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
    }else if(locale == "ja"){
      switch (type) {
        case MethodType.ariPlane:
          return "航空券";       // 항공권
        case MethodType.shopping:
          return "ショッピング"; // 쇼핑
        case MethodType.traffic:
          return "交通費";       // 교통비
        case MethodType.food:
          return "食事";         // 음식
        case MethodType.drink:
          return "娯楽";         // 유흥
        case MethodType.tour:
          return "観光";         // 여행
        case MethodType.leisure:
          return "レジャー";     // 레져
        case MethodType.accommodation:
          return "宿泊";         // 숙소
        case MethodType.ect:
          return "その他";       // 기타
      }
    }else {
      switch (type) {
        case MethodType.ariPlane:
          return "Flight";           // 항공권
        case MethodType.shopping:
          return "Shopping";         // 쇼핑
        case MethodType.traffic:
          return "Transportation";   // 교통비
        case MethodType.food:
          return "Food";             // 음식
        case MethodType.drink:
          return "Drink";    // 유흥
        case MethodType.tour:
          return "Sightseeing";      // 여행
        case MethodType.leisure:
          return "Leisure";          // 레져
        case MethodType.accommodation:
          return "Accommodation";    // 숙소
        case MethodType.ect:
          return "Others";           // 기타
      }
    }

  }

  static MethodType conversionStringToMethodType(String locale, String type) {
    if(locale == "ko"){
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
    }else if(locale == "ja"){
      switch (type) {
        case "航空券":
          return MethodType.ariPlane ;       // 항공권
        case "ショッピング":
          return MethodType.shopping; // 쇼핑
        case "交通費":
          return MethodType.traffic;       // 교통비
        case "食事":
          return MethodType.food;         // 음식
        case "娯楽":
          return MethodType.drink;         // 유흥
        case "観光":
          return MethodType.tour;         // 여행
        case "レジャー":
          return MethodType.leisure;     // 레져
        case "宿泊":
          return MethodType.accommodation;         // 숙소
        case "その他":
          return MethodType.ect;       // 기타
      }
    }else {
      switch (type) {
        case "Flight":
          return MethodType.ariPlane;           // 항공권
        case "Shopping":
          return MethodType.shopping;         // 쇼핑
        case "Transportation":
          return MethodType.traffic;   // 교통비
        case "Food":
          return MethodType.food;             // 음식
        case "Drink":
          return MethodType.drink;    // 유흥
        case "Sightseeing":
          return MethodType.tour;      // 여행
        case "Leisure":
          return MethodType.leisure;          // 레져
        case "Accommodation":
          return MethodType.accommodation;    // 숙소
        case "Others":
          return MethodType.ect;           // 기타
      }
    }
  return MethodType.ect;
  }

  static Color getCardColor(MethodType type){
    switch (type) {
      case MethodType.ariPlane:
        return Colors.blue;
      case MethodType.shopping:
        return Colors.orangeAccent;
      case MethodType.traffic:
        return Colors.cyan;
      case MethodType.food:
        return Colors.green;
      case MethodType.drink:
        return Colors.teal;
      case MethodType.tour:
        return Colors.indigo;
      case MethodType.leisure:
        return Colors.redAccent;
      case MethodType.accommodation:
        return Colors.pink;
      case MethodType.ect:
        return Colors.grey[300]!;
    }
  }
}
