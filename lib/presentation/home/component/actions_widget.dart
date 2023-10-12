import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';

class ActionWidget extends StatelessWidget {
  const ActionWidget({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconPath,
    required this.onTap,
  });

  final String title;
  final Color bgColor;
  final String iconPath;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: bgColor,
            child: SvgPicture.asset(iconPath),
          ),
          8.0.height,
          Text(
            title,
            style: KxTypography(
                type: KxFontType.buttonMedium, color: KxColors.neutral700),
          )
        ],
      ),
    );
  }
}
