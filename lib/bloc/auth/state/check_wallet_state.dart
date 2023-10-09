import 'package:cengli/bloc/auth/auth.dart';

class CheckWalletLoadingState extends AuthState {
  const CheckWalletLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CheckWalletErrorState extends AuthState {
  final String message;

  const CheckWalletErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CheckWalletSuccessState extends AuthState {
  final bool isWalletExist;

  const CheckWalletSuccessState(this.isWalletExist) : super();

  @override
  List<Object?> get props => [isWalletExist];
}
