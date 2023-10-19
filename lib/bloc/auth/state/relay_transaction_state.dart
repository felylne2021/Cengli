import 'package:cengli/bloc/auth/auth.dart';

class RelayTransactionLoadingState extends AuthState {
  const RelayTransactionLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class RelayTransactionErrorState extends AuthState {
  final String message;

  const RelayTransactionErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class RelayTransactionSuccessState extends AuthState {
  const RelayTransactionSuccessState() : super();

  @override
  List<Object?> get props => [];
}
