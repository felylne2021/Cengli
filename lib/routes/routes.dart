import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/chat/chat_new_page.dart';
import 'package:cengli/presentation/chat/chat_page.dart';
import 'package:cengli/presentation/chat/chat_room_page.dart';
import 'package:cengli/presentation/group/create_group_member_page.dart';
import 'package:cengli/presentation/group/create_group_page.dart';
import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/launch_screen/onboarding_screen.dart';
import 'package:cengli/presentation/membership/pin_input_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../presentation/membership/login_page.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[850]!.withOpacity(0.3),
      statusBarBrightness: Brightness.light,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChannels.lifecycle.setMessageHandler((msg) async {
        if (msg == AppLifecycleState.paused.toString()) {}
        return await msg;
      });
    });
    switch (settings.name) {
      case LoginPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const LoginPage(), settings: settings);
      case HomePage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const HomePage(), settings: settings);
      case ChatRoomPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                ChatRoomPage(argument: settings.arguments as ChatRoomArgument),
            settings: settings);
      case PinInputPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => PinInputPage(
                  argument: settings.arguments as PinInputArgument,
                ),
            settings: settings);
      case OnboardingPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const OnboardingPage(), settings: settings);
      case ChatPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const ChatPage(), settings: settings);
      case ChatNewPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const ChatNewPage(), settings: settings);
      case CreateGroupMemberPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const CreateGroupMemberPage(), settings: settings);
      case CreateGroupPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => CreateGroupPage(
                members: settings.arguments as List<UserProfile>),
            settings: settings);
    }
  }
}
