import 'package:cengli/bloc/auth/auth.dart';

class CheckUsernameLoadingState extends AuthState {
  const CheckUsernameLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class CheckUsernameErrorState extends AuthState {
  final String message;

  const CheckUsernameErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class CheckUsernameSuccessState extends AuthState {
  final bool isExist;

  const CheckUsernameSuccessState(this.isExist) : super();

  @override
  List<Object?> get props => [isExist];
}
