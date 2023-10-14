import 'package:cengli/utils/utils.dart';
import 'package:cengli/utils/wallet_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';


class ChatBubbleWidget extends StatelessWidget {
  final String name;
  final String message;
  final DateTime date;
  const ChatBubbleWidget(
      {super.key,
      required this.name,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: KxColors.neutral200,
          ),
          child: const Icon(
            CupertinoIcons.person_fill,
            color: KxColors.neutral400,
          ),
        ),
        12.0.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  WalletUtil.shortAddress(name),
                  style: KxTypography(
                      type: KxFontType.subtitle4, color: KxColors.neutral700),
                ),
                12.0.width,
                Text(
                  DateUtil.formatDateTime(date, "hh:mm aa"),
                  style: KxTypography(
                      type: KxFontType.caption1, color: KxColors.neutral300),
                )
              ],
            ),
            6.0.height,
            Text(
              message,
              style: KxTypography(
                  type: KxFontType.fieldText1, color: KxColors.neutral700),
            )
          ],
        ).flexible()
      ],
    );
  }
}
