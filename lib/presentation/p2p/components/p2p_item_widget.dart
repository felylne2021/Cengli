import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class P2pItemWidget extends StatelessWidget {
  final String name;
  final String quantity;

  const P2pItemWidget({super.key, required this.name, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        18.0.height,
        Text(
          name,
          style: KxTypography(
              type: KxFontType.subtitle4, color: KxColors.neutral700),
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        4.0.height,
        Row(
          children: [
            Text(
              "Quantity",
              style: KxTypography(
                  type: KxFontType.fieldText3, color: KxColors.neutral500),
            ),
            2.0.width,
            Text(
              quantity,
              style: KxTypography(
                  type: KxFontType.buttonSmall, color: KxColors.neutral600),
            ),
          ],
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        18.0.height,
        const Divider(
          color: KxColors.neutral200,
          thickness: 1,
        )
      ],
    );
  }
}
