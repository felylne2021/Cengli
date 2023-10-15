import 'package:cengli/bloc/membership/membership.dart';

class GetGroupOrderLoadingState extends MembershipState {
  const GetGroupOrderLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class GetGroupOrderErrorState extends MembershipState {
  final String message;

  const GetGroupOrderErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class GetGroupOrderSuccessState extends MembershipState {
  final bool isP2p;

  const GetGroupOrderSuccessState(this.isP2p) : super();

  @override
  List<Object?> get props => [isP2p];
}
