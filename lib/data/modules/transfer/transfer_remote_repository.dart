import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';

import 'model/response/transaction_response.dart';

abstract class TransferRemoteRepository {
  Future<AssetsResponse> getAssets(String address, int chainId);
  Future<List<ChainResponse>> getChains();
  Future<List<TransactionResponse>> getTransactions(String userId);
}
