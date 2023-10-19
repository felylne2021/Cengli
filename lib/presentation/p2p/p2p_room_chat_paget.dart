import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/presentation/chat/components/chat_bubble_widget.dart';
import 'package:cengli/presentation/p2p/components/order_item_widget.dart';
import 'package:cengli/presentation/p2p/order_detail_page.dart';
import 'package:cengli/provider/chat_room_provider.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart' as push;
import 'package:cengli/services/push_protocol/src/helpers/src/converters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';
import 'package:intl/intl.dart';

import '../../bloc/membership/membership.dart';
import '../../data/modules/auth/model/user_profile.dart';
import '../../utils/utils.dart';
import '../../values/values.dart';
import '../reusable/appbar/group_chat_appbar.dart';

class P2pChatRoomArgument {
  final push.Feeds room;
  final UserProfile user;

  P2pChatRoomArgument(this.room, this.user);
}

class P2pChatRoomPage extends ConsumerStatefulWidget {
  final P2pChatRoomArgument argument;

  const P2pChatRoomPage({super.key, required this.argument});

  @override
  ConsumerState<P2pChatRoomPage> createState() => _P2pChatRoomPageState();
  static const String routeName = '/p2p_chat_room_page';
}

class _P2pChatRoomPageState extends ConsumerState<P2pChatRoomPage> {
  late push.Feeds room;

  @override
  void initState() {
    room = widget.argument.room;
    super.initState();
    _getGroupOrder();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final roomVm = ref.watch(chatRoomProvider);
    final messageList = roomVm.messageList;

    return Scaffold(
        key: _scaffoldKey,
        appBar: GroupChatAppbar(
            appBarTitle: widget.argument.room.groupInformation?.groupName ?? "",
            appBarSubtitle: "P2P Order",
            leadingCallBack: () => Navigator.of(context).pop(),
            trailingWidget: const SizedBox(),
            trailingCallBack: () {},
            leadingWidget: Container(
              height: 48,
              width: 48,
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: softPurple, shape: BoxShape.circle),
              child: SvgPicture.asset(IC_P2P),
            )),
        body: MultiBlocListener(
            listeners: [
              BlocListener<MembershipBloc, MembershipState>(
                  listenWhen: (previous, state) {
                return state is GetGroupOrderSuccessState ||
                    state is GetGroupOrderErrorState;
              }, listener: ((context, state) {
                if (state is GetGroupOrderErrorState) {
                  showToast(state.message);
                } else if (state is GetGroupOrderSuccessState) {
                  _getOrder(state.group.p2pOrderId ?? "");
                }
              })),
            ],
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    BlocBuilder<TransferBloc, TransferState>(
                      buildWhen: (previous, state) {
                        return state is GetOrderSuccessState ||
                            state is GetOrderErrorState ||
                            state is GetOrderLoadingState;
                      },
                      builder: (context, state) {
                        if (state is GetOrderSuccessState) {
                          return OrderItemWidget(
                              status:
                                  _getStatus(state.orderResponse.status ?? ""),
                              amount:
                                  "Amount: ${NumberFormat.currency(locale: 'en_US', symbol: '').format(state.orderResponse.amount)} USDC",
                              detailsCallback: () => Navigator.of(context)
                                      .pushNamed(OrderDetailPage.routeName,
                                          arguments: OrderDetailArgument(
                                              state.orderResponse.id ?? "",
                                              widget.argument.user))
                                      .then((value) {
                                    if (value != null) {
                                      _getGroupOrder();
                                      OrderStatusEventEnum status =
                                          value as OrderStatusEventEnum;
                                      switch (status) {
                                        case OrderStatusEventEnum.accept:
                                          roomVm.controller.text =
                                              "alert:${widget.argument.user.name ?? ""} accepted the order";
                                          break;
                                        case OrderStatusEventEnum.cancel:
                                          roomVm.controller.text =
                                              "alert:${widget.argument.user.name ?? ""} canceled the order";
                                          break;
                                        case OrderStatusEventEnum.payment:
                                          roomVm.controller.text =
                                              "alert:${widget.argument.user.name ?? ""} completed the payment";
                                          break;
                                        case OrderStatusEventEnum.fund:
                                          roomVm.controller.text =
                                              "alert:${widget.argument.user.name ?? ""} confirm recieved the cash and complete order";
                                          break;
                                      }

                                      if (!roomVm.isSending) {
                                        roomVm.onSendMessage();
                                      }
                                    }
                                  }));
                        } else {
                          return const CupertinoActivityIndicator();
                        }
                      },
                    ),
                    Expanded(
                        child: roomVm.isLoading && messageList.isEmpty
                            ? const Center(child: CupertinoActivityIndicator())
                            : messageList.isEmpty
                                ? Text(
                                    "Start a conversation",
                                    textAlign: TextAlign.center,
                                    style: KxTypography(
                                        type: KxFontType.body2,
                                        color: KxColors.neutral500),
                                  )
                                    .padding(const EdgeInsets.symmetric(
                                        horizontal: 68))
                                    .center()
                                : ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 4),
                                    itemCount: messageList.length,
                                    reverse: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    itemBuilder: (context, index) {
                                      final item = messageList[index];
                                      Stream<DocumentSnapshot> userStream =
                                          FirebaseFirestore.instance
                                              .collection(
                                                  CollectionEnum.users.name)
                                              .doc(
                                                  pCAIP10ToWallet(item.fromDID))
                                              .snapshots();
                                      return StreamBuilder<DocumentSnapshot>(
                                        stream: userStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          if (!snapshot.hasData) {
                                            return const CupertinoActivityIndicator(); // Loading indicator
                                          }

                                          String username =
                                              snapshot.data?['userName'] ?? "";
                                          String profileIcon =
                                              snapshot.data?['imageProfile'] ??
                                                  "";

                                          if (item.messageContent
                                              .contains("alert")) {
                                            return Container(
                                              padding: const EdgeInsets.all(12),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                  color: KxColors.neutral100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          40.5)),
                                              child: Text(
                                                item.messageContent
                                                    .split(":")
                                                    .last,
                                                style: KxTypography(
                                                    type:
                                                        KxFontType.buttonSmall,
                                                    color: KxColors.neutral500),
                                              ),
                                            );
                                          } else {
                                            return ChatBubbleWidget(
                                              name: username,
                                              message: item.messageContent,
                                              date: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      item.timestamp ?? 0),
                                              image: profileIcon,
                                            ).padding(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8));
                                          }
                                        },
                                      );
                                    },
                                  )),
                    BlocBuilder<TransferBloc, TransferState>(
                      builder: (context, state) {
                        if (state is GetOrderSuccessState) {
                          if (state.orderResponse.status == "C" ||
                              state.orderResponse.status == "CB") {
                            return Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 60),
                                decoration: KxShadowDecoration(
                                    style: KxShadowStyleEnum.elevationTwo),
                                child: Text(
                                  "You can't send messages to this group because the chat session has ended.",
                                  style: KxTypography(
                                      type: KxFontType.caption2,
                                      color: KxColors.neutral500),
                                  textAlign: TextAlign.center,
                                ));
                          } else {
                            return Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 60),
                              decoration: KxShadowDecoration(
                                  style: KxShadowStyleEnum.elevationTwo),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: roomVm.controller,
                                    minLines: 1,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide: BorderSide.none,
                                        ),
                                        fillColor: KxColors.neutral50,
                                        hintText: "Type here",
                                        hintStyle: KxTypography(
                                            type: KxFontType.fieldText1,
                                            color: KxColors.neutral400),
                                        errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        )),
                                  )),
                                  const SizedBox(width: 12),
                                  InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        if (!roomVm.isSending) {
                                          roomVm.onSendMessage();
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryGreen600,
                                        ),
                                        child: roomVm.isSending
                                            ? const CupertinoActivityIndicator()
                                            : const Center(
                                                child: Icon(
                                                  Icons.send,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ))
                                ],
                              ),
                            );
                          }
                        } else {
                          return Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 60),
                              width: MediaQuery.of(context).size.width,
                              decoration: KxShadowDecoration(
                                  style: KxShadowStyleEnum.elevationTwo),
                              child: const CupertinoActivityIndicator());
                        }
                      },
                    )
                  ],
                ),
              ),
            )));
  }

  String _getStatus(String status) {
    switch (status) {
      case "WFSAC":
        return "Waiting for seller to accept";
      case "WFBP":
        return "Waiting for buyer payment";
      case "WFSA":
        return "Waiting for seller approval";
      case "C":
        return "Completed";
      case "CB":
        return "Cancelled by buyer";
      default:
        return "Cancelled by seller";
    }
  }

  _getGroupOrder() async {
    context
        .read<MembershipBloc>()
        .add(GetGroupOrderEvent(widget.argument.room.chatId ?? ""));
  }

  _getOrder(String orderId) async {
    context.read<TransferBloc>().add(GetOrderEvent(orderId));
  }
}
