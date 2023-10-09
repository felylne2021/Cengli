import 'package:cengli/presentation/chat/group/chat_room/chat_room_screen.dart';
import 'package:cengli/presentation/chat/group/conversations/conversations_screen.dart';
import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/membership/pin_input_page.dart';
import 'package:cengli/push_protocol/src/models/src/requests_model.dart';
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
      case ChatRoomScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => ChatRoomScreen(room: settings.arguments as Feeds),
            settings: settings);
      case PinInputPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const PinInputPage(), settings: settings);
      case ConversationsScreen.routeName:
        return CupertinoPageRoute(
            builder: (_) => const ConversationsScreen(), settings: settings);
    }
  }
}
