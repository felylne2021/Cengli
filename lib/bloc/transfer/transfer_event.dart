import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/model/request/prepare_erc20_request.dart';
import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:velix/velix.dart';

import '../../data/modules/transactional/model/group.dart';
import '../../presentation/p2p/order_detail_page.dart';

abstract class TransferEvent extends BaseEvent {
  const TransferEvent();
}

class GetAssetsEvent extends TransferEvent {
  final int chainId;

  const GetAssetsEvent(this.chainId);

  @override
  List<Object?> get props => [chainId];
}

class GetChainsEvent extends TransferEvent {
  const GetChainsEvent();

  @override
  List<Object?> get props => [];
}

class GetTransactionsEvent extends TransferEvent {
  final String userId;

  const GetTransactionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetTransferEvent extends TransferEvent {
  final int chainId;

  const GetTransferEvent(this.chainId);

  @override
  List<Object?> get props => [chainId];
}

class CreateGroupP2pEvent extends TransferEvent {
  final Group group;
  final CreateOrderRequest order;

  const CreateGroupP2pEvent(this.group, this.order);

  @override
  List<Object?> get props => [group];
}

class GetOrderEvent extends TransferEvent {
  final String orderId;

  const GetOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatusEvent extends TransferEvent {
  final String orderId;
  final String callerUserId;
  final OrderStatusEventEnum status;

  const UpdateOrderStatusEvent(this.orderId, this.callerUserId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}

class PostTransferEvent extends TransferEvent {
  final TransferRequest param;

  const PostTransferEvent(this.param);

  @override
  List<Object?> get props => [param];
}

class GetPartnersEvent extends TransferEvent {
  const GetPartnersEvent();

  @override
  List<Object?> get props => [];
}

class PrepareTransactionEvent extends TransferEvent {
  final PrepareErc20Request param;

  const PrepareTransactionEvent(this.param);

  @override
  List<Object?> get props => [param];
}
