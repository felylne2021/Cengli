import '../../../push_restapi_dart.dart';
import '../../../push_restapi_dart.dart' as push;

Future<GroupDTO?> addMembers({
  required String chatId,
  String? account,
  Signer? signer,
  String? pgpPrivateKey,
  required List<String> members,
}) async {
  account ??= getCachedWallet()?.address;
  signer ??= getCachedWallet()?.signer;
  pgpPrivateKey ??= getCachedWallet()?.pgpPrivateKey;

  try {
    if (account == null && signer == null) {
      throw Exception('At least one from account or signer is necessary!');
    }

    if (members.isEmpty) {
      throw Exception("Member address array cannot be empty!");
    }

    for (var member in members) {
      if (!isValidETHAddress(member)) {
        throw Exception('Invalid member address: $member');
      }
    }

    final group = await getGroup(chatId: chatId);

    if (group == null) {
      throw Exception('Group not found: $chatId');
    }

    List<String> convertedMembers =
        getMembersList(group.members, group.pendingMembers);

    List<String> membersToBeAdded =
        members.map((member) => walletToPCAIP10(member)).toList();

    for (var member in membersToBeAdded) {
      if (convertedMembers.contains(member)) {
        throw Exception('Member $member already exists in the list');
      }
    }

    convertedMembers.addAll(membersToBeAdded);

    List<String> convertedAdmins =
        getAdminsList(group.members, group.pendingMembers);

    final updatedGroup = await push.updateGroup(
        chatId: chatId,
        groupName: group.groupName!,
        groupImage: group.groupImage,
        groupDescription: group.groupDescription!,
        members: convertedMembers,
        admins: convertedAdmins,
        signer: signer,
        scheduleAt: group.scheduleAt,
        scheduleEnd: group.scheduleEnd,
        status: ChatStatus.ENDED,
        isPublic: group.isPublic);

    return updatedGroup;
  } catch (e) {
    log("[Push SDK] - API  - Error - API addMembers -: $e ");
    rethrow;
  }
}
