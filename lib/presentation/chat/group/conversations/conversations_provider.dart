import 'package:cengli/presentation/chat/group/chat_room/chat_room_provider.dart';
import 'package:cengli/push_protocol/push_restapi_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final conversationsProvider =
    ChangeNotifierProvider((ref) => ConversationsProvider(ref));

class ConversationsProvider extends ChangeNotifier {
  final Ref ref;
  ConversationsProvider(this.ref);

  bool isBusy = false;
  setBusy(bool state) {
    isBusy = state;
    notifyListeners();
  }

  List<Feeds> _conversations = [];
  List<Feeds> get conversations => _conversations;

  String _address = '';
  String _pgpPrivateKey = '';

  setAddress(String address, String pgpPrivateKey) {
    _address = address;
    _pgpPrivateKey = pgpPrivateKey;
    notifyListeners();
    loadChats();
  }

  Future loadChats() async {
    setBusy(true);
    final result = await chats(
        pgpPrivateKey: _pgpPrivateKey,
        accountAddress: _address,
        toDecrypt: true);
    if (result != null) {
      _conversations = result;

      notifyListeners();
    }
    setBusy(false);
  }

  reset() {
    _conversations = [];
    notifyListeners();
    loadChats();
  }

  onRecieveSocket(dynamic message) {
    try {
      loadChats();

      final chatId = (message as Map)['chatId'];
      final currentChatid = ref.read(chatRoomProvider).currentChatId;
      if (chatId == currentChatid) {
        ref.read(chatRoomProvider).getRoomMessages();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
