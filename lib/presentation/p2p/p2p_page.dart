import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/presentation/chat/components/chat_item_widget.dart';
import 'package:cengli/presentation/chat/components/chat_profile_image_widget.dart';
import 'package:cengli/presentation/p2p/components/p2p_item_widget.dart';
import 'package:cengli/presentation/p2p/p2p_request_page.dart';
import 'package:cengli/presentation/p2p/p2p_room_chat_paget.dart';
import 'package:cengli/presentation/p2p/p2p_user_chat_page.dart';
import 'package:cengli/presentation/p2p/partner_registration_page.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/utils/utils.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';
import 'package:intl/intl.dart';

import '../../provider/chat_room_provider.dart';
import '../../provider/conversations_provider.dart';
import '../../services/push_protocol/src/helpers/helpers.dart';
import '../reusable/segmented_control/segmented_control.dart';

class P2pPage extends ConsumerStatefulWidget {
  final P2pArgument argument;

  const P2pPage({super.key, required this.argument});
  static const String routeName = '/p2p_page';

  @override
  ConsumerState<P2pPage> createState() => _P2pPageState();
}

class _P2pPageState extends ConsumerState<P2pPage> {
  List<String> segmentedTitles = ['Buy', 'Order'];
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> isRegistProceed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _fetchPartners();
    if (widget.argument.user.userRole == UserRoleEnum.user.name) {
      _getRegistration(widget.argument.user.walletAddress ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarBackAndCenter(
          appbarTitle: "P2P",
          trailingWidgets: [
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                  P2pUserChatPage.routeName,
                  arguments: P2pArgument(const GetPartnersResponse(),
                      widget.argument.user, widget.argument.chainId)),
              child: SvgPicture.asset(IC_TRANSACTION, width: 40, height: 40),
            ).visibility(
                widget.argument.user.userRole == UserRoleEnum.user.name)
          ],
        ),
        body: BlocListener<MembershipBloc, MembershipState>(
            listenWhen: (previous, state) {
              return state is GetRegistrationErrorState ||
                  state is GetRegistrationLoadingState ||
                  state is GetRegistrationSuccessState;
            },
            listener: (context, state) {
              if (state is GetRegistrationSuccessState) {
                hideLoading();
                if (state.registration != null) {
                  isRegistProceed.value = state.registration?.status ==
                      RegistrationStatusEnum.onproses.name;
                } else {
                  isRegistProceed.value = false;
                }
              } else if (state is GetRegistrationLoadingState) {
                showLoading();
              } else if (state is GetChatRequestErrorState) {
                debugPrint("failed");
                hideLoading();
                showToast(state.message);
              }
            },
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SegmentedControl(
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
                          currentIndex: currentIndex,
                          segmentType: SegmentedControlEnum.ghost,
                          padding: 16,
                        ))
                    .visibility(widget.argument.user.userRole ==
                        UserRoleEnum.partner.name),
                ValueListenableBuilder(
                  valueListenable: currentIndex,
                  builder: (context, value, child) {
                    switch (value) {
                      case 0:
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 12, 12, 12),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            ValueListenableBuilder(
                                    valueListenable: isRegistProceed,
                                    builder: (context, value, child) {
                                      if (value) {
                                        return Container(
                                          padding: const EdgeInsets.all(16),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: KxShadowStyleEnum
                                                  .elevationTwo
                                                  .getShadows(),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Registration Status",
                                                  style: KxTypography(
                                                      type: KxFontType.caption2,
                                                      color:
                                                          KxColors.neutral500)),
                                              4.0.height,
                                              Text("On Process",
                                                  style: KxTypography(
                                                      type:
                                                          KxFontType.subtitle4,
                                                      color:
                                                          KxColors.neutral700)),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return KxTextButton(
                                            argument: KxTextButtonArgument(
                                                onPressed: () => Navigator.of(context)
                                                    .pushNamed(PartnerRegistrationPage.routeName,
                                                        arguments: widget
                                                            .argument.user)
                                                    .then((value) =>
                                                        _getRegistration(widget
                                                                .argument
                                                                .user
                                                                .walletAddress ??
                                                            "")),
                                                buttonText:
                                                    "Register as Cengli Partner",
                                                buttonColor: primaryGreen600,
                                                buttonTextStyle: KxTypography(
                                                    type:
                                                        KxFontType.buttonMedium,
                                                    color: KxColors.neutral700),
                                                buttonSize:
                                                    KxButtonSizeEnum.medium,
                                                buttonType: KxButtonTypeEnum.primary,
                                                buttonShape: KxButtonShapeEnum.square,
                                                buttonContent: KxButtonContentEnum.text));
                                      }
                                    })
                                .padding(
                                    const EdgeInsets.fromLTRB(16, 12, 16, 0))
                                .visibility(widget.argument.user.userRole ==
                                    UserRoleEnum.user.name),
                            24.0.height,
                            Text(
                              "Buy From",
                              style: KxTypography(
                                  type: KxFontType.fieldText3,
                                  color: KxColors.neutral500),
                            ).padding(
                                const EdgeInsets.symmetric(horizontal: 16)),
                            BlocBuilder<TransferBloc, TransferState>(
                              buildWhen: (previous, state) {
                                return state is GetPartnersSuccessState ||
                                    state is GetPartnersLoadingState ||
                                    state is GetPartnersErrorState;
                              },
                              builder: (context, state) {
                                if (state is GetPartnersSuccessState) {
                                  return Column(
                                      children: List.generate(
                                          state.partners.length, (index) {
                                    final partner = state.partners[index];

                                    return InkWell(
                                        onTap: () => Navigator.of(context)
                                                .pushNamed(
                                                    P2pRequestPage.routeName,
                                                    arguments: P2pArgument(
                                                        partner,
                                                        widget.argument.user,
                                                        widget
                                                            .argument.chainId))
                                                .then((value) {
                                              if (value != null) {
                                                currentIndex.value = 1;
                                              }
                                            }),
                                        child: P2pItemWidget(
                                            name: partner.name ?? "",
                                            quantity: partner.balances != null
                                                ? "${NumberFormat.currency(locale: 'en_US', symbol: '').format(partner.balances?.first.amount)} ${partner.balances?.first.token?.symbol ?? ""}"
                                                : "Loading ...",
                                            image: partner.chain?.logoURI ?? "",
                                            chainName: partner.chain?.chainName
                                                    ?.split(" ")
                                                    .first ??
                                                ""));
                                  }));
                                } else {
                                  return const CupertinoActivityIndicator()
                                      .padding(const EdgeInsets.only(top: 40))
                                      .center();
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
            ))));
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
                              isShowDivider: spaces.length != 1 &&
                                  index != (spaces.length - 1),
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
                        ref
                            .read(chatRoomProvider)
                            .setCurrentChatId(item.chatId!);
                        ref.read(chatRoomProvider).setGroupName(
                            item.groupInformation?.groupName ?? "");
                        ref.read(chatRoomProvider).setMembers(item
                                .groupInformation?.members
                                .map((value) => pCAIP10ToWallet(value.wallet))
                                .toList() ??
                            []);
                        ref.read(chatRoomProvider).setIsp2p(true);
                        Navigator.of(context).pushNamed(
                            P2pChatRoomPage.routeName,
                            arguments: P2pChatRoomArgument(
                                item, widget.argument.user));
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
        )).visibility(widget
            .argument.user.userRole ==
        UserRoleEnum.partner.name);
  }

  _fetchChatRequest() async {
    context.read<MembershipBloc>().add(const GetChatRequestEvent());
  }

  _fetchPartners() {
    context.read<TransferBloc>().add(const GetPartnersEvent());
  }

  _approve(String senderAddress) {
    context.read<MembershipBloc>().add(ApproveEvent(senderAddress));
  }

  _getRegistration(String walletAddress) {
    context.read<MembershipBloc>().add(GetRegistrationEvent(walletAddress));
  }
}
