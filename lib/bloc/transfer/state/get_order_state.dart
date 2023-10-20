import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/transfer/model/response/order_response.dart';

class GetOrderLoadingState extends TransferState {
  const GetOrderLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetOrderErrorState extends TransferState {
  final String message;

  const GetOrderErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetOrderSuccessState extends TransferState {
  final OrderResponse orderResponse;

  const GetOrderSuccessState(this.orderResponse) : super();

  @override
  List<Object?> get props => [orderResponse];
}
