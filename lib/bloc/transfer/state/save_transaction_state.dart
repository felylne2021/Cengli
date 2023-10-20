import '../transfer.dart';

class SaveTransactionLoadingState extends TransferState {
  const SaveTransactionLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class SaveTransactionErrorState extends TransferState {
  final String message;

  const SaveTransactionErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class SaveTransactionSuccessState extends TransferState {
  const SaveTransactionSuccessState() : super();

  @override
  List<Object?> get props => [];
}
