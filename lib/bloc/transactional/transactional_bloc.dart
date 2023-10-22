import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/bloc/transactional/state_remote/fetch_charges_store_state.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/data/modules/transactional/transactional_local_repository.dart';
import 'package:cengli/data/modules/transactional/transactional_remote_repository.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/utils/signer.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';
import 'package:ethers/signers/wallet.dart' as ethers;
import '../../data/modules/membership/model/request/notification_payload_request.dart';
import '../../data/modules/membership/model/request/send_notif_request.dart';
import '../../services/services.dart';
import 'transactional.dart';

class TransactionalBloc extends Bloc<TransactionalEvent, TransactionalState> {
  final TransactionalLocalRepository _transactionalLocalRepository;
  final TransactionalRemoteRepository _transactionRepository;
  final MembershipRemoteRepository _membershipRemoteRepository;

  TransactionalBloc(this._transactionalLocalRepository,
      this._transactionRepository, this._membershipRemoteRepository)
      : super(const TransactionalInitiateState()) {
    //Remote
    on<CreateGroupStoreEvent>(_createGroupStore, transformer: sequential());
    on<FetchGroupsStoreEvent>(_fetchGroupsStore, transformer: sequential());
    on<CreateExpenseStoreEvent>(_createExpenseStore, transformer: sequential());
    on<FetchExpensesStoreEvent>(_fetchExpensesStore, transformer: sequential());
    on<MigrateDataEvent>(_migrateData, transformer: sequential());
    on<JoinGroupEvent>(_joinGroup, transformer: sequential());
    on<FetchChargesStoreEvent>(_fetchChargesStore, transformer: sequential());

    //*TODO: setup local database
    on<CreateGroupEvent>(_createGroup, transformer: sequential());
    on<FetchGroupsEvent>(_fetchGroups, transformer: sequential());
    on<CreateExpenseEvent>(_createExpense, transformer: sequential());
    on<FetchExpensesEvent>(_fetchExpenses, transformer: sequential());
    on<FetchParticipantsEvent>(_fetchParticipants, transformer: sequential());
  }

  //Remote
  Future<void> _createGroupStore(
      CreateGroupStoreEvent event, Emitter<TransactionalState> emit) async {
    emit(const CreateGroupStoreLoadingState());
    try {
      final walletAddress = await SessionService.getWalletAddress();
      final privateKey = await SessionService.getPrivateKey(walletAddress);
      final username = await SessionService.getUsername();

      final group = await createGroup(
          groupName: event.group.name ?? "",
          signer: EthersSigner(
              ethersWallet: ethers.Wallet.fromPrivateKey(privateKey),
              address: walletAddress),
          groupDescription: event.group.groupDescription ?? "",
          members: event.group.members ?? [],
          admins: [],
          isPublic: true);

      final storeGroup = Group(
          id: group?.chatId ?? "",
          groupDescription: event.group.groupDescription,
          name: event.group.name,
          members: event.group.members ?? [],
          groupType: GroupTypeEnum.general.name);


      // Send notification
      final members = event.group.members ?? [];

      if (members.contains(walletAddress)) {
        members.remove(walletAddress);
      }
      final targetedMembers = members;
      _membershipRemoteRepository.sendNotification(SendNotifRequest(
          walletAddresses: targetedMembers,
          notificationPayload: NotificationPayloadRequest(
              title: group?.groupName ?? "",
              body: "$username invite you to join the group",
              screen: "chat")));

      await _transactionRepository.createGroup(storeGroup);

      emit(CreateGroupStoreSuccessState(storeGroup));
    } on AppException catch (error) {
      emit(CreateGroupStoreErrorState(error.message));
    } on ApiException catch (error) {
      emit(CreateGroupStoreErrorState(error.message));
    } catch (error) {
      emit(CreateGroupStoreErrorState(error.toString()));
    }
  }

  Future<void> _fetchGroupsStore(
      FetchGroupsStoreEvent event, Emitter<TransactionalState> emit) async {
    emit(const FetchGroupsStoreLoadingState());
    try {
      final groups = await _transactionRepository.getGroups(event.userId);
      emit(FetchGroupsStoreSuccessState(groups));
    } on AppException catch (error) {
      emit(FetchGroupsStoreErrorState(error.message));
    } on ApiException catch (error) {
      emit(FetchGroupsStoreErrorState(error.message));
    } catch (error) {
      emit(FetchGroupsStoreErrorState(error.toString()));
    }
  }

  Future<void> _createExpenseStore(
      CreateExpenseStoreEvent event, Emitter<TransactionalState> emit) async {
    emit(const CreateExpenseStoreLoadingState());
    try {
      await _transactionRepository.createExpense(
          event.expense, event.membersCharged);
      emit(const CreateExpenseStoreSuccessState());
    } on AppException catch (error) {
      emit(CreateExpenseStoreErrorState(error.message));
    } on ApiException catch (error) {
      emit(CreateExpenseStoreErrorState(error.message));
    } catch (error) {
      emit(CreateExpenseStoreErrorState(error.toString()));
    }
  }

  Future<void> _fetchExpensesStore(
      FetchExpensesStoreEvent event, Emitter<TransactionalState> emit) async {
    emit(const FetchGroupsStoreLoadingState());
    try {
      final groups = await _transactionRepository.getExpenses(event.groupId);
      emit(FetchExpensesStoreSuccessState(groups));
    } on AppException catch (error) {
      emit(FetchExpensesStoreErrorState(error.message));
    } on ApiException catch (error) {
      emit(FetchExpensesStoreErrorState(error.message));
    } catch (error) {
      emit(FetchExpensesStoreErrorState(error.toString()));
    }
  }

  Future<void> _migrateData(
      MigrateDataEvent event, Emitter<TransactionalState> emit) async {
    emit(const MigrateDataLoadingState());
    try {
      await _transactionRepository.migrateData(event.userId);
      emit(const MigrateDataSuccessState());
    } on AppException catch (error) {
      emit(MigrateDataErrorState(error.message));
    } on ApiException catch (error) {
      emit(MigrateDataErrorState(error.message));
    } catch (error) {
      emit(MigrateDataErrorState(error.toString()));
    }
  }

  Future<void> _joinGroup(
      JoinGroupEvent event, Emitter<TransactionalState> emit) async {
    emit(const JoinGroupLoadingState());
    try {
      await _transactionRepository.joinGroup(event.groupId, event.userId);
      emit(const JoinGroupSuccessState());
    } on AppException catch (error) {
      emit(JoinGroupErrorState(error.message));
    } on ApiException catch (error) {
      emit(JoinGroupErrorState(error.message));
    } catch (error) {
      emit(JoinGroupErrorState(error.toString()));
    }
  }

  Future<void> _fetchChargesStore(
      FetchChargesStoreEvent event, Emitter<TransactionalState> emit) async {
    emit(const FetchChargesStoreLoadingState());

    try {
      final List<Map<String, dynamic>> charges =
          await _transactionRepository.getCharges(event.groupId, event.userId);
      emit(FetchChargesStoreSuccessState(charges));
    } on AppException catch (error) {
      emit(FetchChargesStoreErrorState(error.message));
    } catch (error) {
      emit(FetchChargesStoreErrorState(error.toString()));
    }
  }

  //local
  Future<void> _createGroup(
      CreateGroupEvent event, Emitter<TransactionalState> emit) async {
    emit(const CreateGroupLoadingState());
    try {
      await _transactionalLocalRepository.createGroup(
          event.group, event.participants);
      emit(const CreateGroupSuccessState());
    } on AppException catch (error) {
      emit(CreateGroupErrorState(error.message));
    } on ApiException catch (error) {
      emit(CreateGroupErrorState(error.message));
    } catch (error) {
      emit(CreateGroupErrorState(error.toString()));
    }
  }

  Future<void> _fetchGroups(
      FetchGroupsEvent event, Emitter<TransactionalState> emit) async {
    emit(const FetchGroupsLoadingState());
    try {
      final groups = await _transactionalLocalRepository.getGroups();
      emit(FetchGroupsSuccessState(groups));
    } on AppException catch (error) {
      emit(FetchGroupsErrorState(error.message));
    } on ApiException catch (error) {
      emit(FetchGroupsErrorState(error.message));
    } catch (error) {
      emit(FetchGroupsErrorState(error.toString()));
    }
  }

  Future<void> _createExpense(
      CreateExpenseEvent event, Emitter<TransactionalState> emit) async {
    emit(const CreateExpenseLoadingState());
    try {
      await _transactionalLocalRepository.createExpense(event.expense);
      emit(const CreateExpenseSuccessState());
    } on AppException catch (error) {
      emit(CreateExpenseErrorState(error.message));
    } catch (error) {
      emit(CreateExpenseErrorState(error.toString()));
    }
  }

  Future<void> _fetchExpenses(
      FetchExpensesEvent event, Emitter<TransactionalState> emit) async {
    emit(const FetchGroupsLoadingState());
    try {
      final groups =
          await _transactionalLocalRepository.getExpenses(event.groupId);
      emit(FetchExpensesSuccessState(groups));
    } on AppException catch (error) {
      emit(FetchExpensesErrorState(error.message));
    } catch (error) {
      emit(FetchExpensesErrorState(error.toString()));
    }
  }

  Future<void> _fetchParticipants(
      FetchParticipantsEvent event, Emitter<TransactionalState> emit) async {
    emit(const FetchParticipantsLoadingState());
    try {
      final participants =
          await _transactionalLocalRepository.getParticipants(event.groupId);
      emit(FetchParticipantsSuccessState(participants));
    } on AppException catch (error) {
      emit(FetchParticipantsErrorState(error.message));
    } catch (error) {
      emit(FetchParticipantsErrorState(error.toString()));
    }
  }
}
