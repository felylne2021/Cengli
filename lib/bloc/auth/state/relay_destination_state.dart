import 'package:cengli/bloc/auth/auth.dart';

class RelayDestinationTransactionLoadingState extends AuthState {
  const RelayDestinationTransactionLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class RelayDestinationTransactionErrorState extends AuthState {
  final String message;

  const RelayDestinationTransactionErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class RelayDestinationTransactionSuccessState extends AuthState {
  const RelayDestinationTransactionSuccessState() : super();

  @override
  List<Object?> get props => [];
}
