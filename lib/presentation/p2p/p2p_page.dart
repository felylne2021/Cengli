import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/chat/components/chat_item_widget.dart';
import 'package:cengli/presentation/chat/components/chat_profile_image_widget.dart';
import 'package:cengli/presentation/p2p/components/p2p_item_widget.dart';
import 'package:cengli/presentation/p2p/p2p_request_page.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/utils/utils.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinetix/kinetix.dart';

import '../../provider/chat_room_provider.dart';
import '../../provider/conversations_provider.dart';
import '../chat/chat_room_page.dart';
import '../reusable/segmented_control/segmented_control.dart';

class P2pPage extends ConsumerStatefulWidget {
  final UserProfile user;
  const P2pPage({super.key, required this.user});
  static const String routeName = '/p2p_page';

  @override
  ConsumerState<P2pPage> createState() => _P2pPageState();
}

class _P2pPageState extends ConsumerState<P2pPage> {
  List<String> segmentedTitles = ['Buy', 'Order'];
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _fetchPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: 'P2P'),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SegmentedControl(
              activeColor: primaryGreen600,
              onSelected: (index) {
                currentIndex.value = index;
                if (index == 0) {
                  _fetchPartners();
                } else {
                  _fetchChatRequest();
                }
              },
              title: segmentedTitles,
              initialIndex: currentIndex.value,
              segmentType: SegmentedControlEnum.ghost,
              padding: 50,
            ),
            16.0.height,
            ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, value, child) {
                switch (value) {
                  case 0:
                    return Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(5, 12, 12, 12),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                color: primaryGreen100,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Image.asset(
                                  IMG_TOPUP,
                                  width: 83,
                                  height: 83,
                                ),
                                10.0.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Turn cash into crypto instantly",
                                      style: KxTypography(
                                          type: KxFontType.subtitle4,
                                          color: KxColors.neutral700),
                                    ),
                                    8.0.height,
                                    Text(
                                      "Easily Transform your physical cash into digital currency through Cengli Partners",
                                      style: KxTypography(
                                          type: KxFontType.caption4,
                                          color: KxColors.neutral600),
                                    ),
                                  ],
                                ).flexible()
                              ],
                            )),
                        BlocBuilder<MembershipBloc, MembershipState>(
                          buildWhen: (previous, state) {
                            return state is FetchP2pSuccessState ||
                                state is FetchP2pLoadingState ||
                                state is FetchP2pErrorState;
                          },
                          builder: (context, state) {
                            if (state is FetchP2pSuccessState) {
                              debugPrint(state.partners.toString());
                              return Column(
                                  children: List.generate(
                                      state.partners.length,
                                      (index) => InkWell(
                                          onTap: () => Navigator.of(context)
                                              .pushNamed(
                                                  P2pRequestPage.routeName),
                                          child: P2pItemWidget(
                                            name: state
                                                    .partners[index].userName ??
                                                "",
                                            quantity: "1.062, 00 USDC",
                                            method: "Cash and Transfer",
                                          ))));
                            } else {
                              return const CupertinoActivityIndicator()
                                  .padding(const EdgeInsets.only(top: 40));
                            }
                          },
                        )
                      ],
                    );
                  default:
                    return _orderChats();
                }
              },
            )
          ],
        )));
  }

  _orderChats() {
    return MultiBlocListener(
        listeners: [
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
        ],
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
                          item.groupInformation?.groupDescription ==
                          "P2P Order")
                      .toList();
                  if (spaces.isNotEmpty) {
                    return Column(
                      children: [
                        Column(
                          children: List.generate(spaces.length, (index) {
                            final item = spaces[index];
                            final image = item.groupInformation?.groupImage ??
                                item.profilePicture ??
                                '';
                            return ChatItemWidget(
                              imageIcon: ProfileProfileImageWidget(
                                imageUrl: image,
                                isP2p: true,
                              ),
                              title:
                                  '${item.groupInformation?.groupName ?? item.intentSentBy}',
                              caption: "New Order",
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
                    );
                  } else {
                    return const SizedBox();
                  }
                } else if (state is GetChatRequestLoadingState) {
                  return const CupertinoActivityIndicator();
                } else {
                  return const SizedBox();
                }
              },
            ),
            Consumer(
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
                            type: KxFontType.buttonMedium,
                            color: KxColors.neutral700),
                      ),
                    ],
                  ).padding(const EdgeInsets.symmetric(horizontal: 60));
                }

                return Column(
                  children: List.generate(spaces.length, (index) {
                    final item = spaces[index];
                    final image = item.groupInformation?.groupImage ??
                        item.profilePicture ??
                        '';
                    final groupDesc =
                        item.groupInformation?.groupDescription ?? "";
                    final lastMessage = item.msg?.messageContent ?? "";

                    return InkWell(
                      onTap: () {
                        ref
                            .read(chatRoomProvider)
                            .setCurrentChatId(item.chatId!);
                        Navigator.of(context).pushNamed(ChatRoomPage.routeName,
                            arguments: ChatRoomArgument(item));
                      },
                      child: ChatItemWidget(
                        imageIcon: ProfileProfileImageWidget(
                          imageUrl: image,
                          isP2p: true,
                        ),
                        title:
                            '${item.groupInformation?.groupName ?? item.intentSentBy}',
                        caption:
                            lastMessage.isNotEmpty ? lastMessage : groupDesc,
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

  _fetchPartners() {
    context.read<MembershipBloc>().add(const FetchP2pEvent());
  }

  _approve(String senderAddress) {
    context.read<MembershipBloc>().add(ApproveEvent(senderAddress));
  }
}
