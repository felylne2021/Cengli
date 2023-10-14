import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
import 'package:cengli/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';

import 'transfer.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRemoteRepository _transferRemoteRepository;

  TransferBloc(this._transferRemoteRepository)
      : super(const TransferInitiateState()) {
    on<GetAssetsEvent>(_onGetAssets, transformer: sequential());
    on<GetChainsEvent>(_onGetChains, transformer: sequential());
    on<GetTransactionsEvent>(_onGetTransactions, transformer: sequential());
  }

  Future<void> _onGetAssets(
      GetAssetsEvent event, Emitter<TransferState> emit) async {
    emit(const GetAssetsLoadingState());
    try {
      final address = await SessionService.getWalletAddress();
      final assets =
          await _transferRemoteRepository.getAssets(address, event.chainId);

      emit(GetAssetsSuccessState(assets));
    } on AppException catch (error) {
      emit(GetAssetsErrorState(error.message));
    } catch (error) {
      emit(GetAssetsErrorState(error.toString()));
    }
  }

  Future<void> _onGetChains(
      GetChainsEvent event, Emitter<TransferState> emit) async {
    emit(const GetChainsLoadingState());
    try {
      final chains = await _transferRemoteRepository.getChains();
      emit(GetChainsSuccessState(chains));
    } on AppException catch (error) {
      emit(GetChainsErrorState(error.message));
    } catch (error) {
      emit(GetChainsErrorState(error.toString()));
    }
  }

  Future<void> _onGetTransactions(
      GetTransactionsEvent event, Emitter<TransferState> emit) async {
    emit(const GetTransactionsLoadingState());
    try {
      final transactions = await _transferRemoteRepository.getTransactions(event.userId);
      emit(GetTransactionsSuccessState(transactions));
    } on AppException catch (error) {
      emit(GetTransactionsErrorState(error.message));
    } catch (error) {
      emit(GetTransactionsErrorState(error.toString()));
    }
  }
}
