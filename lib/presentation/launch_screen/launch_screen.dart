import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/membership/login_page.dart';
import 'package:cengli/services/session_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
    return const Center(
      child: Text("Lunch Screen"),
    );
  }

  _checkUserLogin(BuildContext context) async {
    bool isLogin = await SessionService.isLoggedIn();
    if (isLogin) {
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
    } else {
      if (!mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.routeName, (route) => false);
    }
  }
}
