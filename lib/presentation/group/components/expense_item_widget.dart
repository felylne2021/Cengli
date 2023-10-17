import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

class ExpenseItemWidget extends StatelessWidget {
  final String name;
  final String expenseType;

  final String date;
  final String memberPayName;
  final String tokenUnit;
  final String amount;
  final bool isShowDivider;

  const ExpenseItemWidget(
      {super.key,
      required this.name,
      required this.memberPayName,
      required this.date,
      this.isShowDivider = false,
      required this.tokenUnit,
      required this.amount,
      required this.expenseType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        12.0.height,
        Row(
          children: [
            SvgPicture.asset(
              _getIcon(expenseType.toLowerCase()),
              height: 40,
              width: 40,
            ),
            16.0.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: KxTypography(
                        type: KxFontType.buttonMedium,
                        color: KxColors.neutral700),
                    maxLines: 1),
                // const Spacer(),
                4.0.height,
                Text(
                  date,
                  style: KxTypography(
                      type: KxFontType.fieldText3, color: KxColors.neutral500),
                ),
                4.0.height,

                Text(
                  "Paid by $memberPayName",
                  style: KxTypography(
                      type: KxFontType.fieldText3, color: KxColors.neutral500),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  '$tokenUnit $amount,00',
                  style: KxTypography(
                      type: KxFontType.subtitle4, color: deepGreen),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: KxColors.neutral400,
                  size: 16,
                )
              ],
            )
          ],
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        12.0.height,
        Visibility(
            visible: isShowDivider,
            child: const Divider(
              thickness: 1,
              color: KxColors.neutral200,
            ))
      ],
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
