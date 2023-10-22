import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';

class GetReceiverChainsLoadingState extends TransferState {
  const GetReceiverChainsLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetReceiverChainsErrorState extends TransferState {
  final String message;

  const GetReceiverChainsErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetReceiverChainsSuccessState extends TransferState {
  final List<ChainResponse> chains;
  const GetReceiverChainsSuccessState(this.chains) : super();

  @override
  List<Object?> get props => [chains];
}
