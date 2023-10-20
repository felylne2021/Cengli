import 'package:cengli/bloc/membership/membership.dart';

class RequestPartnerLoadingState extends MembershipState {
  const RequestPartnerLoadingState() : super();

  @override
  List<Object?> get props => [];
}

class RequestPartnerErrorState extends MembershipState {
  final String message;

  const RequestPartnerErrorState(this.message) : super();

  @override
  List<Object?> get props => [message];
}

class RequestPartnerSuccessState extends MembershipState {
  const RequestPartnerSuccessState() : super();

  @override
  List<Object?> get props => [];
}
