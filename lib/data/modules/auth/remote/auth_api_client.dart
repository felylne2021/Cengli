import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/modules/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/modules/auth/model/response/signer_address_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST('wallets/init-with-webauthn')
  Future<CreateWalletResponse> createWallet(@Body() CreateWalletRequest param);

  @POST('webauthn-signer/predict-address')
  Future<SignerAddressResponse> getPredictWalletAddress(
      @Body() PredictSignerAddressRequest param);

  @GET('wallets/{ownerAddress}/wallet-address')
  Future<CreateWalletResponse> getWalletAddress(
      @Path("ownerAddress") String ownerAddress);
}
