import 'package:cengli/presentation/group/create_group_member_page.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/presentation/reusable/shapes/circle_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../values/values.dart';
import '../reusable/menu/custom_menu_item_widget.dart';

class ChatNewPage extends StatelessWidget {
  const ChatNewPage({super.key});
  static const String routeName = '/chat_new_page';

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
        appBar: CustomAppbarWithBackButton(
          appbarTitle: "New Message",
        ),
        body: Column(
          children: [
            KxFilledTextField(
              controller: controller,
              hint: "Username or address",
              suffix: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        color: primaryGreen600,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text("Check",
                        style: KxTypography(
                            type: KxFontType.buttonMedium,
                            color: KxColors.neutral700)),
                  )),
            ).padding(const EdgeInsets.symmetric(horizontal: 16)),
            16.0.height,
            const Divider(
              color: KxColors.neutral200,
              thickness: 4,
            ),
            InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(CreateGroupMemberPage.routeName),
              child: CustomMenuItemWidget(
                icon: CircleIconWidget(
                    circleColor: softGreen, iconPath: IC_CREATE_GROUP),
                title: "Create Group",
              ),
            ),
            CustomMenuItemWidget(
              icon: CircleIconWidget(
                  circleColor: softYellow, iconPath: IC_NEW_CONTACT),
              title: "New Contact",
            )
          ],
        ).padding(const EdgeInsets.symmetric(vertical: 0)));
  }
}
