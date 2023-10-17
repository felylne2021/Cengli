import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/profile/components/profile_menu_widget.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';

class AccountDetailsPage extends StatelessWidget {
  const AccountDetailsPage({super.key, required this.user});
  static const String routeName = '/account_detail_page';
  final UserProfile user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(appbarTitle: 'Account Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileMenuWidget(
              title: 'Email',
              description: user.email ?? "no data",
              onTap: () {},
              isShowDivider: true,
            ),
            ProfileMenuWidget(
              title: 'Phone Number',
              description: "+62 812 203 5564",
              onTap: () {},
              isShowDivider: true,
            )
          ],
        ),
      ),
    );
  }
}
