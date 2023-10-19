import 'package:cengli/presentation/chat/components/chat_profile_image_widget.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

class ChatItemWidget extends StatelessWidget {
  final ProfileProfileImageWidget imageIcon;
  final String title;
  final String caption;
  final bool isNeedApproval;
  final Function()? declineCallback;
  final Function()? acceptCallback;
  final bool isShowDivider;

  const ChatItemWidget(
      {super.key,
      required this.title,
      required this.caption,
      required this.isNeedApproval,
      required this.imageIcon,
      this.declineCallback,
      this.acceptCallback,
      this.isShowDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        8.0.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageIcon,
            14.0.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: KxTypography(
                        type: KxFontType.subtitle4,
                        color: KxColors.neutral700)),
                8.0.height,
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: KxTypography(
                      type: KxFontType.body2, color: KxColors.neutral500),
                ),
                Visibility(
                    visible: isNeedApproval,
                    child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: declineCallback,
                              child: actionButton(true),
                            ),
                            16.0.width,
                            InkWell(
                              onTap: acceptCallback,
                              child: actionButton(false),
                            )
                          ],
                        )))
              ],
            ).flexible()
          ],
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        Visibility(
            visible: isShowDivider,
            child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: const Divider(
                  thickness: 1,
                  color: KxColors.neutral200,
                )))
      ],
    );
  }

  Widget actionButton(bool isDecline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isDecline ? KxColors.neutral200 : primaryGreen600),
      child: Row(
        children: [
          SvgPicture.asset(isDecline ? IC_XMARK : IC_CHECK,
              width: 18, height: 18),
          4.0.width,
          Text(
            isDecline ? "Decline" : "Accept",
            style: KxTypography(
                type: KxFontType.buttonSmall, color: KxColors.neutral700),
          )
        ],
      ),
    );
  }
}
