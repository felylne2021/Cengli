import 'package:cengli/presentation/chat/chat_page.dart';
import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/profile/profile_page.dart';
import 'package:cengli/provider/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../provider/conversations_provider.dart';
import '../../services/session_service.dart';
import '../../values/values.dart';

class HomeTabBarPage extends ConsumerStatefulWidget {
  final int? initialPage;

  const HomeTabBarPage({super.key, this.initialPage});
  static const String routeName = '/home_tab_bar';
  static const int homePage = 0;
  static const int chatPage = 0;
  static const int profilePage = 0;

  @override
  ConsumerState<HomeTabBarPage> createState() => _HomeTabBarPageState();
}

class _HomeTabBarPageState extends ConsumerState<HomeTabBarPage> {
  int currentPage = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage ?? 0;
    pageController = PageController(initialPage: widget.initialPage ?? 0);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchRoom();
    });
  }

  @override
  void dispose() {
    ref.watch(accountProvider).disconnect();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(bottom: 15)),
          child: KxTabbar(
            item: KxTabbarItem(pages: const [
              HomePage(),
              ChatPage(),
              ProfilePage()
            ], items: [
              BottomNavigationBarItem(
                  label: '',
                  icon: SvgPicture.asset(IC_WALLET, color: KxColors.neutral300),
                  activeIcon: CircleAvatar(
                      backgroundColor: primaryGreen600,
                      child: SvgPicture.asset(IC_WALLET))),
              BottomNavigationBarItem(
                  label: '',
                  icon: SvgPicture.asset(IC_CHAT, color: KxColors.neutral300),
                  activeIcon: CircleAvatar(
                      backgroundColor: primaryGreen600,
                      child: SvgPicture.asset(
                        IC_CHAT,
                        color: Colors.black,
                      ))),
              BottomNavigationBarItem(
                  label: '',
                  icon:
                      SvgPicture.asset(IC_PROFILE, color: KxColors.neutral300),
                  activeIcon: CircleAvatar(
                      backgroundColor: primaryGreen600,
                      child: SvgPicture.asset(
                        IC_PROFILE,
                        color: Colors.black,
                      ))),
            ]),
            style: KxTabbarStyleEnum.withShadow,
            currentPage: currentPage,
            pageController: pageController,
            onTap: (value) {
              if (currentPage != value) {
                setState(() {
                  currentPage = value;
                });
                pageController.jumpToPage(value);
              }
            },
          ),
        ));
  }

  void _fetchRoom() async {
    final vm = ref.watch(accountProvider);
    final userAddress = await SessionService.getWalletAddress();
    final pgpPrivateKey = await SessionService.getPgpPrivateKey();
    vm.connectWebSocket(userAddress, pgpPrivateKey);
    ref.read(conversationsProvider).loadChats();
  }
}
