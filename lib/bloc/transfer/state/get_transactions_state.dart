
import '../../../data/modules/transfer/model/response/transaction_response.dart';
import '../transfer.dart';

class GetTransactionsLoadingState extends TransferState {
  const GetTransactionsLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetTransactionsErrorState extends TransferState {
  final String message;

  const GetTransactionsErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetTransactionsSuccessState extends TransferState {
  final List<TransactionResponse> transactions;
  
  const GetTransactionsSuccessState(this.transactions) : super();

  @override
  List<Object?> get props => [transactions];
}
