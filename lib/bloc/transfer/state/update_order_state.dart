import 'package:cengli/bloc/transfer/transfer.dart';

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
  const UpdateOrderStatusSuccessState() : super();

  @override
  List<Object?> get props => [];
}
