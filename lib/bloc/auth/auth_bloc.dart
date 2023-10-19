import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/auth/state/get_user_state.dart';
import 'package:cengli/data/modules/auth/auth_remote_repository.dart';
import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/auth/model/request/relay_transaction_request.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/services/biometric_service.dart';
import 'package:cengli/services/eth_service.dart';
import 'package:cengli/utils/signer.dart';
import 'package:cengli/services/session_service.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velix/velix.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart' as push;
import 'package:ethers/signers/wallet.dart' as ethers;

import '../../data/modules/auth/model/user_profile.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteRepository _authRepository;

  AuthBloc(this._authRepository) : super(const AuthInitiateState()) {
    on<CreateWalletEvent>(_onCreateWallet, transformer: sequential());
    on<CheckWalletEvent>(_onCheckWallet, transformer: sequential());
    on<CheckUsernameEvent>(_onCheckUsername, transformer: sequential());
    on<GetUserDataEvent>(_onGetUserData, transformer: sequential());
    on<RelayTransactionEvent>(_onRelayTransaction, transformer: sequential());
  }

  Future<void> _onCreateWallet(
      CreateWalletEvent event, Emitter<AuthState> emit) async {
    emit(const CreateWalletLoadingState());
    try {
      //Create burner wallet
      List<String> wallet = EthService.crateRandom();
      String privateKey = wallet.first;
      String ownerAddress = wallet.last;

      //Create wallet on cometh
      final walletAddress = await _authRepository
          .createWallet(CreateWalletRequest(ownerAddress: ownerAddress));

      //Save credential
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          '${PrefKey.commeth.key}${walletAddress.walletAddress}', privateKey);
      await prefs.setString(
          PrefKey.walletAddress.key, walletAddress.walletAddress ?? "");

      //Create push protocol account
      final user = await push.createUser(
          signer: EthersSigner(
              ethersWallet: ethers.Wallet.fromPrivateKey(privateKey),
              address: walletAddress.walletAddress ?? ""),
          progressHook: (push.ProgressHookType progress) {});

      //*TODO: subscribe channel

      //Create user on firebase
      String imageUrl = Constant
          .profileImages[Random().nextInt(Constant.profileImages.length)];

      await _authRepository.createUser(UserProfile(
          id: walletAddress.walletAddress,
          userName: event.userName,
          name: event.userName,
          email: "",
          walletAddress: walletAddress.walletAddress,
          userRole: UserRoleEnum.user.name,
          imageProfile: imageUrl));

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

  Future<void> _onRelayTransaction(
      RelayTransactionEvent event, Emitter<AuthState> emit) async {
    emit(const RelayTransactionLoadingState());

    try {
      final walletAddress = await SessionService.getWalletAddress();
      final isApprove = await BiometricService.authenticateWithBiometrics();
      if (isApprove) {
        String signatures = await EthService().signTransaction(event.response);
        await _authRepository.relayTransaction(
            walletAddress,
            RelayTransactionRequest(
                to: event.response.types?.to,
                value: event.response.types?.value,
                data: event.response.types?.data,
                operation: event.response.types?.operation,
                safeTxGas: event.response.types?.safeTxGas,
                baseGas: event.response.types?.baseGas,
                gasPrice: event.response.types?.gasPrice,
                gasToken: event.response.types?.gasToken,
                refundReceiver: event.response.types?.refundReceiver,
                nonce: event.response.types?.nonce,
                signatures: signatures));
        emit(const RelayTransactionSuccessState());
      } else {
        emit(const RelayTransactionErrorState("Canceled"));
      }
    } on AppException catch (error) {
      emit(RelayTransactionErrorState(error.message));
    } catch (error) {
      emit(RelayTransactionErrorState(error.toString()));
    }
  }
}
