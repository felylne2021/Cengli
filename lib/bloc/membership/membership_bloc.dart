import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/bloc/membership/state/get_list_groups_state.dart';
import 'package:cengli/bloc/membership/state/update_username_state.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cengli/services/services.dart';
import 'package:cengli/utils/signer.dart';
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
    on<GetGroupOrderEvent>(_onGetGroupOrder, transformer: sequential());
    on<UpdateUserNameEvent>(_onUpdateUsername, transformer: sequential());
    on<GetListOfGroupsEvent>(_onGetListOfGroup, transformer: sequential());
    on<GetRegistrationEvent>(_onGetRegistration, transformer: sequential());
    on<RequestPartnerEvent>(_onRequestPartner, transformer: sequential());
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
      final address = await SessionService.getWalletAddress();
      final user = await _membershipRemoteRepository.searchUser(null, address);
      final members =
          await _membershipRemoteRepository.getGroupMembersInfo(event.ids);
      if (user != null) {
        members.add(user);
      }
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
      final privateKey = await SessionService.getPrivateKey(walletAddress);

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

  Future<void> _onGetGroupOrder(
      GetGroupOrderEvent event, Emitter<MembershipState> emit) async {
    emit(const GetGroupOrderLoadingState());
    try {
      final group =
          await _membershipRemoteRepository.getGroupFireStore(event.groupId);

      if (group != null) {
        emit(GetGroupOrderSuccessState(group));
      }
    } on AppException catch (error) {
      emit(GetGroupOrderErrorState(error.message));
    } catch (error) {
      emit(GetGroupOrderErrorState(error.toString()));
    }
  }

  Future<void> _onUpdateUsername(
      UpdateUserNameEvent event, Emitter<MembershipState> emit) async {
    try {
      await _membershipRemoteRepository.updateUsername(
          event.fullname, event.userName, event.userId);

      emit(const UpdateUserNameSuccessState());
    } on AppException catch (error) {
      emit(UpdateUserNameErrorState(error.message));
    } catch (error) {
      emit(UpdateUserNameErrorState(error.toString()));
    }
  }

  Future<void> _onGetListOfGroup(
      GetListOfGroupsEvent event, Emitter<MembershipState> emit) async {
    try {
      emit(GetListOfGroupsLoadingState());
      final groups =
          await _membershipRemoteRepository.getListOfGroup(event.userId);
      emit(GetListOfGroupIdSuccessState(groups ?? []));
    } on AppException catch (error) {
      emit(GetListOfGroupsErrorState(error.message));
    } catch (error) {
      emit(GetListOfGroupsErrorState(error.toString()));
    }
  }

  Future<void> _onGetRegistration(
      GetRegistrationEvent event, Emitter<MembershipState> emit) async {
    try {
      final registration = await _membershipRemoteRepository
          .getRegistrationPartner(event.walletAddress);
      emit(GetRegistrationSuccessState(registration));
    } on AppException catch (error) {
      emit(GetRegistrationErrorState(error.message));
    } catch (error) {
      emit(GetRegistrationErrorState(error.toString()));
    }
  }

  Future<void> _onRequestPartner(
      RequestPartnerEvent event, Emitter<MembershipState> emit) async {
    try {
      await _membershipRemoteRepository.registPartner(event.walletAddress);

      emit(const RequestPartnerSuccessState());
    } on AppException catch (error) {
      emit(RequestPartnerErrorState(error.message));
    } catch (error) {
      emit(RequestPartnerErrorState(error.toString()));
    }
  }
}
