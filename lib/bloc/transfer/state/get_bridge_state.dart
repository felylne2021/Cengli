import 'package:cengli/bloc/transfer/transfer.dart';

import '../../../data/modules/transfer/model/response/get_bridge_info_response.dart';

class GetBridgeLoadingState extends TransferState {
  const GetBridgeLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetBridgeErrorState extends TransferState {
  final String message;

  const GetBridgeErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetBridgeSuccessState extends TransferState {
  final GetBridgeInfoResponse response;

  const GetBridgeSuccessState(this.response) : super();

  @override
  List<Object?> get props => [response];
}
