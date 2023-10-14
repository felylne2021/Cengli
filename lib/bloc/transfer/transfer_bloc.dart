import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/data/modules/transactional/transactional_remote_repository.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cengli/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';
import 'package:ethers/signers/wallet.dart' as ethers;

import '../../data/modules/transactional/model/group.dart';
import '../../data/utils/collection_util.dart';
import '../../utils/signer.dart';
import 'transfer.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRemoteRepository _transferRemoteRepository;
  final TransactionalRemoteRepository _transactionalRemoteRepository;

  TransferBloc(
      this._transferRemoteRepository, this._transactionalRemoteRepository)
      : super(const TransferInitiateState()) {
    on<GetAssetsEvent>(_onGetAssets, transformer: sequential());
    on<GetChainsEvent>(_onGetChains, transformer: sequential());
    on<GetTransactionsEvent>(_onGetTransactions, transformer: sequential());
    on<CreateGroupP2pEvent>(_onCreateGroupP2p, transformer: sequential());
    on<CreateOrderEvent>(_onCreateOrder, transformer: sequential());
    on<GetOrderEvent>(_onGetOrder, transformer: sequential());
    on<UpdateOrderStatusEvent>(_onUpdateOrder, transformer: sequential());
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
      final transactions =
          await _transferRemoteRepository.getTransactions(event.userId);
      emit(GetTransactionsSuccessState(transactions));
    } on AppException catch (error) {
      emit(GetTransactionsErrorState(error.message));
    } catch (error) {
      emit(GetTransactionsErrorState(error.toString()));
    }
  }

  Future<void> _onCreateGroupP2p(
      CreateGroupP2pEvent event, Emitter<TransferState> emit) async {
    emit(const CreateGroupP2pLoadingState());
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
          members: event.group.members ?? [],
          groupType: GroupTypeEnum.p2p.name);

      await _transactionalRemoteRepository.createGroup(storeGroup);

      emit(CreateGroupP2pSuccessState(storeGroup));
    } on AppException catch (error) {
      emit(CreateGroupP2pErrorState(error.message));
    } catch (error) {
      emit(CreateGroupP2pErrorState(error.toString()));
    }
  }

  Future<void> _onCreateOrder(
      CreateOrderEvent event, Emitter<TransferState> emit) async {
    emit(const CreateOrderLoadingState());
    try {
      await _transferRemoteRepository.createOrder(event.order);
      emit(const CreateOrderSuccessState());
    } on AppException catch (error) {
      emit(CreateOrderErrorState(error.message));
    } catch (error) {
      emit(CreateOrderErrorState(error.toString()));
    }
  }

  Future<void> _onGetOrder(
      GetOrderEvent event, Emitter<TransferState> emit) async {
    emit(const GetOrderLoadingState());
    try {
      final order = await _transferRemoteRepository.getOrder(event.groupId);
      emit(GetOrderSuccessState(order));
    } on AppException catch (error) {
      emit(GetOrderErrorState(error.message));
    } catch (error) {
      emit(GetOrderErrorState(error.toString()));
    }
  }

  Future<void> _onUpdateOrder(
      UpdateOrderStatusEvent event, Emitter<TransferState> emit) async {
    emit(const UpdateOrderStatusLoadingState());
    try {
      await _transferRemoteRepository.updateOrder(event.orderId, event.status);
      emit(const UpdateOrderStatusSuccessState());
    } on AppException catch (error) {
      emit(UpdateOrderStatusErrorState(error.message));
    } catch (error) {
      emit(UpdateOrderStatusErrorState(error.toString()));
    }
  }
}
