import 'package:cengli/data/modules/membership/model/request/send_notif_request.dart';
import 'package:cengli/data/modules/membership/model/request/subscribe_channel_request.dart';
import 'package:cengli/data/modules/membership/model/request/upsert_fcm_token_request.dart';
import 'package:cengli/data/modules/membership/model/response/upsert_fcm_token_response.dart';
import 'package:cengli/data/modules/membership/remote/membership_client_api.dart';

class MembershipApi implements MembershipApiClient {
  final MembershipApiClient _apiClient;

  MembershipApi(this._apiClient);

  @override
  Future<UpsertFcmTokenResponse> upsertFcmToken(UpsertFcmTokenRequest param) {
    return _apiClient.upsertFcmToken(param);
  }

  @override
  Future<void> subscribeChannel(SubscribeChannelRequest param) {
    return _apiClient.subscribeChannel(param);
  }

  @override
  Future<void> sendNotification(SendNotifRequest param) {
    return _apiClient.sendNotification(param);
  }
}
