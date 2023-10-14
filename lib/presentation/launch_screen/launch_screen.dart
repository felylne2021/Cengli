import 'package:cengli/presentation/home/home_tab_bar.dart';
import 'package:cengli/presentation/launch_screen/onboarding_screen.dart';
import 'package:cengli/presentation/membership/login_page.dart';
import 'package:cengli/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../values/values.dart';

class LaunchScreenPage extends StatefulWidget {
  const LaunchScreenPage({super.key});
  static const String routeName = '/launch_page';

  @override
  State<LaunchScreenPage> createState() => _LaunchScreenPageState();
}

class _LaunchScreenPageState extends State<LaunchScreenPage> {
  @override
  void initState() {
    super.initState();
    _checkUserLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen600,
      body: Center(
          child: SvgPicture.asset(
        IC_CENGLI_LOGO,
        width: 148,
        height: 148,
      )),
    );
  }

  _checkUserLogin(BuildContext context) async {
    bool isLogin = await SessionService.isLoggedIn();
    bool isFirstInstall = await SessionService.isFirstInstall();

    if (isLogin) {
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeTabBarPage.routeName, (route) => false);
    } else {
      if (isFirstInstall) {
        SessionService.setFirstInstall(false);
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
            OnboardingPage.routeName, (route) => false);
      } else {
        if (!mounted) return;
        Navigator.of(context)
            .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
      }
    }
  }
}
