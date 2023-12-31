import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/auth/state/get_user_state.dart';
import 'package:cengli/data/modules/auth/auth_remote_repository.dart';
import 'package:cengli/data/modules/auth/model/request/create_wallet_request.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/data/modules/membership/model/request/subscribe_channel_request.dart';
import 'package:cengli/data/modules/membership/model/request/upsert_fcm_token_request.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/services/eth_service.dart';
import 'package:cengli/utils/fcm_util.dart';
import 'package:cengli/utils/signer.dart';
import 'package:cengli/services/session_service.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velix/velix.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart' as push;
import 'package:ethers/signers/wallet.dart' as ethers;

import '../../data/modules/auth/model/user_profile.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteRepository _authRepository;
  final MembershipRemoteRepository _membershipRemoteRepository;

  AuthBloc(this._authRepository, this._membershipRemoteRepository)
      : super(const AuthInitiateState()) {
    on<CreateWalletEvent>(_onCreateWallet, transformer: sequential());
    on<CheckWalletEvent>(_onCheckWallet, transformer: sequential());
    on<CheckUsernameEvent>(_onCheckUsername, transformer: sequential());
    on<GetUserDataEvent>(_onGetUserData, transformer: sequential());
    on<RelayTransactionEvent>(_onRelayTransaction, transformer: sequential());
    on<RelayApproveTransactionEvent>(_onRelayApproveTransaction,
        transformer: sequential());
    on<RelayCrossTransactionEvent>(_onRelayCrossTransaction,
        transformer: sequential());
    on<RelayDestinationTransactionEvent>(_onRelayDestinationTransaction,
        transformer: sequential());
  }

  Future<void> _onCreateWallet(
      CreateWalletEvent event, Emitter<AuthState> emit) async {
    emit(const CreateWalletLoadingState());
    try {
      //Create burner wallet
      List<String> wallet = EthService.crateRandom();
      String privateKey = wallet.first;
      String ownerAddress = wallet.last;

      //Create wallet on cometh avax
      final walletAddress = await _authRepository.createWallet(
          CreateWalletRequest(ownerAddress: ownerAddress),
          Constant.commethAvaxApiKey);

      //Create wallet on cometh polygon
      await _authRepository.createWallet(
          CreateWalletRequest(ownerAddress: ownerAddress),
          Constant.commethPolygonApiKey);

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

      // Subscibe channel
      await _membershipRemoteRepository.subscribeChannel(
          SubscribeChannelRequest(
              walletAddress: walletAddress.walletAddress, pgpk: privateKey));

      // Save fcm token
      final String fcmToken = await FcmUtil.getFcmToken();
      await _membershipRemoteRepository.upsertFcmToken(UpsertFcmTokenRequest(
          walletAddress: walletAddress.walletAddress, fcmToken: fcmToken));

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
      debugPrint(event.network.toString());
      await _authRepository.relayTransaction(
          walletAddress,
          event.param,
          event.network == ComethNetworkEnum.avax
              ? Constant.commethAvaxApiKey
              : Constant.commethPolygonApiKey);
      emit(const RelayTransactionSuccessState());
    } on AppException catch (error) {
      emit(RelayTransactionErrorState(error.message));
    } on ApiException catch (error) {
      emit(RelayTransactionErrorState(error.message));
    } catch (error) {
      emit(RelayTransactionErrorState(error.toString()));
    }
  }

  Future<void> _onRelayApproveTransaction(
      RelayApproveTransactionEvent event, Emitter<AuthState> emit) async {
    emit(const RelayApproveTransactionLoadingState());

    try {
      final walletAddress = await SessionService.getWalletAddress();

      await _authRepository.relayTransaction(
          walletAddress,
          event.param,
          event.network == ComethNetworkEnum.avax
              ? Constant.commethAvaxApiKey
              : Constant.commethPolygonApiKey);
      emit(const RelayApproveTransactionSuccessState());
    } on AppException catch (error) {
      emit(RelayApproveTransactionErrorState(error.message));
    } on ApiException catch (error) {
      emit(RelayApproveTransactionErrorState(error.message));
    } catch (error) {
      emit(RelayApproveTransactionErrorState(error.toString()));
    }
  }

  Future<void> _onRelayCrossTransaction(
      RelayCrossTransactionEvent event, Emitter<AuthState> emit) async {
    emit(const RelayCrossTransactionLoadingState());

    try {
      final walletAddress = await SessionService.getWalletAddress();

      await _authRepository.relayTransaction(
          walletAddress,
          event.param,
          event.network == ComethNetworkEnum.avax
              ? Constant.commethAvaxApiKey
              : Constant.commethPolygonApiKey);
      emit(const RelayCrossTransactionSuccessState());
    } on AppException catch (error) {
      emit(RelayCrossTransactionErrorState(error.message));
    } on ApiException catch (error) {
      emit(RelayCrossTransactionErrorState(error.message));
    } catch (error) {
      emit(RelayCrossTransactionErrorState(error.toString()));
    }
  }

  Future<void> _onRelayDestinationTransaction(
      RelayDestinationTransactionEvent event, Emitter<AuthState> emit) async {
    emit(const RelayDestinationTransactionLoadingState());

    try {
      final walletAddress = await SessionService.getWalletAddress();

      await _authRepository.relayTransaction(
          walletAddress,
          event.param,
          event.network == ComethNetworkEnum.avax
              ? Constant.commethAvaxApiKey
              : Constant.commethPolygonApiKey);
      emit(const RelayDestinationTransactionSuccessState());
    } on AppException catch (error) {
      emit(RelayDestinationTransactionErrorState(error.message));
    } on ApiException catch (error) {
      emit(RelayDestinationTransactionErrorState(error.message));
    } catch (error) {
      emit(RelayDestinationTransactionErrorState(error.toString()));
    }
  }
}
