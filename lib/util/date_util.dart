

class DateUtil {
  static String dateToString(DateTime date){
    String result = "";

    try{
      result = "${date.year}.${date.month}.${date.day}";
    }catch(ex){
      throw(ex.toString());
    }

    return result;
  }
  static bool isSameDay(DateTime a, DateTime b){
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  static int datesDifference(List<DateTime?> list){
    return list[1]!.difference(list[0]!).inDays;
  }

  static String planState(DateTime first, DateTime end) {
    if (DateUtil.isSameDay(first, DateTime.now())) {
      return "D-Day";
    }
    if (first.isAfter(DateTime.now())) {
      return "D-${first.difference(DateTime.now()).inDays+1}";
    }
    if (first.isBefore(DateTime.now()) && DateTime.now().isBefore(end)) {
      return "여행중";
    }
    if (DateTime.now().isAfter(end)) {
      return "여행종료";
    }
    return "알 수 없음";
  }
}