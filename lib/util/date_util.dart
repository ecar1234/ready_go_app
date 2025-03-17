

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
}