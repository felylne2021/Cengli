import 'package:cengli/data/modules/membership/model/request/send_notif_request.dart';
import 'package:cengli/data/modules/membership/model/request/subscribe_channel_request.dart';
import 'package:cengli/data/modules/membership/model/request/upsert_fcm_token_request.dart';
import 'package:cengli/data/modules/membership/model/response/upsert_fcm_token_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'membership_client_api.g.dart';

@RestApi()
abstract class MembershipApiClient {
  factory MembershipApiClient(Dio dio, {String baseUrl}) = _MembershipApiClient;

  @POST('push-protocol/user-fcm-token')
  Future<UpsertFcmTokenResponse> upsertFcmToken(
      @Body() UpsertFcmTokenRequest param);

  @POST('push-protocol/subscribe-channel')
  Future<void> subscribeChannel(@Body() SubscribeChannelRequest param);

  @POST('push-protocol/send-notification')
  Future<void> sendNotification(@Body() SendNotifRequest param);
}
