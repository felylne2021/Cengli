import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';

class GetPartnersLoadingState extends TransferState {
  const GetPartnersLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetPartnersErrorState extends TransferState {
  final String message;

  const GetPartnersErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetPartnersSuccessState extends TransferState {
  final List<GetPartnersResponse> partners;

  const GetPartnersSuccessState(this.partners) : super();

  @override
  List<Object?> get props => [];
}
