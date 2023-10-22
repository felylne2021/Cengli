import '../transfer.dart';

class PrepareUsdcBridgeLoadingState extends TransferState {
  const PrepareUsdcBridgeLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class PrepareUsdcBridgeErrorState extends TransferState {
  final String message;

  const PrepareUsdcBridgeErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class PrepareUsdcBridgeSuccessState extends TransferState {
  final String response;

  const PrepareUsdcBridgeSuccessState(this.response) : super();

  @override
  List<Object?> get props => [response];
}
