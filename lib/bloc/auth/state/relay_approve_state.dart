import 'package:cengli/bloc/auth/auth.dart';

class RelayApproveTransactionLoadingState extends AuthState {
  const RelayApproveTransactionLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class RelayApproveTransactionErrorState extends AuthState {
  final String message;

  const RelayApproveTransactionErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class RelayApproveTransactionSuccessState extends AuthState {
  const RelayApproveTransactionSuccessState() : super();

  @override
  List<Object?> get props => [];
}
