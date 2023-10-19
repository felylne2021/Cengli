import 'package:cengli/bloc/membership/membership_state.dart';

class UpdateUserNameSuccessState extends MembershipState {
  const UpdateUserNameSuccessState() : super();
  @override
  List<Object?> get props => [];
}

class UpdateUserNameErrorState extends MembershipState {
  final String message;

  const UpdateUserNameErrorState(this.message) : super();
  @override
  List<Object?> get props => [message];
}
