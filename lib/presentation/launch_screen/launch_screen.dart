import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/launch_screen/onboarding_screen.dart';
import 'package:cengli/presentation/membership/login_page.dart';
import 'package:cengli/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

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
    return const Scaffold(
      backgroundColor: KxColors.auxiliary600,
      body: Center(child: Text("Launch Screen")),
    );
  }

  _checkUserLogin(BuildContext context) async {
    bool isLogin = await SessionService.isLoggedIn();
    bool isFirstInstall = await SessionService.isFirstInstall();

    if (isLogin) {
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
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
