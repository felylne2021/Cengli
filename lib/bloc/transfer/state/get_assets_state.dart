import 'package:cengli/data/modules/transfer/model/response/assets_response.dart';

import '../transfer.dart';

class GetAssetsLoadingState extends TransferState {
  const GetAssetsLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetAssetsErrorState extends TransferState {
  final String message;

  const GetAssetsErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetAssetsSuccessState extends TransferState {
  final AssetsResponse assets;
  
  const GetAssetsSuccessState(this.assets) : super();

  @override
  List<Object?> get props => [assets];
}
