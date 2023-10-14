import 'package:velix/velix.dart';

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