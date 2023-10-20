import 'package:cengli/presentation/chat/components/chat_item_widget.dart';
import 'package:cengli/presentation/chat/components/chat_profile_image_widget.dart';
import 'package:cengli/presentation/p2p/p2p_request_page.dart';
import 'package:cengli/presentation/p2p/p2p_room_chat_paget.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/provider/chat_room_provider.dart';
import 'package:cengli/provider/conversations_provider.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cengli/values/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinetix/kinetix.dart';

class P2pUserChatPage extends ConsumerStatefulWidget {
  final P2pArgument argument;
  const P2pUserChatPage({super.key, required this.argument});

  @override
  ConsumerState<P2pUserChatPage> createState() => _ChatePageState();
  static const String routeName = '/p2p_user_chat_page';
}

class _ChatePageState extends ConsumerState<P2pUserChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "Transactions"),
        body: _body());
  }

  _body() {
    return Consumer(
      builder: (context, ref, child) {
        final vm = ref.watch(conversationsProvider);
        final spaces = vm.conversations
            .where((item) =>
                item.groupInformation?.groupDescription == "P2P Order")
            .toList();
        if (vm.isBusy) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (spaces.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              60.0.height,
              Image.asset(IMG_EMPTY_CHAT),
              Text(
                "No Orders Found",
                style: KxTypography(
                    type: KxFontType.buttonMedium, color: KxColors.neutral700),
              ),
            ],
          ).padding(const EdgeInsets.symmetric(horizontal: 60));
        }

        return Column(
          children: List.generate(spaces.length, (index) {
            final item = spaces[index];
            final image =
                item.groupInformation?.groupImage ?? item.profilePicture ?? '';
            final groupDesc = item.groupInformation?.groupDescription ?? "";
            final lastMessage = item.msg?.messageContent ?? "";

            return InkWell(
              onTap: () {
                ref.read(chatRoomProvider).setCurrentChatId(item.chatId!);
                ref.read(chatRoomProvider).setCurrentChatId(item.chatId!);
                ref
                    .read(chatRoomProvider)
                    .setGroupName(item.groupInformation?.groupName ?? "");
                ref.read(chatRoomProvider).setMembers(item
                        .groupInformation?.members
                        .map((value) => pCAIP10ToWallet(value.wallet))
                        .toList() ??
                    []);
                Navigator.of(context).pushNamed(P2pChatRoomPage.routeName,
                    arguments: P2pChatRoomArgument(item, widget.argument.user));
              },
              child: ChatItemWidget(
                imageIcon: ProfileProfileImageWidget(
                  imageUrl: image,
                  isP2p: true,
                ),
                title:
                    '${item.groupInformation?.groupName ?? item.intentSentBy}',
                caption: lastMessage.isNotEmpty ? lastMessage : groupDesc,
                isNeedApproval: false,
              ),
            );
          }),
        ).padding(const EdgeInsets.only(top: 24));
      },
    );
  }
}
