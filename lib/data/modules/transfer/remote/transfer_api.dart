import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';
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
}
