import 'package:velix/velix.dart';

abstract class AuthState extends BaseState {
  const AuthState() : super();
}

class AuthInitiateState extends AuthState {
  const AuthInitiateState() : super();

  @override
  List<Object?> get props => [];
}

