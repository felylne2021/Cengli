import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/group/components/user_item_widget.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/presentation/reusable/menu/custom_menu_item_widget.dart';
import 'package:cengli/presentation/reusable/shapes/circle_icon_widget.dart';
import 'package:cengli/utils/wallet_util.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class GroupMemberPage extends StatelessWidget {
  final List<UserProfile> members;

  const GroupMemberPage({super.key, required this.members});
  static const String routeName = '/group_member_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(appbarTitle: "Members"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomMenuItemWidget(
                icon: CircleIconWidget(
                    iconPath: IC_ADD, circleColor: KxColors.neutral200),
                title: "Add Member"),
            Column(
              children: List.generate(
                members.length,
                (index) => UserItemWidget(
                  name: members[index].userName ?? "",
                  username: members[index].userName ?? "",
                  address: WalletUtil.shortAddress(
                      members[index].walletAddress ?? ""),
                  isShowDivider: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
