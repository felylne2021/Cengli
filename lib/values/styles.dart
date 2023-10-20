import 'package:flutter/material.dart';

class CengliTypography extends TextStyle {
  final CengliFontType type;
  final Color color;

  CengliTypography({required this.type, required this.color})
      : super(
            fontFamily: type.format.family,
            color: color,
            fontSize: type.size,
            fontWeight: type.format.weight,
            height: type.height);
}

enum CengliFontType {
  headline1(CengliFontFormat.unboundedBold, 30, 1.6),
  headline2(CengliFontFormat.unboundedBold, 26, 1.65),
  headline3(CengliFontFormat.unboundedBold, 24, 1.58),
  headline4(CengliFontFormat.unboundedMedium, 24, 1.58),

  subtitle1(CengliFontFormat.unboundedBold, 20, 1.6),
  subtitle2(CengliFontFormat.unboundedMedium, 20, 1.6),
  subtitle3(CengliFontFormat.unboundedBold, 20, 1.6),
  subtitle4(CengliFontFormat.unboundedMedium, 16, 1.5),
  subtitle5(CengliFontFormat.unboundedSemiBold, 16, 1.5),
  subtitle6(CengliFontFormat.unboundedMedium, 14, 1.28);

  final CengliFontFormat format;
  final double size;
  final double height;

  const CengliFontType(this.format, this.size, this.height);
}

enum CengliFontFormat {
  unboundedRegular(FontWeight.w400, "Unbounded"),
  unboundedMedium(FontWeight.w500, "Unbounded"),
  unboundedSemiBold(FontWeight.w600, "Unbounded"),
  unboundedBold(FontWeight.w700, "Unbounded");

  final FontWeight weight;
  final String family;

  const CengliFontFormat(this.weight, this.family);
}
