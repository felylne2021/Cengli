import 'package:cengli/bloc/transfer/transfer.dart';

class CreateOrderLoadingState extends TransferState {
  const CreateOrderLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CreateOrderErrorState extends TransferState {
  final String message;

  const CreateOrderErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CreateOrderSuccessState extends TransferState {
  const CreateOrderSuccessState() : super();

  @override
  List<Object?> get props => [];
}
