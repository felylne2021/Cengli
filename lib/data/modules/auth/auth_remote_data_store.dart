import 'package:cengli/data/modules/auth/auth_remote_repository.dart';
import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/modules/auth/model/request/relay_transaction_request.dart';
import 'package:cengli/data/modules/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/modules/auth/model/response/relay_transaction_response.dart';
import 'package:cengli/data/modules/auth/model/response/signer_address_response.dart';
import 'package:cengli/data/modules/auth/remote/auth_api.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/error/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velix/velix.dart';

import 'model/user_profile.dart';

class AuthRemoteDataStore extends AuthRemoteRepository {
  final AuthApi _api;
  final FirebaseFirestore _db;

  AuthRemoteDataStore(this._api, this._db);

  @override
  Future<void> createUser(UserProfile userProfile) async {
    await _db
        .collection(CollectionEnum.users.name)
        .doc(userProfile.id)
        .set(userProfile.toJson())
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<CreateWalletResponse> createWallet(CreateWalletRequest param) async {
    return _api.createWallet(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<SignerAddressResponse> predictSignerAddress(
      PredictSignerAddressRequest param) async {
    return _api.getPredictWalletAddress(param).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<CreateWalletResponse> getWalletAddress(String ownerAddres) {
    return _api.getWalletAddress(ownerAddres).catchError((error) {
      errorHandler(error);
    });
  }

  @override
  Future<bool> checkUsername(String username) async {
    final query = await _db
        .collection(CollectionEnum.users.name)
        .where('userName', isEqualTo: username)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }

  @override
  Future<UserProfile> getUserData(String username) async {
    final query = await _db
        .collection(CollectionEnum.users.name)
        .where('userName', isEqualTo: username)
        .limit(1)
        .get();

    final List<Map<String, dynamic>> userJson = query.docs.map((e) {
      return e.data();
    }).toList();
    final userData = UserProfile.fromJson(userJson[0]);

    return userData;
  }

  @override
  Future<RelayTransactionResponse> relayTransaction(
      String walletAddress, RelayTransactionRequest param) {
    return _api.relayTransaction(walletAddress, param).catchError((error) {
      errorHandler(error);
    });
  }
}
