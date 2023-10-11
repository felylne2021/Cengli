import 'package:cengli/presentation/chat/chat_new_page.dart';
import 'package:cengli/presentation/chat/components/chat_profile_image_widget.dart';
import 'package:cengli/presentation/chat/chat_room_page.dart';
import 'package:cengli/provider/chat_room_provider.dart';
import 'package:cengli/provider/conversations_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinetix/kinetix.dart';

import '../../provider/account_provider.dart';
import '../../services/services.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatePageState();
  static const String routeName = '/chat_page';
}

class _ChatePageState extends ConsumerState<ChatPage> {
  String walletAddress = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchRoom();
    });
  }

  @override
  void dispose() {
    ref.watch(accountProvider).disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KxAppBarCenterTitle(
        elevationType: KxElevationAppBarEnum.ghost,
        appBarTitle: "Chats",
        leadingWidget: const SizedBox(width: 24),
        leadingCallback: () {},
        trailingWidgets: [
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(ChatNewPage.routeName),
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final vm = ref.watch(conversationsProvider);
          final spaces = vm.conversations;
          if (vm.isBusy && spaces.isEmpty) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 24),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final item = spaces[index];
              final image = item.groupInformation?.groupImage ??
                  item.profilePicture ??
                  '';

              return ListTile(
                onTap: () {
                  ref.read(chatRoomProvider).setCurrentChatId(item.chatId!);
                  if (walletAddress.isNotEmpty) {
                    Navigator.of(context).pushNamed(ChatRoomPage.routeName,
                        arguments: ChatRoomArgument(walletAddress, item));
                  }
                },
                leading: ProfileProfileImageWidget(imageUrl: image),
                title: Text(
                  '${item.groupInformation?.groupName ?? item.intentSentBy}',
                ),
                titleTextStyle: KxTypography(
                    type: KxFontType.subtitle3, color: KxColors.neutral700),
                subtitle: Text(
                  item.msg?.messageContent ??
                      (item.groupInformation?.groupDescription ?? ""),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitleTextStyle: KxTypography(
                    type: KxFontType.body2, color: KxColors.neutral100),
              );
            },
          );
        },
      ),
    );
  }

  void _fetchRoom() async {
    final vm = ref.watch(accountProvider);
    final userAddress = await SessionService.getWalletAddress();
    final pgpPrivateKey = await SessionService.getPgpPrivateKey();
    walletAddress = userAddress;
    debugPrint(userAddress);
    vm.connectWebSocket(userAddress, pgpPrivateKey);
    ref.read(conversationsProvider).loadChats();
  }
}
