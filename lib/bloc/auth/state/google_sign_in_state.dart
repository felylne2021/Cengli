import 'package:cengli/bloc/auth/auth.dart';

class GoogleSignInLoadingState extends AuthState {
  const GoogleSignInLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GoogleSignInErrorState extends AuthState {
  final String message;

  const GoogleSignInErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GoogleSignInSuccessState extends AuthState {
  const GoogleSignInSuccessState() : super();

  @override
  List<Object?> get props => [];
}
