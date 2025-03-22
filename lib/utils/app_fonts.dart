import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static bodyFont({
    var color,
    var fontSize,
    var fontWeight,
    var fontStyle,
    var letterSpacing,
    var height,
    var decoration,
    Color? decorationColor
  }) {
    return GoogleFonts.roboto(
      height: height,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      fontSize: fontSize?.toDouble(),
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      // decorationThickness: 1.5,
      decorationColor: color,
    );
  }

  static hintFont({
    var color,
    var fontSize,
    var fontWeight,
    var fontStyle,
    var letterSpacing,
    var height,
    var decoration,
  }) {
    return GoogleFonts.mulish(
      height: height,
      color: color,
      letterSpacing: letterSpacing,
      decoration: decoration,
      fontSize: fontSize?.toDouble(),
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      // decorationThickness: 1.5,
      decorationColor: color,
    );
  }
}
