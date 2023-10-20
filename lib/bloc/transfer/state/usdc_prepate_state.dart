import '../transfer.dart';

class UsdcPrepareLoadingState extends TransferState {
  const UsdcPrepareLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class UsdcPrepareErrorState extends TransferState {
  final String message;

  const UsdcPrepareErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class UsdcPrepareSuccessState extends TransferState {
  final String response;

  const UsdcPrepareSuccessState(this.response) : super();

  @override
  List<Object?> get props => [response];
}
