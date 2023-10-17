import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/auth/state/get_user_state.dart';
import 'package:cengli/data/modules/auth/auth_remote_repository.dart';
import 'package:cengli/data/modules/auth/model/device_data.dart';
import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/predict_signer_address_request.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/utils/signer.dart';
import 'package:cengli/services/session_service.dart';
import 'package:cengli/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velix/velix.dart';
import 'package:webauthn/webauthn.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart' as push;
import 'package:ethers/signers/wallet.dart' as ethers;

import '../../data/modules/auth/model/user_profile.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitiateState()) {
    on<SignInWithEmailEvent>(_onEmailSignIn, transformer: sequential());
    on<SignInWithGoogleEvent>(_onGoogleSignIn, transformer: sequential());
    on<SignInWithAppleEvent>(_onAppleSignIn, transformer: sequential());
    on<SignUpWithEmailEvent>(_onEmailSignUp, transformer: sequential());
    on<SignOutEvent>(_onSignOut, transformer: sequential());
    on<CreateWalletEvent>(_onCreateWallet, transformer: sequential());
    on<CheckWalletEvent>(_onCheckWallet, transformer: sequential());
    on<CheckUsernameEvent>(_onCheckUsername, transformer: sequential());
    on<GetUserDataEvent>(_onGetUserData, transformer: sequential());
  }

  Future<void> _onEmailSignIn(
      SignInWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(const EmailSignInLoadingState());
    try {
      final userCred =
          await _authRepository.signInWithEmail(event.email, event.password);
      emit(EmailSignInSuccessState(userCred));
    } on AppException catch (error) {
      emit(EmailSignInErrorState(error.message));
    } catch (error) {
      emit(EmailSignInErrorState(error.toString()));
    }
  }

  Future<void> _onGoogleSignIn(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(const GoogleSignInLoadingState());
    try {
      UserCredential userCredential = await _authRepository.signInWithGoogle();
      bool userExist = await _authRepository
          .checkUserExist(userCredential.user?.email ?? "");

      if (userExist) {
        emit(const GoogleSignInSuccessState());
      } else {
        await _authRepository.createUser(UserProfile(
            id: userCredential.user?.uid,
            name: userCredential.user?.displayName,
            email: userCredential.user?.email,
            userName: ''));
        emit(const GoogleSignInSuccessState());
      }
    } on AppException catch (error) {
      emit(GoogleSignInErrorState(error.message));
    } catch (error) {
      emit(GoogleSignInErrorState(error.toString()));
    }
  }

  Future<void> _onAppleSignIn(
      SignInWithAppleEvent event, Emitter<AuthState> emit) async {
    emit(const AppleSignInLoadingState());
    try {
      UserCredential userCredential = await _authRepository.signInWithApple();
      bool userExist = await _authRepository
          .checkUserExist(userCredential.user?.email ?? "");

      if (userExist) {
        emit(const AppleSignInSuccessState());
      } else {
        await _authRepository.createUser(UserProfile(
            id: userCredential.user?.uid,
            name: userCredential.user?.displayName,
            email: userCredential.user?.email,
            userName: ''));
        emit(const AppleSignInSuccessState());
      }
    } on AppException catch (error) {
      emit(AppleSignInErrorState(error.message));
    } catch (error) {
      emit(AppleSignInErrorState(error.toString()));
    }
  }

  Future<void> _onEmailSignUp(
      SignUpWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(const EmailSignUpLoadingState());
    try {
      await _authRepository.signUpWithEmail(event.email, event.password);
      emit(const EmailSignUpSuccessState());
    } on AppException catch (error) {
      emit(EmailSignUpErrorState(error.message));
    } catch (error) {
      emit(EmailSignUpErrorState(error.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(const SignOutLoadingState());
    try {
      await _authRepository.singOut();
      emit(const SignOutSuccessState());
    } on AppException catch (error) {
      emit(SignOutErrorState(error.message));
    } catch (error) {
      emit(SignOutErrorState(error.toString()));
    }
  }

  Future<void> _onCreateWallet(
      CreateWalletEvent event, Emitter<AuthState> emit) async {
    emit(const CreateWalletLoadingState());
    try {
      final userId = Uint8List(64);
      final MakeCredentialOptions options = MakeCredentialOptions(
          clientDataHash: Uint8List(32),
          rpEntity: RpEntity(
            id: 'cengli',
            name: 'cengli',
          ),
          userEntity: UserEntity(
            id: userId,
            name: event.userName,
            displayName: event.userName,
          ),
          requireResidentKey: false,
          requireUserPresence: true,
          requireUserVerification: false,
          credTypesAndPubKeyAlgs: [
            const CredTypePubKeyAlgoPair(
                credType: PublicKeyCredentialType.publicKey, pubKeyAlgo: -7),
          ],
          excludeCredentialDescriptorList: null);

      final auth = Authenticator(true, false);
      final Attestation attestation = await auth.makeCredential(options);

      List<int> xCoordinates = [];
      List<int> yCoordinates = [];

      for (int i = 0; i < attestation.getCredentialId().length; i += 2) {
        xCoordinates.add(attestation.getCredentialId()[i]);
        if (i + 1 < attestation.getCredentialId().length) {
          yCoordinates.add(attestation.getCredentialId()[i + 1]);
        }
      }

      final publicKeyX = '0x${HexUtil().toHexString(xCoordinates)}';
      final publicKeyY = '0x${HexUtil().toHexString(yCoordinates)}';
      final publicKeyId = HexUtil().hexArrayStr(attestation.getCredentialId());

      final response = await _authRepository.predictSignerAddress(
          PredictSignerAddressRequest(
              publicKeyX: publicKeyX, publicKeyY: publicKeyY));
      final walletAddress =
          await _authRepository.getWalletAddress(response.signerAddress ?? "");
      final localStorageWebauthnCredentials = jsonEncode({
        'publicKeyId': publicKeyId,
        'signerAddress': response.signerAddress,
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '${PrefKey.commeth.key}${walletAddress.walletAddress}',
          localStorageWebauthnCredentials);

      await prefs.setString(
          PrefKey.walletAddress.key, walletAddress.walletAddress ?? "");

      //Create wallet on cometh
       await _authRepository.createWallet(CreateWalletRequest(
          walletAddress: walletAddress.walletAddress ?? "",
          publicKeyId: publicKeyId,
          publicKeyX: publicKeyX,
          publicKeyY: publicKeyY,
          deviceData: DeviceData(
              browser: "-",
              os: Platform.isAndroid ? "android" : "ios",
              platform: 'Mobile')));

      //Create push protocol account
      final user = await push.createUser(
          signer: EthersSigner(
              ethersWallet:
                  ethers.Wallet.fromPrivateKey(response.signerAddress ?? ""),
              address: walletAddress.walletAddress ?? ""),
          progressHook: (push.ProgressHookType progress) {});

      //Create user on firebase
      await _authRepository.createUser(UserProfile(
          id: walletAddress.walletAddress,
          userName: event.userName,
          name: event.userName,
          email: "",
          walletAddress: walletAddress.walletAddress,
          userRole: UserRoleEnum.user.name));

      SessionService.setLogin(true);
      SessionService.setEncryptedPrivateKey(user?.encryptedPrivateKey ?? "");

      emit(const CreateWalletSuccessState());
    } on ApiException catch (error) {
      emit(CreateWalletErrorState(error.message));
    } on AppException catch (error) {
      emit(CreateWalletErrorState(error.message));
    } catch (error) {
      emit(CreateWalletErrorState(error.toString()));
    }
  }

  Future<void> _onCheckWallet(
      CheckWalletEvent event, Emitter<AuthState> emit) async {
    emit(const CheckWalletLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? walletAddress = prefs.getString('wallet-address');

      emit(CheckWalletSuccessState(walletAddress != null));
    } on AppException catch (error) {
      emit(CheckWalletErrorState(error.message));
    } on ApiException catch (error) {
      emit(CheckWalletErrorState(error.message));
    } catch (error) {
      emit(CheckWalletErrorState(error.toString()));
    }
  }

  Future<void> _onCheckUsername(
      CheckUsernameEvent event, Emitter<AuthState> emit) async {
    emit(const CheckUsernameLoadingState());
    try {
      final isExist = await _authRepository.checkUsername(event.username);
      emit(CheckUsernameSuccessState(isExist));
    } on AppException catch (error) {
      emit(CheckUsernameErrorState(error.message));
    } catch (error) {
      emit(CheckUsernameErrorState(error.toString()));
    }
  }

  Future<void> _onGetUserData(
      GetUserDataEvent event, Emitter<AuthState> emit) async {
    emit(const GetUserDataLoadingState());

    try {
      final UserProfile userProfile =
          await _authRepository.getUserData(event.username);
      emit(GetUserDataSuccessState(userProfile));
    } on AppException catch (error) {
      emit(GetUserDataErrorState(error.message));
    } catch (error) {
      emit(GetUserDataErrorState(error.toString()));
    }
  }
}
