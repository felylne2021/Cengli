import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';

import 'model/response/transaction_response.dart';
import 'model/response/update_order_response.dart';

abstract class TransferRemoteRepository {
  Future<AssetsResponse> getAssets(String address, int chainId);
  Future<List<ChainResponse>> getChains();
  Future<List<TransactionResponse>> getTransactions(String userId);
  Future<TransferResponse> postTransfer(TransferRequest param);
  Future<List<GetPartnersResponse>> getPartners();
  Future<OrderResponse> postOrder(CreateOrderRequest param);
  Future<OrderResponse> getOrder(String orderId);
  Future<UpdateOrderResponse> acceptOrder(String orderId, String callerUserId);
  Future<UpdateOrderResponse> cancelOrder(String orderId, String callerUserId);
  Future<UpdateOrderResponse> payOrder(String orderId, String callerUserId);
  Future<UpdateOrderResponse> fundOrder(String orderId, String callerUserId);
}
