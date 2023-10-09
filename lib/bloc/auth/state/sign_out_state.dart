import 'package:cengli/bloc/auth/auth.dart';

class SignOutLoadingState extends AuthState {
  const SignOutLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class SignOutErrorState extends AuthState {
  final String message;

  const SignOutErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class SignOutSuccessState extends AuthState {
  const SignOutSuccessState() : super();

  @override
  List<Object?> get props => [];
}
