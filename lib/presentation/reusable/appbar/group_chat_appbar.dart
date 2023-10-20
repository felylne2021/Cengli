import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class GroupChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  GroupChatAppbar(
      {super.key,
      required this.appBarTitle,
      required this.appBarSubtitle,
      this.leadingWidget,
      required this.leadingCallBack,
      required this.trailingCallBack,
      required this.trailingWidget})
      : preferredSize = const Size.fromHeight(65);
  final String appBarTitle;
  final String appBarSubtitle;
  final Widget? leadingWidget;
  final Function() leadingCallBack;
  final Function() trailingCallBack;
  final Widget trailingWidget;

  @override
  Size preferredSize;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
                onTap: leadingCallBack,
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 24,
                )),
            24.0.width,
            leadingWidget ?? const SizedBox(),
            20.0.width,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appBarTitle,
                      style: KxTypography(
                          type: KxFontType.body1, color: KxColors.neutral700),
                    ),
                    Text(
                      appBarSubtitle,
                      style: KxTypography(
                          type: KxFontType.caption3,
                          color: KxColors.neutral500),
                    )
                  ],
                ),
                InkWell(
                  onTap: trailingCallBack,
                  child: trailingWidget,
                )
              ],
            ).flexible(),
          ],
        ).padding(const EdgeInsets.fromLTRB(16, 0, 16, 0)),
        const Divider(
          thickness: 1,
          color: KxColors.neutral200,
        )
      ],
    ));
  }
}
