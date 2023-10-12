import 'package:cengli/utils/wallet_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../../values/values.dart';

class UserItemWidget extends StatelessWidget {
  final String name;
  final String username;
  final String address;
  final bool isShowDivider;

  const UserItemWidget(
      {super.key,
      required this.name,
      required this.username,
      required this.address,
      this.isShowDivider = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        12.0.height,
        Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: primaryGreen600),
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
            ),
          ],
        ),
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
}
