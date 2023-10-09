
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/data/transactional/transactional_local_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';

import '../../data/transactional/transactional_remote_repository.dart';
import 'transactional.dart';

class TransactionalBloc extends Bloc<TransactionalEvent, TransactionalState> {
  final TransactionalLocalRepository _transactionLocalRepository;
  final TransactionalRemoteRepository _transactionRepository;

  TransactionalBloc(
      this._transactionLocalRepository, this._transactionRepository)
      : super(const TransactionalInitiateState()) {
    //local
    on<CreateGroupEvent>(_createGroup, transformer: sequential());
    on<FetchGroupsEvent>(_fetchGroups, transformer: sequential());
    on<CreateExpenseEvent>(_createExpense, transformer: sequential());
    on<FetchExpensesEvent>(_fetchExpenses, transformer: sequential());
    on<FetchParticipantsEvent>(_fetchParticipants, transformer: sequential());

    //Remote
    on<CreateGroupStoreEvent>(_createGroupStore, transformer: sequential());
    on<FetchGroupsStoreEvent>(_fetchGroupsStore, transformer: sequential());
    on<CreateExpenseStoreEvent>(_createExpenseStore, transformer: sequential());
    on<FetchExpensesStoreEvent>(_fetchExpensesStore, transformer: sequential());
    on<MigrateDataEvent>(_migrateData, transformer: sequential());
    on<JoinGroupEvent>(_joinGroup, transformer: sequential());
  }

  //local
  Future<void> _createGroup(
      CreateGroupEvent event, Emitter<TransactionalState> emit) async {
    emit(const CreateGroupLoadingState());
    try {
      await _transactionLocalRepository.createGroup(
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
      final groups = await _transactionLocalRepository.getGroups();
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
      await _transactionLocalRepository.createExpense(event.expense);
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
          await _transactionLocalRepository.getExpenses(event.groupId);
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
          await _transactionLocalRepository.getParticipants(event.groupId);
      emit(FetchParticipantsSuccessState(participants));
    } on AppException catch (error) {
      emit(FetchParticipantsErrorState(error.message));
    } catch (error) {
      emit(FetchParticipantsErrorState(error.toString()));
    }
  }

  //Remote
  Future<void> _createGroupStore(
      CreateGroupStoreEvent event, Emitter<TransactionalState> emit) async {
    emit(const CreateGroupStoreLoadingState());
    try {
      await _transactionRepository.createGroup(event.group);
      emit(const CreateGroupStoreSuccessState());
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
}
