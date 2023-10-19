import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/data/modules/transactional/transactional_remote_repository.dart';
import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cengli/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';
import 'package:ethers/signers/wallet.dart' as ethers;

import '../../data/modules/transactional/model/group.dart';
import '../../data/utils/collection_util.dart';
import '../../presentation/p2p/order_detail_page.dart';
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
    on<GetOrderEvent>(_onGetOrder, transformer: sequential());
    on<UpdateOrderStatusEvent>(_onUpdateOrder, transformer: sequential());
    on<PostTransferEvent>(_onPostTransfer, transformer: sequential());
    on<GetPartnersEvent>(_onGetPartners, transformer: sequential());
    on<PrepareTransactionEvent>(_onPrepareTransaction, transformer: sequential());
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
      final privateKey = await SessionService.getPrivateKey(walletAddress);

      // Create group on push
      final group = await createGroup(
          groupName: event.group.name ?? "",
          signer: EthersSigner(
              ethersWallet: ethers.Wallet.fromPrivateKey(privateKey),
              address: walletAddress),
          groupDescription: "P2P Order",
          members: event.group.members ?? [],
          admins: [],
          isPublic: false);

      // Create order
      final orderCreated = await _transferRemoteRepository.postOrder(
          CreateOrderRequest(
              partnerId: event.order.partnerId,
              buyerUserId: event.order.buyerUserId,
              buyerAddress: event.order.buyerAddress,
              amount: event.order.amount,
              chainId: event.order.chainId,
              destinationChainId: event.order.destinationChainId,
              chatId: group?.chatId,
              tokenAddress: event.order.tokenAddress));

      // Create group on firestore
      final storeGroup = Group(
          id: group?.chatId ?? "",
          groupDescription: "P2P Order",
          name: event.group.name,
          members: event.group.members ?? [],
          groupType: GroupTypeEnum.p2p.name,
          p2pOrderId: orderCreated.id ?? "");

      await _transactionalRemoteRepository.createGroup(storeGroup);

      emit(CreateGroupP2pSuccessState(storeGroup));
    } on AppException catch (error) {
      emit(CreateGroupP2pErrorState(error.message));
    } catch (error) {
      emit(CreateGroupP2pErrorState(error.toString()));
    }
  }

  Future<void> _onGetOrder(
      GetOrderEvent event, Emitter<TransferState> emit) async {
    emit(const GetOrderLoadingState());
    try {
      final order = await _transferRemoteRepository.getOrder(event.orderId);
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
      switch (event.status) {
        case OrderStatusEventEnum.accept:
          await _transferRemoteRepository.acceptOrder(
              event.orderId, event.callerUserId);
          emit(UpdateOrderStatusSuccessState(event.status));
          break;
        case OrderStatusEventEnum.cancel:
          await _transferRemoteRepository.cancelOrder(
              event.orderId, event.callerUserId);
          emit(UpdateOrderStatusSuccessState(event.status));
          break;
        case OrderStatusEventEnum.payment:
          await _transferRemoteRepository.payOrder(
              event.orderId, event.callerUserId);
          emit(UpdateOrderStatusSuccessState(event.status));
          break;
        case OrderStatusEventEnum.fund:
          await _transferRemoteRepository.fundOrder(
              event.orderId, event.callerUserId);
          emit(UpdateOrderStatusSuccessState(event.status));
          break;
      }
    } on AppException catch (error) {
      emit(UpdateOrderStatusErrorState(error.message));
    } catch (error) {
      emit(UpdateOrderStatusErrorState(error.toString()));
    }
  }

  Future<void> _onPostTransfer(
      PostTransferEvent event, Emitter<TransferState> emit) async {
    emit(const PostTransferLoadingState());
    try {
      final response =
          await _transferRemoteRepository.postTransfer(event.param);
      emit(PostTransferSuccessState(response));
    } on AppException catch (error) {
      emit(PostTransferErrorState(error.message));
    } on ApiException catch (error) {
      emit(PostTransferErrorState(error.message));
    } catch (error) {
      emit(PostTransferErrorState(error.toString()));
    }
  }

  Future<void> _onGetPartners(
      GetPartnersEvent event, Emitter<TransferState> emit) async {
    emit(const GetPartnersLoadingState());
    try {
      final response = await _transferRemoteRepository.getPartners();
      emit(GetPartnersSuccessState(response));
    } on AppException catch (error) {
      emit(GetPartnersErrorState(error.message));
    } on ApiException catch (error) {
      emit(GetPartnersErrorState(error.message));
    } catch (error) {
      emit(GetPartnersErrorState(error.toString()));
    }
  }

   Future<void> _onPrepareTransaction(
      PrepareTransactionEvent event, Emitter<TransferState> emit) async {
    emit(const PrepareTransactionLoadingState());
    try {
      final response = await _transferRemoteRepository.prepareTx(event.param);
      emit(PrepareTransactionSuccessState(response));
    } on AppException catch (error) {
      emit(PrepareTransactionErrorState(error.message));
    } on ApiException catch (error) {
      emit(PrepareTransactionErrorState(error.message));
    } catch (error) {
      emit(PrepareTransactionErrorState(error.toString()));
    }
  }
}
