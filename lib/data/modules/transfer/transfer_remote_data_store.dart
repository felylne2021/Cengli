import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/remote/transfer_api.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
import 'package:velix/velix.dart';

import 'model/response/transaction_response.dart';

class TransferRemoteDataStore extends TransferRemoteRepository {
  final TransferApi _api;

  TransferRemoteDataStore(this._api);

  @override
  Future<AssetsResponse> getAssets(String address, int chainId) async {
    return await _api.getAssets(address, chainId).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<List<ChainResponse>> getChains() async {
    return await _api.getChains().catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<List<TransactionResponse>> getTransactions(String userId) async {
    return await _api.getTransactions(userId).catchError((error) {
      errorHandler(error);
    });
  }
}
