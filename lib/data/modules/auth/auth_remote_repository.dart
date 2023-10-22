import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/modules/auth/model/request/relay_transaction_request.dart';
import 'package:cengli/data/modules/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/modules/auth/model/response/signer_address_response.dart';
import 'model/response/relay_transaction_response.dart';
import 'model/user_profile.dart';

abstract class AuthRemoteRepository {
  //Cometh
  Future<CreateWalletResponse> createWallet(
      CreateWalletRequest param, String apiKey);
  Future<SignerAddressResponse> predictSignerAddress(
      PredictSignerAddressRequest param, String apiKey);
  Future<CreateWalletResponse> getWalletAddress(
      String ownerAddres, String apiKey);
  Future<RelayTransactionResponse> relayTransaction(
      String walletAddress, RelayTransactionRequest param, String apiKey);

  //Cengli
  Future<void> createUser(UserProfile userProfile);
  Future<bool> checkUsername(String username);
  Future<UserProfile> getUserData(String username);
}
