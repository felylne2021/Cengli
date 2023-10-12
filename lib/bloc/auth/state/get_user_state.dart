import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';

class GetUserDataLoadingState extends AuthState {
  const GetUserDataLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetUserDataErrorState extends AuthState {
  const GetUserDataErrorState(this.error) : super();
  final String error;
  @override
  List<Object?> get props => [error];
}

class GetUserDataSuccessState extends AuthState {
  const GetUserDataSuccessState(this.user) : super();
  final UserProfile user;
  @override
  List<Object?> get props => [user];
}
