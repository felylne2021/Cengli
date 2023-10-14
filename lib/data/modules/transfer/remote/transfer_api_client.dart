import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/transaction_response.dart';
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
}
