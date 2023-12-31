import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transactional/model/bill.dart';
import 'package:cengli/presentation/chat/chat_new_page.dart';
import 'package:cengli/presentation/chat/chat_page.dart';
import 'package:cengli/presentation/chat/chat_room_page.dart';
import 'package:cengli/presentation/chat/expense/add_expense_page.dart';
import 'package:cengli/presentation/group/create_group_member_page.dart';
import 'package:cengli/presentation/group/create_group_page.dart';
import 'package:cengli/presentation/group/group_detail_page.dart';
import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/launch_screen/onboarding_screen.dart';
import 'package:cengli/presentation/membership/pin_input_page.dart';
import 'package:cengli/presentation/p2p/kyc_page.dart';
import 'package:cengli/presentation/p2p/order_detail_page.dart';
import 'package:cengli/presentation/p2p/p2p_request_page.dart';
import 'package:cengli/presentation/p2p/p2p_user_chat_page.dart';
import 'package:cengli/presentation/p2p/partner_registration_page.dart';
import 'package:cengli/presentation/profile/edit/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../presentation/group/group_member_page.dart';
import '../presentation/home/component/bills/bills_page.dart';
import '../presentation/home/component/bills/detail/bills_detail_page.dart';
import '../presentation/p2p/p2p_page.dart';
import '../presentation/home/home_tab_bar.dart';
import '../presentation/membership/login_page.dart';
import '../presentation/p2p/p2p_room_chat_paget.dart';
import '../presentation/profile/components/account_details_page.dart';
import '../presentation/profile/profile_page.dart';
import '../presentation/reusable/page/qr_scan_page.dart';
import '../presentation/reusable/page/status_page.dart';
import '../presentation/transfer/send_detail_page.dart';
import '../presentation/transfer/send_page.dart';
import '../presentation/transfer/send_summary_page.dart';
import '../services/push_protocol/src/models/src/requests_model.dart';

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
      case HomeTabBarPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => HomeTabBarPage(
                  initialPage: settings.arguments as int?,
                ),
            settings: settings);
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
      case ProfilePage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const ProfilePage(), settings: settings);
      case ChatNewPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const ChatNewPage(), settings: settings);
      case CreateGroupMemberPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const CreateGroupMemberPage(), settings: settings);
      case P2pPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                P2pPage(argument: settings.arguments as P2pArgument),
            settings: settings);
      case BillsPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => BillsPage(
                  bills: settings.arguments as List<Bill>,
                ),
            settings: settings);
      case BillsDetailPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => BillsDetailPage(
                  bill: settings.arguments as Bill,
                ),
            settings: settings);
      case CreateGroupPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => CreateGroupPage(
                members: settings.arguments as List<UserProfile>),
            settings: settings);
      case GroupDetailPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => GroupDetailPage(room: settings.arguments as Feeds),
            settings: settings);
      case SendPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                SendPage(argument: settings.arguments as SendArgument),
            settings: settings);
      case SendDetailPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                SendDetailPage(argument: settings.arguments as SendArgument),
            settings: settings);
      case SendSummaryPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                SendSummaryPage(argument: settings.arguments as SendArgument),
            settings: settings);
      case StatusPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                StatusPage(argument: settings.arguments as StatusArgument),
            settings: settings);
      case QrScanPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => const QrScanPage(), settings: settings);
      case P2pRequestPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => P2pRequestPage(
                  argument: settings.arguments as P2pArgument,
                ),
            settings: settings);
      case OrderDetailPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => OrderDetailPage(
                  argument: settings.arguments as OrderDetailArgument,
                ),
            settings: settings);
      case P2pChatRoomPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => P2pChatRoomPage(
                argument: settings.arguments as P2pChatRoomArgument));
      case AddExpensePage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                AddExpensePage(chatId: settings.arguments as String),
            settings: settings);
      case AccountDetailsPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                AccountDetailsPage(user: settings.arguments as UserProfile),
            settings: settings);
      case EditProfilePage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                EditProfilePage(user: settings.arguments as UserProfile),
            settings: settings);
      case GroupMemberPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => GroupMemberPage(
                members: settings.arguments as List<UserProfile>),
            settings: settings);
      case KycPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => KycPage(url: settings.arguments as String), settings: settings);
      case PartnerRegistrationPage.routeName:
        return CupertinoPageRoute(
            builder: (_) => PartnerRegistrationPage(
                user: settings.arguments as UserProfile),
            settings: settings);
      case P2pUserChatPage.routeName:
        return CupertinoPageRoute(
            builder: (_) =>
                P2pUserChatPage(argument: settings.arguments as P2pArgument),
            settings: settings);
    }
  }
}
