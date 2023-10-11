import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/modules/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/modules/auth/model/response/signer_address_response.dart';
import 'package:cengli/data/modules/auth/remote/auth_api_client.dart';

class AuthApi implements AuthApiClient {
  final AuthApiClient _apiClient;

  AuthApi(this._apiClient);

  @override
  Future<CreateWalletResponse> createWallet(CreateWalletRequest param) {
    return _apiClient.createWallet(param);
  }

  @override
  Future<SignerAddressResponse> getPredictWalletAddress(
      PredictSignerAddressRequest param) {
    return _apiClient.getPredictWalletAddress(param);
  }

  @override
  Future<CreateWalletResponse> getWalletAddress(String ownerAddress) {
    return _apiClient.getWalletAddress(ownerAddress);
  }
}
