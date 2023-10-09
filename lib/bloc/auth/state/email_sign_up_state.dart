import 'package:cengli/bloc/auth/auth.dart';

class EmailSignUpLoadingState extends AuthState {
  const EmailSignUpLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class EmailSignUpErrorState extends AuthState {
  final String message;

  const EmailSignUpErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class EmailSignUpSuccessState extends AuthState {

  const EmailSignUpSuccessState() : super();

  @override
  List<Object?> get props => [];
}
