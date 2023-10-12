import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/data/modules/transactional/transactional_local_repository.dart';
import 'package:cengli/data/modules/transactional/transactional_remote_repository.dart';
import 'package:cengli/utils/signer.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';
import 'package:ethers/signers/wallet.dart' as ethers;

import '../../services/services.dart';
import 'transactional.dart';

class TransactionalBloc extends Bloc<TransactionalEvent, TransactionalState> {
  final TransactionalLocalRepository _transactionalLocalRepository;
  final TransactionalRemoteRepository _transactionRepository;

  TransactionalBloc(
      this._transactionalLocalRepository, this._transactionRepository)
      : super(const TransactionalInitiateState()) {
    //Remote
    on<CreateGroupStoreEvent>(_createGroupStore, transformer: sequential());
    on<FetchGroupsStoreEvent>(_fetchGroupsStore, transformer: sequential());
    on<CreateExpenseStoreEvent>(_createExpenseStore, transformer: sequential());
    on<FetchExpensesStoreEvent>(_fetchExpensesStore, transformer: sequential());
    on<MigrateDataEvent>(_migrateData, transformer: sequential());
    on<JoinGroupEvent>(_joinGroup, transformer: sequential());

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
      final privateKey = await SessionService.getSignerAddress(walletAddress);

      final group = await createGroup(
          groupName: event.group.name ?? "",
          signer: EthersSigner(
              ethersWallet: ethers.Wallet.fromPrivateKey(privateKey),
              address: walletAddress),
          groupDescription: event.group.groupDescription ?? "",
          members: event.group.members ?? [],
          admins: [],
          isPublic: false);

      final storeGroup = Group(
          id: group?.chatId ?? "",
          groupDescription: event.group.groupDescription,
          name: event.group.name,
          members: event.group.members ?? []);

      await _transactionRepository.createGroup(storeGroup);

      emit(CreateGroupStoreSuccessState(storeGroup));
    } on AppException catch (error) {
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
    } catch (error) {
      emit(FetchGroupsStoreErrorState(error.toString()));
    }
  }

  Future<void> _createExpenseStore(
      CreateExpenseStoreEvent event, Emitter<TransactionalState> emit) async {
    emit(const CreateExpenseStoreLoadingState());
    try {
      await _transactionRepository.createExpense(event.expense);
      emit(const CreateExpenseStoreSuccessState());
    } on AppException catch (error) {
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
      print(groups);
      emit(FetchExpensesStoreSuccessState(groups));
    } on AppException catch (error) {
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
    } catch (error) {
      emit(JoinGroupErrorState(error.toString()));
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
