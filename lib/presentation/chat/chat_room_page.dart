import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/presentation/chat/components/chat_bubble_widget.dart';
import 'package:cengli/presentation/group/group_detail_page.dart';
import 'package:cengli/provider/chat_room_provider.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../values/values.dart';
import '../reusable/appbar/group_chat_appbar.dart';

class ChatRoomArgument {
  final Feeds room;

  ChatRoomArgument(this.room);
}

class ChatRoomPage extends ConsumerStatefulWidget {
  final ChatRoomArgument argument;

  const ChatRoomPage({super.key, required this.argument});

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatRoomPageState();
  static const String routeName = '/chat_room_page';
}

class _ChatRoomPageState extends ConsumerState<ChatRoomPage> {
  late Feeds room;

  @override
  void initState() {
    room = widget.argument.room;
    super.initState();
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
            appBarSubtitle:
                "${widget.argument.room.groupInformation?.members.length} Members",
            leadingCallBack: () => Navigator.of(context).pop(),
            trailingWidget: CircleAvatar(
              backgroundColor: primaryGreen600,
              child: SvgPicture.asset(IC_CREATE_EXPENSES),
            ),
            trailingCallBack: () => Navigator.of(context).pushNamed(
                GroupDetailPage.routeName,
                arguments: widget.argument.room.chatId),
            leadingWidget: Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                  color: KxColors.neutral200, shape: BoxShape.circle),
              child: const Icon(
                CupertinoIcons.person_2_fill,
                color: KxColors.neutral400,
              ),
            )),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                      child: roomVm.isLoading && messageList.isEmpty
                          ? const Center(child: CupertinoActivityIndicator())
                          : messageList.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(IMG_EMPTY_GROUP, width: 200),
                                    Text(
                                      "You create a group",
                                      textAlign: TextAlign.center,
                                      style: KxTypography(
                                          type: KxFontType.buttonMedium,
                                          color: KxColors.neutral700),
                                    ),
                                    8.0.height,
                                    Text(
                                      "Start a conversation or add shared expenses",
                                      textAlign: TextAlign.center,
                                      style: KxTypography(
                                          type: KxFontType.fieldText3,
                                          color: KxColors.neutral500),
                                    ),
                                  ],
                                ).padding(
                                  const EdgeInsets.symmetric(horizontal: 68))
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 4),
                                  itemCount: messageList.length,
                                  reverse: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  itemBuilder: (context, index) {
                                    final item = messageList[index];

                                    Stream<DocumentSnapshot> userStream =
                                        FirebaseFirestore.instance
                                            .collection(
                                                CollectionEnum.users.name)
                                            .doc(pCAIP10ToWallet(item.fromDID))
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

                                        debugPrint(item.messageType.toString());

                                        if (item.messageContent
                                            .contains("alert")) {
                                          return Container(
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.symmetric(
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
                                                  type: KxFontType.buttonSmall,
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
                                          ).padding(const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8));
                                        }
                                      },
                                    );
                                  },
                                )),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: KxColors.neutral50,
                              hintText: "Type here",
                              hintStyle: KxTypography(
                                  type: KxFontType.fieldText1,
                                  color: KxColors.neutral400),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
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
                  )
                ],
              ),
            )));
  }
}
