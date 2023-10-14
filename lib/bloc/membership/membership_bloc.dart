import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cengli/services/services.dart';
import 'package:cengli/utils/signer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';
import 'package:ethers/signers/wallet.dart' as ethers;

class MembershipBloc extends Bloc<MembershipEvent, MembershipState> {
  final MembershipRemoteRepository _membershipRemoteRepository;

  MembershipBloc(this._membershipRemoteRepository)
      : super(const MembershipInitiateState()) {
    on<SearchUserEvent>(_onSearchUser, transformer: sequential());
    on<GetGroupEvent>(_onGetGroup, transformer: sequential());
    on<GetMembersEvent>(_onGetMembers, transformer: sequential());
    on<GetChatRequestEvent>(_onGetChatRequest, transformer: sequential());
    on<ApproveEvent>(_onApproveChat, transformer: sequential());
    on<FetchP2pEvent>(_onFetchP2p, transformer: sequential());
  }

  Future<void> _onSearchUser(
      SearchUserEvent event, Emitter<MembershipState> emit) async {
    emit(const SearchUserLoadingState());
    try {
      if (event.isUsername) {
        final user =
            await _membershipRemoteRepository.searchUser(event.value, null);
        if (user != null) {
          emit(SearchUserSuccessState(user));
        } else {
          emit(const SearchUserErrorState("Invalid"));
        }
      } else {
        final user =
            await _membershipRemoteRepository.searchUser(null, event.value);
        if (user != null) {
          emit(SearchUserSuccessState(user));
        } else {
          emit(const SearchUserErrorState("Invalid"));
        }
      }
    } on AppException catch (error) {
      emit(SearchUserErrorState(error.message));
    } catch (error) {
      emit(SearchUserErrorState(error.toString()));
    }
  }

  Future<void> _onGetGroup(
      GetGroupEvent event, Emitter<MembershipState> emit) async {
    emit(const GetGroupLoadingState());
    try {
      final group =
          await _membershipRemoteRepository.getGroupFireStore(event.id);
      final groupDto = await getGroup(chatId: event.id);

      if (group != null && groupDto != null) {
        emit(GetGroupSuccessState(group, groupDto));
      } else {
        emit(const GetGroupErrorState("Invalid Id"));
      }
    } on AppException catch (error) {
      emit(GetGroupErrorState(error.message));
    } catch (error) {
      emit(GetGroupErrorState(error.toString()));
    }
  }

  Future<void> _onGetMembers(
      GetMembersEvent event, Emitter<MembershipState> emit) async {
    emit(const GetMembersInfoLoadingState());
    try {
      final members =
          await _membershipRemoteRepository.getGroupMembersInfo(event.ids);

      emit(GetMembersInfoSuccessState(members));
    } on AppException catch (error) {
      emit(GetMembersInfoErrorState(error.message));
    } catch (error) {
      emit(GetMembersInfoErrorState(error.toString()));
    }
  }

  Future<void> _onGetChatRequest(
      GetChatRequestEvent event, Emitter<MembershipState> emit) async {
    emit(const GetChatRequestLoadingState());
    try {
      final walletAddress = await SessionService.getWalletAddress();
      final pgpPrivateKey = await SessionService.getPgpPrivateKey();

      final feeds = await requests(
          accountAddress: walletAddress, pgpPrivateKey: pgpPrivateKey);

      if (feeds != null && feeds.isNotEmpty) {
        emit(GetChatRequestSuccessState(feeds));
      } else {
        emit(const GetChatRequestEmptyState("No Request"));
      }
    } on AppException catch (error) {
      emit(GetChatRequestErrorState(error.message));
    } catch (error) {
      emit(GetChatRequestErrorState(error.toString()));
    }
  }

  Future<void> _onApproveChat(
      ApproveEvent event, Emitter<MembershipState> emit) async {
    emit(const ApproveChatLoadingState());
    try {
      final walletAddress = await SessionService.getWalletAddress();
      final pgpPrivateKey = await SessionService.getPgpPrivateKey();
      final privateKey = await SessionService.getSignerAddress(walletAddress);

      await approve(
        senderAddress: event.senderAddress,
        account: walletAddress,
        pgpPrivateKey: pgpPrivateKey,
        signer: EthersSigner(
            ethersWallet: ethers.Wallet.fromPrivateKey(privateKey),
            address: walletAddress),
      );

      emit(const ApproveChatSuccessState());
    } on AppException catch (error) {
      emit(ApproveChatErrorState(error.message));
    } catch (error) {
      emit(ApproveChatErrorState(error.toString()));
    }
  }

  Future<void> _onFetchP2p(
      FetchP2pEvent event, Emitter<MembershipState> emit) async {
    emit(const FetchP2pLoadingState());
    try {
      final partners = await _membershipRemoteRepository.fetchPartners();
      debugPrint(partners.toString());
      emit(FetchP2pSuccessState(partners));
    } on AppException catch (error) {
      emit(FetchP2pErrorState(error.message));
    } catch (error) {
      emit(FetchP2pErrorState(error.toString()));
    }
  }
}
