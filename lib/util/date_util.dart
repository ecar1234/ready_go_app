class DateUtil {
  static String dateToString(DateTime date) {
    String result = "";

    try {
      result = "${date.year}.${date.month}.${date.day}";
    } catch (ex) {
      throw (ex.toString());
    }

    return result;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int datesDifference(List<DateTime?> list) {
    return list[1]!.difference(list[0]!).inDays;
  }

  static String planState(DateTime first, DateTime end) {
    if (DateUtil.isSameDay(first, DateTime.now())) {
      return "D-Day";
    }
    if (first.isAfter(DateTime.now())) {
      return "D-${first.difference(DateTime.now()).inDays + 1}";
    }
    if (first.isBefore(DateTime.now()) && DateTime.now().isBefore(end)) {
      return "여행중";
    }
    if (DateTime.now().isAfter(end)) {
      return "여행종료";
    }
    return "알 수 없음";
  }

  static String getMonth(String locale, int month){
    if(locale == "ko"){
      switch (month) {
        case 1:
          return "1월"; // 一月
        case 2:
          return "2월"; // 二月
        case 3:
          return "3월"; // 三月
        case 4:
          return "4월"; // 四月
        case 5:
          return "5월"; // 五月
        case 6:
          return "6월"; // 六月
        case 7:
          return "7월"; // 七月
        case 8:
          return "8월"; // 八月
        case 9:
          return "9월"; // 九月
        case 10:
          return "10월"; // 十月
        case 11:
          return "11월"; // 十一月
        case 12:
          return "12월"; // 十二月
        default:
          return "1월";
      }
    }else if(locale == "ja"){
      switch (month) {
        case 1:
          return "1月"; // 一月
        case 2:
          return "2月"; // 二月
        case 3:
          return "3月"; // 三月
        case 4:
          return "4月"; // 四月
        case 5:
          return "5月"; // 五月
        case 6:
          return "6月"; // 六月
        case 7:
          return "7月"; // 七月
        case 8:
          return "8月"; // 八月
        case 9:
          return "9月"; // 九月
        case 10:
          return "10月"; // 十月
        case 11:
          return "11月"; // 十一月
        case 12:
          return "12月"; // 十二月
        default:
          return "1月";
      }
    }else{
      switch (month) {
        case 1:
          return "January";
        case 2:
          return "February";
        case 3:
          return "March";
        case 4:
          return "April";
        case 5:
          return "May";
        case 6:
          return "June";
        case 7:
          return "July";
        case 8:
          return "August";
        case 9:
          return "September";
        case 10:
          return "October";
        case 11:
          return "November";
        case 12:
          return "December";
        default:
          return "January";
      }
    }
  }
}
