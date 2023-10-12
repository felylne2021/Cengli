import 'package:cengli/bloc/membership/membership.dart';

class ApproveChatLoadingState extends MembershipState {
  const ApproveChatLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class ApproveChatErrorState extends MembershipState {
  final String message;

  const ApproveChatErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class ApproveChatSuccessState extends MembershipState {
  const ApproveChatSuccessState() : super();

  @override
  List<Object?> get props => [];
}
