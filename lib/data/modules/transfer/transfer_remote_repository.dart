import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';

import 'model/response/transaction_response.dart';

abstract class TransferRemoteRepository {
  Future<AssetsResponse> getAssets(String address, int chainId);
  Future<List<ChainResponse>> getChains();
  Future<List<TransactionResponse>> getTransactions(String userId);
  Future<void> createOrder(OrderResponse order);
  Future<void> updateOrder(String id, String status);
  Future<OrderResponse> getOrder(String groupId);
  Future<TransferResponse> postTransfer(TransferRequest param);
}
