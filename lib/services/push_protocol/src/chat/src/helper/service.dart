import '../../../../push_restapi_dart.dart';

Future<User> createUserService({
  required String user,
  Wallet? wallet,
  required String publicKey,
  required String encryptedPrivateKey,
}) async {
  wallet ??= getCachedWallet();

  if (wallet == null || wallet.signer == null) {
    throw Exception('Provide signer');
  }

  final requestPath = '/v2/users/';

  if (isValidCAIP10NFTAddress(user)) {
    final epoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (user.split(':').length != 6) {
      user = '$user:$epoch';
    }
  }

  final data = {
    'caip10': walletToPCAIP10(user),
    'did': walletToPCAIP10(user),
    'publicKey': publicKey,
    'encryptedPrivateKey': encryptedPrivateKey,
  };

  final hash = generateHash(data);

  final signatureObj = await getEip191Signature(wallet, hash, version: 'v2');

  final body = {
    ...data,
    ...signatureObj,
  };

  final responseData = await http.post(path: requestPath, data: body);

  if (responseData != null) {
    return User.fromJson(responseData);
  } else {
    throw Exception('[Push SDK] - API $requestPath: Error');
  }
}

getConversationHashService({
  required String conversationId,
  required String account,
}) async {
  final path =
      '/v1/chat/users/${walletToPCAIP10(account)}/conversations/$conversationId/hash';

  return http.get(
    path: path,
  );
}

Future<List<Message>?> getMessagesService({
  required String threadhash,
  required int limit,
}) async {
  log('getMessagesService: threadhash= $threadhash');
  final path = '/v1/chat/conversationhash/$threadhash?fetchLimit=$limit';

  final result = await http.get(path: path);

  if (result == null) {
    return null;
  }

  if (result is List) {
    return result.map((e) => Message.fromJson(e)).toList();
  }

  return null;
}
