import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/presentation/p2p/order_detail_page.dart';

class UpdateOrderStatusLoadingState extends TransferState {
  const UpdateOrderStatusLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class UpdateOrderStatusErrorState extends TransferState {
  final String message;

  const UpdateOrderStatusErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class UpdateOrderStatusSuccessState extends TransferState {
  final OrderStatusEventEnum status;
  const UpdateOrderStatusSuccessState(this.status) : super();

  @override
  List<Object?> get props => [status];
}
