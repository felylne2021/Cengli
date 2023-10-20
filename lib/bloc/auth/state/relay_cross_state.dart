import 'package:cengli/bloc/auth/auth.dart';

class RelayCrossTransactionLoadingState extends AuthState {
  const RelayCrossTransactionLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class RelayCrossTransactionErrorState extends AuthState {
  final String message;

  const RelayCrossTransactionErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class RelayCrossTransactionSuccessState extends AuthState {
  const RelayCrossTransactionSuccessState() : super();

  @override
  List<Object?> get props => [];
}
