import '../../../push_restapi_dart.dart';

/// Return the latest message from all wallet addresses you have talked to.
/// This can be used when building the inbox page.
///
///toDecrypt: If true, the method will return decrypted message content in response
///page index - default 1
///limit: no of items per page - default 10 - max 30
Future<List<Feeds>?> chats({
  String? accountAddress,
  String? pgpPrivateKey,
  bool toDecrypt = false,
  int page = 1,
  int limit = 10,
}) async {
  accountAddress ??= getCachedWallet()?.address;
  if (accountAddress == null) {
    throw Exception('Account address is required.');
  }

  if (!isValidETHAddress(accountAddress)) {
    //TODO: unhide
    // throw Exception('Invalid address $accountAddress');
  }

  pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;
  if (toDecrypt && pgpPrivateKey == null) {
    throw Exception('Private Key is required.');
  }

  if (!isValidETHAddress(accountAddress)) {
    //TODO: unhide
    // throw Exception('Invalid address!');
  }

  try {
    final userDID = await getUserDID(address: accountAddress);
    final result = await http.get(
      path: '/v1/chat/users/$userDID/chats?page=$page&limit=$limit',
    );

    if (result == null || result['chats'] == null) {
      return null;
    }

    final chatList =
        (result['chats'] as List).map((e) => Feeds.fromJson(e)).toList();
    final updatedChats = chatList;
    addDeprecatedInfo(chatList);

    final feedWithInbox = await getInboxList(
      feedsList: updatedChats,
      accountAddress: userDID,
      pgpPrivateKey: pgpPrivateKey,
      toDecrypt: toDecrypt,
    );

    return feedWithInbox;
  } catch (e) {
    log(e);
    //TODO: unhide
    // throw Exception('[Push SDK] - API chats: $e');
  }
}
