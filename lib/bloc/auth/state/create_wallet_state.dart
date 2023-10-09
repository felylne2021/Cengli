import 'package:cengli/bloc/auth/auth.dart';

class CreateWalletLoadingState extends AuthState {
  const CreateWalletLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CreateWalletErrorState extends AuthState {
  final String message;

  const CreateWalletErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CreateWalletSuccessState extends AuthState {

  const CreateWalletSuccessState() : super();

  @override
  List<Object?> get props => [];
}
