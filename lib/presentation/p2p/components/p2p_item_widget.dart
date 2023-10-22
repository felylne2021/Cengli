import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class P2pItemWidget extends StatelessWidget {
  final String name;
  final String quantity;
  final String image;
  final String chainName;

  const P2pItemWidget(
      {super.key,
      required this.name,
      required this.quantity,
      required this.image,
      required this.chainName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        18.0.height,
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: KxTypography(
                      type: KxFontType.subtitle4, color: KxColors.neutral700),
                ),
                4.0.height,
                Row(
                  children: [
                    Text(
                      "Quantity",
                      style: KxTypography(
                          type: KxFontType.fieldText3,
                          color: KxColors.neutral500),
                    ),
                    2.0.width,
                    Text(
                      quantity,
                      style: KxTypography(
                          type: KxFontType.buttonSmall,
                          color: KxColors.neutral600),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.network(image),
            ),
            4.0.width,
            Text(
              chainName,
              style: KxTypography(
                  type: KxFontType.body2, color: KxColors.neutral700),
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
