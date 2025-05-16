
import 'package:intl/intl.dart';

class IntlUtils {
  static String stringIntAddComma(int value){
    final result = NumberFormat("#,###").format(value);
    return result;
  }
  static int removeComma(String value){
    int result = int.parse(value.split(",").join());
    return result;
  }
}