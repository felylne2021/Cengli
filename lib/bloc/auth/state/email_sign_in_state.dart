import 'package:cengli/bloc/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailSignInLoadingState extends AuthState {
  const EmailSignInLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class EmailSignInErrorState extends AuthState {
  final String message;

  const EmailSignInErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class EmailSignInSuccessState extends AuthState {
  final UserCredential userCred;

  const EmailSignInSuccessState(this.userCred) : super();

  @override
  List<Object?> get props => [];
}
