import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';

import '../transfer.dart';

class GetChainsLoadingState extends TransferState {
  const GetChainsLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetChainsErrorState extends TransferState {
  final String message;

  const GetChainsErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetChainsSuccessState extends TransferState {
  final List<ChainResponse> chains;
  
  const GetChainsSuccessState(this.chains) : super();

  @override
  List<Object?> get props => [chains];
}
