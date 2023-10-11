import 'package:cengli/utils/wallet_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:kinetix/kinetix.dart';

class UserItemWidget extends StatelessWidget {
  final String name;
  final String username;
  final String address;
  const UserItemWidget(
      {super.key,
      required this.name,
      required this.username,
      required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: KxColors.auxiliary700),
        ),
        16.0.width,
        Text(name,
            style: KxTypography(
                type: KxFontType.buttonMedium, color: KxColors.neutral700),
            maxLines: 1),
        const Spacer(),
        12.0.width,
        Column(
          children: [
            Text(
              username,
              style: KxTypography(
                  type: KxFontType.fieldText3, color: KxColors.neutral500),
            ),
            8.0.height,
            Text(
              WalletUtil.shortAddress(address),
              style: KxTypography(
                  type: KxFontType.fieldText3, color: KxColors.neutral500),
            ),
          ],
        )
      ],
    );
  }
}
