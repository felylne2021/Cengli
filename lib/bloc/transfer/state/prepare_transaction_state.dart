import '../transfer.dart';

class PrepareTransactionLoadingState extends TransferState {
  const PrepareTransactionLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class PrepareTransactionErrorState extends TransferState {
  final String message;

  const PrepareTransactionErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class PrepareTransactionSuccessState extends TransferState {
  final String response;

  const PrepareTransactionSuccessState(this.response) : super();

  @override
  List<Object?> get props => [response];
}
