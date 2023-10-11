import 'package:cengli/presentation/chat/components/chat_bubble_widget.dart';
import 'package:cengli/provider/chat_room_provider.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinetix/kinetix.dart';

class ChatRoomArgument {
  final String walletAddress;
  final Feeds room;

  ChatRoomArgument(this.walletAddress, this.room);
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
      appBar: KxAppBarLeftTitle(
        elevationType: KxElevationAppBarEnum.noShadow,
        appBarTitle: widget.argument.room.groupInformation?.groupName ?? "",
        subtitle:
            "${widget.argument.room.groupInformation?.members.length} Members",
        leadingWidget: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            border: Border.all(color: KxColors.auxiliary600),
            shape: BoxShape.circle,
            color: KxColors.auxiliary600,
          ),
        ),
        trailingWidgets: [
          InkWell(
            onTap: () {},
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: roomVm.isLoading && messageList.isEmpty
                      ? const Center(child: CupertinoActivityIndicator())
                      : messageList.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "You create a group",
                                  textAlign: TextAlign.center,
                                  style: KxTypography(
                                      type: KxFontType.body2,
                                      color: KxColors.neutral500),
                                ),
                                8.0.height,
                                Text(
                                  "Start a conversation or add shared expenses",
                                  textAlign: TextAlign.center,
                                  style: KxTypography(
                                      type: KxFontType.fieldText3,
                                      color: KxColors.neutral500),
                                ),
                                32.0.height,
                                KxTextButton(
                                    argument: KxTextButtonArgument(
                                        buttonText: "Add Expenses",
                                        buttonColor: KxColors.auxiliary700,
                                        textColor: KxColors.neutral700,
                                        onPressed: () {},
                                        buttonSize: KxButtonSizeEnum.small,
                                        buttonType: KxButtonTypeEnum.primary,
                                        buttonShape: KxButtonShapeEnum.square,
                                        buttonContent:
                                            KxButtonContentEnum.text)),
                              ],
                            ).padding(
                              const EdgeInsets.symmetric(horizontal: 68))
                          : ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 4),
                              itemCount: messageList.length,
                              reverse: true,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              itemBuilder: (context, index) {
                                final item = messageList[index];

                                return ChatBubbleWidget(
                                        name: pCAIP10ToWallet(item.fromDID),
                                        message: item.messageContent,
                                        date:
                                            DateTime.fromMillisecondsSinceEpoch(
                                                item.timestamp ?? 0))
                                    .padding(const EdgeInsets.symmetric(
                                        horizontal: 16));
                              },
                            )),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                decoration:
                    KxShadowDecoration(style: KxShadowStyleEnum.elevationTwo),
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: KxColors.auxiliary700,
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
        ),
      ),
    );
  }
}
