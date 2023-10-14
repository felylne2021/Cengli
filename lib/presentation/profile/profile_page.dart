import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const String routeName = '/profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  _getUsername() async {
    String name = await SessionService.getUsername();
    setState(() {
      username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          appbarTitle: 'Profile',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                  color: KxColors.neutral200, shape: BoxShape.circle),
              child: const Icon(
                CupertinoIcons.person_fill,
                color: KxColors.neutral400,
              ),
            ),
            16.0.height,
            Text(
              username,
              style: KxTypography(
                  type: KxFontType.subtitle4, color: KxColors.neutral700),
            ),
            4.0.height,
            Text(
              username,
              style: KxTypography(
                  type: KxFontType.caption2, color: KxColors.neutral500),
            ),
          ],
        ).padding().center());
  }
}
