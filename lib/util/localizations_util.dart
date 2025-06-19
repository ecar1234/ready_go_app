import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocalizationsUtil {
  static TextStyle setTextStyle(bool locale,
      {Color? color, double? size = 14, FontWeight? fontWeight = FontWeight.w400, double height = 1.2, TextDecoration? decoration}) {
    if (locale) {
      return TextStyle(fontFamily: "Nanum", color: color, fontSize: size, fontWeight: fontWeight, height: height, decoration: decoration);
    }
    return GoogleFonts.notoSans(color: color, fontSize: size, fontWeight: fontWeight, height: height, decoration: decoration);
  }
}
