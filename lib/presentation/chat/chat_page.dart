import 'package:cengli/presentation/chat/components/chat_profile_image_widget.dart';
import 'package:cengli/presentation/chat/chat_room_page.dart';
import 'package:cengli/presentation/group/create_group_member_page.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/provider/chat_room_provider.dart';
import 'package:cengli/provider/conversations_provider.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cengli/values/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/membership/membership.dart';
import '../../utils/widget_util.dart';
import 'components/chat_item_widget.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatePageState();
  static const String routeName = '/chat_page';
}

class _ChatePageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
    super.initState();
    _fetchChatRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(
          leadingWidget: 50.0.width,
          appbarTitle: 'Chats',
          trailingWidgets: [
            InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(CreateGroupMemberPage.routeName),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: KxColors.neutral200, shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    IC_CREATE_CHAT,
                    width: 20,
                  )),
            )
          ],
        ),
        body: MultiBlocListener(listeners: [
          BlocListener<MembershipBloc, MembershipState>(
              listenWhen: (previous, state) {
            return state is ApproveChatLoadingState ||
                state is ApproveChatErrorState ||
                state is ApproveChatSuccessState;
          }, listener: ((context, state) {
            if (state is ApproveChatSuccessState) {
              _fetchChatRequest();
              hideLoading();
            } else if (state is ApproveChatLoadingState) {
              showLoading();
            } else if (state is ApproveChatErrorState) {
              hideLoading();
              showToast(state.message);
            }
          })),
        ], child: _body()));
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Column(
      children: [
        BlocBuilder<MembershipBloc, MembershipState>(
          buildWhen: (context, state) {
            return state is GetChatRequestLoadingState ||
                state is GetChatRequestEmptyState ||
                state is GetChatRequestErrorState ||
                state is GetChatRequestSuccessState;
          },
          builder: (context, state) {
            if (state is GetChatRequestSuccessState) {
              final spaces = state.feeds
                  .where((item) =>
                      item.groupInformation?.groupDescription != "P2P Order")
                  .toList();

              return Column(
                children: [
                  Column(
                    children: List.generate(spaces.length, (index) {
                      final item = spaces[index];
                      final image = item.groupInformation?.groupImage ??
                          item.profilePicture ??
                          '';
                      final groupDesc =
                          item.groupInformation?.groupDescription ?? "";
                      final lastMessage = item.msg?.messageContent ?? "";
                      return ChatItemWidget(
                        imageIcon: ProfileProfileImageWidget(
                            imageUrl: image, isP2p: false),
                        title:
                            '${item.groupInformation?.groupName ?? item.intentSentBy}',
                        caption:
                            lastMessage.isNotEmpty ? lastMessage : groupDesc,
                        isNeedApproval: true,
                        acceptCallback: () =>
                            _approve(item.groupInformation?.chatId ?? ""),
                        isShowDivider: spaces.length != 1,
                      );
                    }),
                  ),
                  8.0.height,
                  const Divider(
                    color: KxColors.neutral200,
                    thickness: 4,
                  ),
                ],
              ).visibility(spaces.isNotEmpty);
            }
            return const SizedBox();
          },
        ),
        Consumer(
          builder: (context, ref, child) {
            final vm = ref.watch(conversationsProvider);
            final spaces = vm.conversations
                .where((item) =>
                    item.groupInformation?.groupDescription != "P2P Order")
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
                    "No Conversation Found",
                    style: KxTypography(
                        type: KxFontType.buttonMedium,
                        color: KxColors.neutral700),
                  ),
                  8.0.height,
                  Text(
                    "Start a new conversation and connect with friends, family, or colleagues!",
                    style: KxTypography(
                        type: KxFontType.fieldText3,
                        color: KxColors.neutral500),
                    textAlign: TextAlign.center,
                  )
                ],
              ).padding(const EdgeInsets.symmetric(horizontal: 60));
            }

            return Column(
              children: List.generate(spaces.length, (index) {
                final item = spaces[index];
                final image = item.groupInformation?.groupImage ??
                    item.profilePicture ??
                    '';
                final groupDesc = item.groupInformation?.groupDescription ?? "";
                final lastMessage = item.msg?.messageContent ?? "";

                return InkWell(
                  onTap: () {
                    ref.read(chatRoomProvider).setCurrentChatId(item.chatId!);
                    ref.read(chatRoomProvider).setGroupName(
                        item.groupInformation?.groupName ?? "Group");
                    ref.read(chatRoomProvider).setMembers(item
                            .groupInformation?.members
                            .map((value) => pCAIP10ToWallet(value.wallet))
                            .toList() ??
                        []);
                    Navigator.of(context).pushNamed(ChatRoomPage.routeName,
                        arguments: ChatRoomArgument(item));
                  },
                  child: ChatItemWidget(
                    imageIcon: ProfileProfileImageWidget(
                      imageUrl: image,
                      isP2p: false,
                    ),
                    title:
                        '${item.groupInformation?.groupName ?? item.intentSentBy}',
                    caption: lastMessage.isNotEmpty ? lastMessage : groupDesc,
                    isNeedApproval: false,
                  ),
                );
              }),
            );
          },
        ),
      ],
    ));
  }

  _fetchChatRequest() async {
    context.read<MembershipBloc>().add(const GetChatRequestEvent());
  }

  _approve(String senderAddress) {
    context.read<MembershipBloc>().add(ApproveEvent(senderAddress));
  }
}
