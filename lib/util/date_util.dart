

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
}