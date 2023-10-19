import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/model/request/prepare_erc20_request.dart';
import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transaction_data_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transaction_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';
import 'package:cengli/data/modules/transfer/model/response/update_order_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'transfer_api_client.g.dart';

@RestApi()
abstract class TransferApiClient {
  factory TransferApiClient(Dio dio, {String baseUrl}) = _TransferApiClient;

  @GET('account/assets')
  Future<AssetsResponse> getAssets(
      @Query("address") String address, @Query("chainId") int chainId);

  @GET('info/chains')
  Future<List<ChainResponse>> getChains();

  @GET('account/transactions')
  Future<List<TransactionResponse>> getTransactions(
      @Query("userId") String userId);

  @POST('transfer/send')
  Future<TransferResponse> postTransfer(@Body() TransferRequest param);

  @GET('p2p/partners')
  Future<List<GetPartnersResponse>> getPartners();

  @POST('p2p/orders')
  Future<OrderResponse> postOrder(@Body() CreateOrderRequest param);

  @PUT('p2p/orders/{id}/accept')
  Future<UpdateOrderResponse> acceptOrder(
      @Path('id') String orderId, @Query('callerUserId') String callerUserId);

  @PUT('p2p/orders/{id}/cancel')
  Future<UpdateOrderResponse> cancelOrder(
      @Path('id') String orderId, @Query('callerUserId') String callerUserId);

  @PUT('p2p/orders/{id}/done-payment')
  Future<UpdateOrderResponse> donePaymentOrder(
      @Path('id') String orderId, @Query('callerUserId') String callerUserId);

  @PUT('p2p/orders/{id}/release-fund')
  Future<UpdateOrderResponse> releaseFundOrder(
      @Path('id') String orderId, @Query('callerUserId') String callerUserId);

  @GET('p2p/orders/{id}')
  Future<OrderResponse> getOrder(@Path('id') String orderId);

  @POST('cometh/prepare-erc20-tx')
  Future<TransactionDataResponse> prepareTx(@Body() PrepareErc20Request param);
}
