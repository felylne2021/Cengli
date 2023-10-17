import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';
import 'package:cengli/data/modules/transfer/model/response/update_order_response.dart';
import 'package:cengli/data/modules/transfer/remote/transfer_api_client.dart';

import '../model/response/transaction_response.dart';

class TransferApi implements TransferApiClient {
  final TransferApiClient _apiClient;

  TransferApi(this._apiClient);

  @override
  Future<AssetsResponse> getAssets(String address, int chainId) {
    return _apiClient.getAssets(address, chainId);
  }

  @override
  Future<List<ChainResponse>> getChains() {
    return _apiClient.getChains();
  }

  @override
  Future<List<TransactionResponse>> getTransactions(String userId) {
    return _apiClient.getTransactions(userId);
  }

  @override
  Future<TransferResponse> postTransfer(TransferRequest param) {
    return _apiClient.postTransfer(param);
  }

  @override
  Future<List<GetPartnersResponse>> getPartners() {
    return _apiClient.getPartners();
  }

  @override
  Future<OrderResponse> postOrder(CreateOrderRequest param) {
    return _apiClient.postOrder(param);
  }

  @override
  Future<UpdateOrderResponse> acceptOrder(String orderId, String callerUserId) {
    return _apiClient.acceptOrder(orderId, callerUserId);
  }

  @override
  Future<UpdateOrderResponse> cancelOrder(String orderId, String callerUserId) {
    return _apiClient.cancelOrder(orderId, callerUserId);
  }

  @override
  Future<UpdateOrderResponse> donePaymentOrder(
      String orderId, String callerUserId) {
    return _apiClient.donePaymentOrder(orderId, callerUserId);
  }

  @override
  Future<UpdateOrderResponse> releaseFundOrder(
      String orderId, String callerUserId) {
    return _apiClient.releaseFundOrder(orderId, callerUserId);
  }

  @override
  Future<OrderResponse> getOrder(String orderId) {
    return _apiClient.getOrder(orderId);
  }
}
