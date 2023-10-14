import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';

import '../transfer.dart';

class GetAssetsTransferLoadingState extends TransferState {
  const GetAssetsTransferLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetAssetsTransferErrorState extends TransferState {
  final String message;

  const GetAssetsTransferErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetAssetsTransferSuccessState extends TransferState {
  final AssetsResponse assets;
  
  const GetAssetsTransferSuccessState(this.assets) : super();

  @override
  List<Object?> get props => [assets];
}
