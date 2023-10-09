import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/data/auth/model/response/signer_address_response.dart';

class PredictSignerLoadingState extends AuthState {
  const PredictSignerLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class PredictSignerErrorState extends AuthState {
  final String message;

  const PredictSignerErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class PredictSignerSuccessState extends AuthState {
  final SignerAddressResponse response;

  const PredictSignerSuccessState(this.response) : super();

  @override
  List<Object?> get props => [response];
}
