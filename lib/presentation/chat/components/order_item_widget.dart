import 'package:cengli/presentation/p2p/order_detail_page.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Waiting for approval",
                  style: KxTypography(
                      type: KxFontType.buttonMedium,
                      color: KxColors.neutral700),
                ),
                4.0.height,
                Text(
                  "Amount: 50 USDC",
                  style: KxTypography(
                      type: KxFontType.fieldText3, color: KxColors.neutral500),
                ),
              ],
            ),
            24.0.height,
            InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(OrderDetailPage.routeName),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                      color: primaryGreen600,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    "Details",
                    style: KxTypography(
                        type: KxFontType.buttonSmall,
                        color: KxColors.neutral700),
                  ),
                ))
          ],
        ).padding(const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
        const Divider(
          color: KxColors.neutral200,
          thickness: 1,
        )
      ],
    );
  }
}
