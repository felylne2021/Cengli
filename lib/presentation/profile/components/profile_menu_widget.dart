import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

class ProfileMenuWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isShowDivider;
  final Function() onTap;

  const ProfileMenuWidget(
      {super.key,
      required this.title,
      required this.description,
      this.imagePath = '',
      this.isShowDivider = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          12.0.height,
          Row(
            children: [
              Visibility(
                visible: imagePath.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      imagePath,
                      height: 40,
                      width: 40,
                    ),
                    16.0.width,
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: KxTypography(
                          type: KxFontType.subtitle4,
                          color: KxColors.neutral700),
                      maxLines: 1),
                  // const Spacer(),
                  4.0.height,
                  Text(
                    description,
                    style: KxTypography(
                        type: KxFontType.fieldText3,
                        color: KxColors.neutral500),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded,
                  color: KxColors.neutral400, size: 24)
            ],
          ).padding(const EdgeInsets.symmetric(horizontal: 16)),
          20.0.height,
          Visibility(
              visible: isShowDivider,
              child: const Divider(
                thickness: 1,
                color: KxColors.neutral200,
              ))
        ],
      ),
    );
  }

  String _getIcon(String expenseType) {
    String icon = '';

    if (expenseType.contains("food")) {
      icon = IC_CAT_FOOD;
    } else if (expenseType.contains("entertainment")) {
      icon = IC_CAT_ENT;
    } else if (expenseType.contains("groceries")) {
      icon = IC_CAT_GROCERIES;
    } else if (expenseType.contains("bills")) {
      icon = IC_CAT_HOUSE;
    } else if (expenseType.contains("transportation")) {
      icon = IC_CAT_TRANSPORT;
    } else if (expenseType.contains("expense")) {
      icon = IC_CAT_OTHER;
    } else {
      icon = IC_CATEGORY_LOGO;
    }

    return icon;
  }
}
