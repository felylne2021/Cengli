import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/modules/auth/model/request/relay_transaction_request.dart';
import 'package:cengli/data/modules/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/modules/auth/model/response/signer_address_response.dart';
import 'model/response/relay_transaction_response.dart';
import 'model/user_profile.dart';

abstract class AuthRemoteRepository {
  Future<void> createUser(UserProfile userProfile);
  Future<CreateWalletResponse> createWallet(CreateWalletRequest param);
  Future<SignerAddressResponse> predictSignerAddress(
      PredictSignerAddressRequest param);
  Future<CreateWalletResponse> getWalletAddress(String ownerAddres);
  Future<bool> checkUsername(String username);
  Future<UserProfile> getUserData(String username);
  Future<RelayTransactionResponse> relayTransaction(
      String walletAddress, RelayTransactionRequest param);
}
