import '../transfer.dart';

class PrepareBridgeLoadingState extends TransferState {
  const PrepareBridgeLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class PrepareBridgeErrorState extends TransferState {
  final String message;

  const PrepareBridgeErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class PrepareBridgeSuccessState extends TransferState {
  final String response;

  const PrepareBridgeSuccessState(this.response) : super();

  @override
  List<Object?> get props => [response];
}
