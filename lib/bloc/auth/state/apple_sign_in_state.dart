import 'package:cengli/bloc/auth/auth.dart';

class AppleSignInLoadingState extends AuthState {
  const AppleSignInLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class AppleSignInErrorState extends AuthState {
  final String message;

  const AppleSignInErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class AppleSignInSuccessState extends AuthState {
  const AppleSignInSuccessState() : super();

  @override
  List<Object?> get props => [];
}
