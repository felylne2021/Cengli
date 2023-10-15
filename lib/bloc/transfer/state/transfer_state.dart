import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/transfer/model/response/transfer_response.dart';


class PostTransferLoadingState extends TransferState {
  const PostTransferLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class PostTransferErrorState extends TransferState {
  final String message;

  const PostTransferErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class PostTransferSuccessState extends TransferState {
  final TransferResponse response;

  const PostTransferSuccessState(this.response) : super();

  @override
  List<Object?> get props => [];
}
