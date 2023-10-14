import 'package:cengli/utils/wallet_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../../values/values.dart';

class UserAddressItemWidget extends StatelessWidget {
  final String username;
  final String address;

  const UserAddressItemWidget(
      {super.key, required this.username, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: primaryGreen600),
        ),
        16.0.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ],
    ).padding(const EdgeInsets.symmetric(vertical: 12));
  }
}
