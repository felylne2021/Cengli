import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/modules/auth/model/request/relay_transaction_request.dart';
import 'package:cengli/data/modules/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/modules/auth/model/response/relay_transaction_response.dart';
import 'package:cengli/data/modules/auth/model/response/signer_address_response.dart';
import 'package:cengli/data/modules/auth/remote/auth_api_client.dart';

class AuthApi implements AuthApiClient {
  final AuthApiClient _apiClient;

  AuthApi(this._apiClient);

  @override
  Future<CreateWalletResponse> createWallet(
      CreateWalletRequest param, String apiKey) {
    return _apiClient.createWallet(param, apiKey);
  }

  @override
  Future<SignerAddressResponse> getPredictWalletAddress(
      PredictSignerAddressRequest param, String apiKey) {
    return _apiClient.getPredictWalletAddress(param, apiKey);
  }

  @override
  Future<CreateWalletResponse> getWalletAddress(
      String ownerAddress, String apiKey) {
    return _apiClient.getWalletAddress(ownerAddress, apiKey);
  }

  @override
  Future<RelayTransactionResponse> relayTransaction(
      String walletAddress, RelayTransactionRequest param, String apiKey) {
    return _apiClient.relayTransaction(walletAddress, param, apiKey);
  }
}
