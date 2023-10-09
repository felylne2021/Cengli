import 'package:cengli/presentation/chat/group/conversations/conversations_provider.dart';
import 'package:cengli/push_protocol/push_restapi_dart.dart';
import 'package:cengli/push_protocol/src/models/src/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ethers/signers/wallet.dart' as ether;

final accountProvider = ChangeNotifierProvider((ref) => AccountProvider(ref));

class AccountProvider extends ChangeNotifier {
  final Ref ref;

  AccountProvider(this.ref);

  Wallet? pushWallet;

  Future<void> creatSocketConnection(String address, String pgpPrivateKey) async {
    final options = SocketInputOptions(
      user: address,
      env: ENV.staging,
      socketType: SOCKETTYPES.CHAT,
      socketOptions: SocketOptions(
        autoConnect: true,
        reconnectionAttempts: 3,
      ),
    );

    final pushSDKSocket = await createSocketConnection(options);
    if (pushSDKSocket == null) {
      throw Exception('PushSDKSocket Connection Failed');
    }

    pushSDKSocket.connect();

    pushSDKSocket.on(
      EVENTS.CONNECT,
      (data) async {
        print(' NOTIFICATION EVENTS.CONNECT: $data');
      },
    );
    // To get messages in realtime
    pushSDKSocket.on(EVENTS.CHAT_RECEIVED_MESSAGE, (message) {
      print('CHAT NOTIFICATION EVENTS.CHAT_RECEIVED_MESSAGE: $message');
      ref.read(conversationsProvider).onRecieveSocket(message);
    });

    // To get group creation or updation events
    pushSDKSocket.on(EVENTS.CHAT_GROUPS, (groupInfo) {
      print('CHAT NOTIFICATION EVENTS.CHAT_GROUPS: $groupInfo');
      ref.read(conversationsProvider).onRecieveSocket(groupInfo);
    });

    pushSDKSocket.on(
      EVENTS.DISCONNECT,
      (data) {
        print(' NOTIFICATION EVENTS.DISCONNECT: $data');
      },
    );

    ref.read(conversationsProvider).setAddress(address, pgpPrivateKey);
    ref.read(conversationsProvider).reset();
  }

  logOut() {
    pushWallet = null;
    notifyListeners();
  }
}
