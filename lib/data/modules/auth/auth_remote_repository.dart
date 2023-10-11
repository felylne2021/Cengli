import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/modules/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/modules/auth/model/response/signer_address_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/user_profile.dart';

abstract class AuthRemoteRepository {
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithApple();
  Future<bool> checkUserExist(String email);
  Future<void> singOut();
  Future<void> createUser(UserProfile userProfile);
  Future<CreateWalletResponse> createWallet(CreateWalletRequest param);
  Future<SignerAddressResponse> predictSignerAddress(
      PredictSignerAddressRequest param);
  Future<CreateWalletResponse> getWalletAddress(String ownerAddres);
  Future<bool> checkUsername(String username);
}
