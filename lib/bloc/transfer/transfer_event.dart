import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:velix/velix.dart';

import '../../data/modules/transactional/model/group.dart';

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

  const CreateGroupP2pEvent(this.group);

  @override
  List<Object?> get props => [group];
}

class CreateOrderEvent extends TransferEvent {
  final OrderResponse order;

  const CreateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class GetOrderEvent extends TransferEvent {
  final String groupId;

  const GetOrderEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class UpdateOrderStatusEvent extends TransferEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatusEvent(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}

class PostTransferEvent extends TransferEvent {
  final TransferRequest param;

  const PostTransferEvent(this.param);

  @override
  List<Object?> get props => [param];
}