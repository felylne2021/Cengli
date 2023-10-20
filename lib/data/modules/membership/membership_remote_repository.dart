import 'package:cengli/data/modules/membership/model/registration.dart';

import '../auth/model/user_profile.dart';
import '../transactional/model/group.dart';
import 'model/request/send_notif_request.dart';
import 'model/request/subscribe_channel_request.dart';
import 'model/request/upsert_fcm_token_request.dart';
import 'model/response/upsert_fcm_token_response.dart';

abstract class MembershipRemoteRepository {
  Future<UserProfile?> searchUser(String? username, String? address);
  Future<Group?> getGroupFireStore(String id);
  Future<List<UserProfile>> getGroupMembersInfo(List<String> ids);
  Future<void> updateUsername(String fullname, String username, String userId);
  Future<UpsertFcmTokenResponse> upsertFcmToken(UpsertFcmTokenRequest param);
  Future<void> subscribeChannel(SubscribeChannelRequest param);
  Future<void> sendNotification(SendNotifRequest param);
  Future<List<Group>?> getListOfGroup(String userId);
  Future<void> registPartner(String walletAddress);
  Future<Registration?> getRegistrationPartner(String walletAddress);
}
