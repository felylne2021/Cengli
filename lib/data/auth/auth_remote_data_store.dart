import 'package:cengli/data/auth/auth_remote_repository.dart';
import 'package:cengli/data/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/auth/model/response/create_wallet_response.dart';
import 'package:cengli/data/auth/model/response/signer_address_response.dart';
import 'package:cengli/data/auth/remote/auth_api.dart';
import 'package:cengli/services/apple_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velix/velix.dart';

import '../../error/error_handler.dart';
import 'model/user_profile.dart';

class AuthRemoteDataStore extends AuthRemoteRepository {
  final AuthApi _api;
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  AuthRemoteDataStore(this._api, this._db, this._auth);

  @override
  Future<void> createUser(UserProfile userProfile) async {
    await _db
        .collection("users")
        .doc(userProfile.id)
        .set(userProfile.toJson())
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await _auth.signInWithCredential(credential).catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<void> singOut() async {
    await _auth.signOut().catchError((error) {
      firebaseErrorHandler(error);
    });
  }

  @override
  Future<bool> checkUserExist(String email) async {
    final userExists = await _auth.fetchSignInMethodsForEmail(email);
    return userExists.isNotEmpty;
  }

  @override
  Future<UserCredential> signInWithApple() async {
    OAuthCredential oAuthCredential = await AppleService().signInWithApple();

    return await _auth
        .signInWithCredential(oAuthCredential)
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
}
