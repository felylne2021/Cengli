import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/data/modules/transactional/transactional_remote_repository.dart';
import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/transfer_remote_repository.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:cengli/services/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velix/velix.dart';
import 'package:ethers/signers/wallet.dart' as ethers;

import '../../data/modules/membership/model/request/notification_payload_request.dart';
import '../../data/modules/membership/model/request/send_notif_request.dart';
import '../../data/modules/transactional/model/group.dart';
import '../../data/utils/collection_util.dart';
import '../../presentation/p2p/order_detail_page.dart';
import '../../utils/signer.dart';
import 'transfer.dart';

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRemoteRepository _transferRemoteRepository;
  final TransactionalRemoteRepository _transactionalRemoteRepository;
  final MembershipRemoteRepository _membershipRemoteRepository;

  TransferBloc(this._transferRemoteRepository,
      this._transactionalRemoteRepository, this._membershipRemoteRepository)
      : super(const TransferInitiateState()) {
    on<GetAssetsEvent>(_onGetAssets, transformer: sequential());
    on<GetChainsEvent>(_onGetChains, transformer: sequential());
    on<GetReceiverChainsEvent>(_onGetReceiverChains, transformer: sequential());
    on<GetTransactionsEvent>(_onGetTransactions, transformer: sequential());
    on<CreateGroupP2pEvent>(_onCreateGroupP2p, transformer: sequential());
    on<GetOrderEvent>(_onGetOrder, transformer: sequential());
    on<UpdateOrderStatusEvent>(_onUpdateOrder, transformer: sequential());
    on<PostTransferEvent>(_onPostTransfer, transformer: sequential());
    on<GetPartnersEvent>(_onGetPartners, transformer: sequential());
    on<PrepareTransactionEvent>(_onPrepareTransaction,
        transformer: sequential());
    on<SaveTransactionEvent>(_onSaveTransaction, transformer: sequential());
    on<GetBridgeEvent>(_onGetBridge, transformer: sequential());
    on<PrepareBridgeTransferEvent>(_onPrepareBridge, transformer: sequential());
    on<GetBridgeInfoEvent>(_onGetBridgeInfo, transformer: sequential());
    on<PrepareUsdcBridgeTransferEvent>(_onPrepareUsdcBridge,
        transformer: sequential());
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
    } on ApiException catch (error) {
      emit(GetAssetsErrorState(error.message));
    } catch (error) {
      emit(GetAssetsErrorState(error.toString()));
    }
  }

  Future<void> _onGetReceiverChains(
      GetReceiverChainsEvent event, Emitter<TransferState> emit) async {
    emit(const GetReceiverChainsLoadingState());
    try {
      final chains = await _transferRemoteRepository.getChains();
      emit(GetReceiverChainsSuccessState(chains));
    } on AppException catch (error) {
      emit(GetReceiverChainsErrorState(error.message));
    } on ApiException catch (error) {
      emit(GetReceiverChainsErrorState(error.message));
    } catch (error) {
      emit(GetReceiverChainsErrorState(error.toString()));
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
    } on ApiException catch (error) {
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
    } on ApiException catch (error) {
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

      // Send notification
      final members = event.group.members ?? [];

      if (members.contains(walletAddress)) {
        members.remove(walletAddress);
      }
      final targetedMembers = members;
      _membershipRemoteRepository.sendNotification(SendNotifRequest(
          walletAddresses: targetedMembers,
          notificationPayload: const NotificationPayloadRequest(
              title: "P2P", body: "New Order!", screen: "order")));

      emit(CreateGroupP2pSuccessState(
          Feeds(chatId: group?.chatId ?? "", groupInformation: group),
          storeGroup));
    } on AppException catch (error) {
      emit(CreateGroupP2pErrorState(error.message));
    } on ApiException catch (error) {
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
    } on ApiException catch (error) {
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
    } on ApiException catch (error) {
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

  Future<void> _onSaveTransaction(
      SaveTransactionEvent event, Emitter<TransferState> emit) async {
    emit(const PostTransferLoadingState());
    try {
      await _transferRemoteRepository.postTransfer(event.param);
      emit(const SaveTransactionSuccessState());
    } on AppException catch (error) {
      emit(SaveTransactionErrorState(error.message));
    } on ApiException catch (error) {
      emit(SaveTransactionErrorState(error.message));
    } catch (error) {
      emit(SaveTransactionErrorState(error.toString()));
    }
  }

  Future<void> _onGetBridge(
      GetBridgeEvent event, Emitter<TransferState> emit) async {
    emit(const GetBridgeLoadingState());
    try {
      final response = await _transferRemoteRepository.getBridgeInfo(
          event.fromChainId, event.destinationChainId, event.tokenAddress);
      emit(GetBridgeSuccessState(response));
    } on AppException catch (error) {
      emit(GetBridgeErrorState(error.message));
    } on ApiException catch (error) {
      emit(GetBridgeErrorState(error.message));
    } catch (error) {
      emit(GetBridgeErrorState(error.toString()));
    }
  }

  Future<void> _onPrepareBridge(
      PrepareBridgeTransferEvent event, Emitter<TransferState> emit) async {
    emit(const PrepareBridgeLoadingState());
    try {
      final response =
          await _transferRemoteRepository.prepareBridgeTx(event.param);
      emit(PrepareBridgeSuccessState(response));
    } on AppException catch (error) {
      emit(PrepareBridgeErrorState(error.message));
    } on ApiException catch (error) {
      emit(PrepareBridgeErrorState(error.message));
    } catch (error) {
      emit(PrepareBridgeErrorState(error.toString()));
    }
  }

  Future<void> _onGetBridgeInfo(
      GetBridgeInfoEvent event, Emitter<TransferState> emit) async {
    emit(const GetBridgeInfoLoadingState());
    try {
      final response = await _transferRemoteRepository.getBridgeInfo(
          event.fromChainId, event.destinationChainId, event.tokenAddress);
      emit(GetBridgeInfoSuccessState(response));
    } on AppException catch (error) {
      emit(GetBridgeInfoErrorState(error.message));
    } on ApiException catch (error) {
      emit(GetBridgeInfoErrorState(error.message));
    } catch (error) {
      emit(GetBridgeInfoErrorState(error.toString()));
    }
  }

  Future<void> _onPrepareUsdcBridge(
      PrepareUsdcBridgeTransferEvent event, Emitter<TransferState> emit) async {
    emit(const PrepareUsdcBridgeLoadingState());
    try {
      final response =
          await _transferRemoteRepository.prepareUsdcBridgeTx(event.param);
      emit(PrepareUsdcBridgeSuccessState(response));
    } on AppException catch (error) {
      emit(PrepareUsdcBridgeErrorState(error.message));
    } on ApiException catch (error) {
      emit(PrepareUsdcBridgeErrorState(error.message));
    } catch (error) {
      emit(PrepareUsdcBridgeErrorState(error.toString()));
    }
  }
}
