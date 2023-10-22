import '../../../data/modules/transfer/model/response/get_bridge_info_response.dart';
import '../transfer.dart';

class GetBridgeInfoLoadingState extends TransferState {
  const GetBridgeInfoLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetBridgeInfoErrorState extends TransferState {
  final String message;

  const GetBridgeInfoErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetBridgeInfoSuccessState extends TransferState {
  final GetBridgeInfoResponse response;

  const GetBridgeInfoSuccessState(this.response) : super();

  @override
  List<Object?> get props => [response];
}
